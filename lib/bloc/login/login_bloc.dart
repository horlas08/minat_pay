import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:minat_pay/repo/login_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInit()) {
    on<LoginInitEvent>(_init);
    on<LoginRequestEvent>(_onLoginRequested);
  }

  void _init(LoginInitEvent event, Emitter<LoginState> emit) async {
    emit(state.init());
  }

  @override
  void onChange(Change<LoginState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print('change ---> $change');
  }

  void _onLoginRequested(
      LoginRequestEvent event, Emitter<LoginState> emit) async {
    try {
      emit(state.loading());
      final res =
          await LoginRepo(username: event.username, password: event.password)
              .loginResponse();

      if (res == null) {
        return emit(state.failed("Check Internet Connection"));
      }
      if (res.statusCode == HttpStatus.ok) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", res.data['data']['user_data']['token']);
        prefs.setBool(
            "isVerified", res.data['data']['user_data']['isVerified']);
        prefs.setString("userName", res.data['data']['user_data']['username']);
        if (!res.data['data']['user_data']['isVerified']) {
          prefs.setString("userEmail", res.data['data']['user_data']['email']);
        }
        print((res.data['data']['accounts']));
        final accounts = (res.data['data']['accounts'] as List)
            .map((itemWord) => itemWord as Map<String, dynamic>)
            .toList();
        return emit(state.success(
          res.data['data']['user_data'],
          accounts,
        ));
      } else {
        print("filed here");
        return emit(
          state.failed(res.data['message']),
        );
      }
    } on DioException catch (err) {
      emit(state.failed(err.toString()));
    }
  }
}
