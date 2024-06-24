import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app.config.dart';
import '../helper/helper.dart';

class EmailVerificationService {
  final String? otp;

  EmailVerificationService({
    this.otp,
  });

  Future<Response?> request() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Response? res = await curlPostRequest(path: confirmOtp, data: {
      'otp': otp,
      'token': prefs.getString('token'),
    });
    return res;
  }

  Future<Response?> resend() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Response? res = await curlPostRequest(path: resendOtp, data: {
      'token': prefs.getString('token'),
    });
    return res;
  }
}
