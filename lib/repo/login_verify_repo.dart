import 'package:dio/src/response.dart';

import '../data/login_verify_service.dart';

class LoginVerifyRepo {
  final String? password;

  LoginVerifyRepo({
    this.password,
  });

  Future<Response?> loginVerifyResponse() async {
    final res = await LoginVerifyService(
      password: password!,
    ).request();

    return res;
  }
}
