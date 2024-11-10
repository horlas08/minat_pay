import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app.config.dart';
import '../helper/helper.dart';

class LoginVerifyService {
  final String password;

  LoginVerifyService({
    required this.password,
  });

  Future<Response?> request() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Response? res = await curlPostRequest(path: loginVerify, data: {
      'password': password,
      'token': prefs.getString('token'),
    });

    return res;
  }
}
