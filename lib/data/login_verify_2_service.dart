import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app.config.dart';
import '../helper/helper.dart';

class LoginVerifyWithOutPasswordService {
  LoginVerifyWithOutPasswordService();

  Future<Response?> request() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Response? res = await curlGetRequest(path: getUserDetails, data: {
      'token': prefs.getString('token'),
    });
    return res;
  }
}
