import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:minat_pay/repo/login_repo.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInit()) {
    on<InitEvent>(_init);
    on<LoginRequestEvent>(_onLoginRequested);
  }

  void _init(InitEvent event, Emitter<LoginState> emit) async {
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
        emit(state.failed("Unknown Error"));
      }
      if (res?.statusCode == HttpStatus.ok) {
        emit(state.success());
      } else {
        emit(state.failed(res?.data['message']));
      }
    } on DioException catch (err) {
      emit(state.failed(err.toString()));
    }
  }
}
