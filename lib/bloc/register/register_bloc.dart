import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repo/register_repo.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState().init()) {
    on<InitEvent>(_init);
    on<RegisterRequestEvent>(_onRegisterRequest);
  }

  void _init(InitEvent event, Emitter<RegisterState> emit) async {
    emit(state.init());
  }

  @override
  void onChange(Change<RegisterState> change) {
    super.onChange(change);
    print('$change');
  }

  void _onRegisterRequest(
      RegisterRequestEvent event, Emitter<RegisterState> emit) async {
    try {
      emit(state.loading());
      final res = await RegisterRepo(
              firstname: event.firstname,
              phone: event.phone,
              email: event.email,
              code: event.code,
              username: event.username,
              lastname: event.lastname,
              password: event.password)
          .registerResponse();

      if (res == null) {
        emit(state.failed("Request Timeout Kindly Try And Login Before Retry"));
      }

      if (res?.statusCode == 200) {
        try {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("token", res?.data['token']);
          await prefs.setBool(
              "isVerified", res?.data['user_data']['isVerified']);
          await prefs.setString("userName", res?.data['user_data']['username']);
          await prefs.setString("userEmail", res?.data['user_data']['email']);
          final accounts = (res?.data['accounts'] as List)
              .map((itemWord) => itemWord as Map<String, dynamic>)
              .toList();
          emit(
            state.success(res?.data['message'], res?.data['user_data']['email'],
                res?.data['user_data'], accounts),
          );
        } catch (error) {
          print(error);
          emit(state.failed(error.toString()));
        }
      } else {
        if (res?.data.containsKey('missing_parameters') &&
            !res?.data['missing_parameters'].isEmpty) {
          emit(state.failed('${res?.data['missing_parameters']?[0]}'));
        } else {
          emit(state.failed('${res?.data['message']}'));
        }
      }
    } on DioException catch (err) {
      emit(state.failed(err.toString()));
      emit(state.init());
    }
    emit(state.init());
  }
}
