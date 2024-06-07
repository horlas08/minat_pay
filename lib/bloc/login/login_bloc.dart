import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:minat_pay/repo/register_repo.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState().init()) {
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
      final res = await RegisterRepo(
              firstname: 'test',
              phone: '993993',
              email: 'test',
              username: 'test',
              lastname: 'qozeem',
              password: '1234')
          .registerResponse();
      if (res == null) {
        emit(state.failed());
      }
      if (res?.statusCode == 200) {
      } else {
        emit(state.failed());
      }
    } on DioException catch (err) {
      emit(state.failed());
    }
  }
}
