import 'package:dio/src/response.dart';
import 'package:minat_pay/data/email_verification_service.dart';

class EmailVerifyRepo {
  final String? otp;

  EmailVerifyRepo({
    this.otp,
  });

  Future<Response?> emailVerifyResponse() async {
    final res = await EmailVerificationService(
      otp: otp,
    ).request();

    return res;
  }

  Future<Response?> emailVerifyResendResponse() async {
    final res = await EmailVerificationService().resend();

    return res;
  }
}
