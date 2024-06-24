import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../repo/login_verify_repo.dart';
import 'login_verify_state.dart';

class LoginVerifyCubit extends Cubit<LoginVerifyState> {
  LoginVerifyCubit() : super(LoginVerifyInit(authState: false));

  Future<void> onLoginVerifyRequested(String password) async {
    try {
      emit(LoginVerifyLoading());
      final res =
          await LoginVerifyRepo(password: password).loginVerifyResponse();
      if (res == null) {
        emit(LoginVerifyFailed("Check Your Connection"));
      }
      if (res?.statusCode == 200) {
        emit(LoginVerifySuccess());
      } else {
        if (res?.data.containsKey('missing_parameters') &&
            !res?.data['missing_parameters'].isEmpty) {
          emit(LoginVerifyFailed(res?.data['missing_parameters']?[0]));
        } else {
          emit(LoginVerifyFailed(res?.data['message']));
        }
      }
    } on DioException catch (error) {
      emit(LoginVerifyFailed(error.toString()));
    }
  }
}
