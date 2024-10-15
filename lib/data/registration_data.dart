import 'package:dio/dio.dart';
import 'package:minat_pay/config/app.config.dart';

import '../helper/helper.dart';

class RegistrationService {
  final String firstname;
  final String lastname;
  final String password;
  final String email;
  final String code;
  final String username;
  final String phone;

  RegistrationService(
      {required this.firstname,
      required this.lastname,
      required this.password,
      required this.email,
      required this.code,
      required this.username,
      required this.phone});

  Future<Response?> request() async {
    final res = await curlPostRequest(path: signUpPath, data: {
      'firstName': firstname,
      "lastName": lastname,
      'email': email,
      'password': password,
      'username': username,
      'code': code,
      'phonenumber': phone,
      'password_confirmation': password,
    });
    return res;
  }
}
