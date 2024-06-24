import 'package:dio/dio.dart';

import '../config/app.config.dart';
import '../helper/helper.dart';

class LoginService {
  final String password;

  final String username;

  LoginService({
    required this.password,
    required this.username,
  });

  Future<Response?> request() async {
    Response? res = await curlPostRequest(path: loginPath, data: {
      'password': password,
      'emailOrUsername': username,
    });
    return res;
  }
}
