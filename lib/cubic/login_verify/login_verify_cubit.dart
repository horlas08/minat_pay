import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:minat_pay/repo/login_verify_2_repo.dart';

import '../../repo/login_verify_repo.dart';
import 'login_verify_state.dart';

class LoginVerifyCubit extends Cubit<LoginVerifyState> {
  LoginVerifyCubit() : super(LoginVerifyInit(authState: false));

  Future<void> onLoginVerifyRequested(String? password) async {
    try {
      emit(LoginVerifyLoading());
      late Response<dynamic>? res;
      if (password == null) {
        res = await LoginVerifyWithOutPasswordRepo().loginVerifyResponse();
      } else {
        res = await LoginVerifyRepo(password: password).loginVerifyResponse();
      }

      print("______");
      print(res);
      print("______");

      if (res == null) {
        return emit(LoginVerifyFailed("Check Your Connection"));
      }
      if (res.data == null) {
        return emit(
            LoginVerifyFailed("App Is Currently Down At This Moment Use Web"));
      }

      if (res.statusCode == HttpStatus.ok) {
        final accounts = (res.data['data']['accounts'] as List)
            .map((itemWord) => itemWord as Map<String, dynamic>)
            .toList();

        final userData = res.data['data']['user_data'];
        emit(LoginVerifySuccess(userData: userData, accounts: accounts));
      } else {
        if (res.data.containsKey('missing_parameters') &&
            !res.data['missing_parameters'].isEmpty) {
          emit(LoginVerifyFailed(res.data['missing_parameters']?[0]));
        } else {
          emit(LoginVerifyFailed(res.data['message']));
        }
      }
    } on DioException catch (error) {
      emit(LoginVerifyFailed(error.toString()));
    } on Exception catch (error) {
      emit(LoginVerifyFailed(error.toString()));
    }
  }
}
