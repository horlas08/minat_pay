import 'package:dio/dio.dart';

import '../helper/helper.dart';

class RegistrationService {
  final String firstname;
  final String lastname;
  final String password;
  final String email;
  final String username;
  final String phone;

  RegistrationService(
      {required this.firstname,
      required this.lastname,
      required this.password,
      required this.email,
      required this.username,
      required this.phone});

  Future<Response?> request() async {
    Response? res = await curlPostRequest(path: '/register', data: {
      'firstname': firstname,
      "lastname": lastname,
      'email': email,
      'password': password,
      'username': username,
      'mobile': '12344',
      'password_confirmation': password,
      'country_code': '234',
    });
    return res;
  }
}
