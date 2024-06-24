import 'package:dio/src/response.dart';
import 'package:minat_pay/data/login_service.dart';

class LoginRepo {
  final String password;
  final String username;

  LoginRepo({
    required this.password,
    required this.username,
  });

  Future<Response?> loginResponse() async {
    final res = await LoginService(
      username: username,
      password: password,
    ).request();

    return res;
  }
}
