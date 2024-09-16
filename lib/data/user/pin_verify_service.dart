import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app.config.dart';
import '../../helper/helper.dart';

class PinVerifyService {
  final String pin;

  PinVerifyService({required this.pin});

  Future<Response?> request() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Response? res = await curlPostRequest(path: verifyPin, data: {
      'pin': pin,
      'token': prefs.getString('token'),
    });
    return res;
  }
}
