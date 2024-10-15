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
        emit(state.failed("Unknown Error"));
      }
      print(res);
      if (res?.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", res?.data['token']);
        prefs.setBool("isVerified", res?.data['user_data']['is_verified']);
        prefs.setString("userName", res?.data['user_data']['username']);
        prefs.setString("userEmail", res?.data['user_data']['email']);
        emit(state.success(res?.data['code'], res?.data['user_data']['email']));
      } else {
        // emit(state.failed('${res?.data['message']}'));
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
