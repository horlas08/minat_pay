import 'package:dio/src/response.dart';
import 'package:minat_pay/data/registration_data.dart';

class RegisterRepo {
  final String firstname;
  final String lastname;
  final String password;
  final String email;
  final String username;
  final String code;
  final String phone;

  RegisterRepo(
      {required this.firstname,
      required this.lastname,
      required this.password,
      required this.email,
      required this.code,
      required this.username,
      required this.phone});

  Future<Response?> registerResponse() async {
    final res = await RegistrationService(
            firstname: firstname,
            lastname: lastname,
            username: username,
            password: password,
            code: code,
            email: email,
            phone: phone)
        .request();

    return res;
  }
}
