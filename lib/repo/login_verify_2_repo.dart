import 'package:dio/src/response.dart';
import 'package:minat_pay/data/login_verify_2_service.dart';

class LoginVerifyWithOutPasswordRepo {
  LoginVerifyWithOutPasswordRepo();

  Future<Response?> loginVerifyResponse() async {
    final res = await LoginVerifyWithOutPasswordService().request();

    return res;
  }
}
