import 'package:dio/dio.dart';
import 'package:form_validator/form_validator.dart';

import '../service/http.dart';

extension PasswordValidationBuilder on ValidationBuilder {
  password() => add((value) {
        if (value == 'password') {
          return 'Password should not "password"';
        }
        return null;
      });
  matches(n) => add((value) {
        if (value != n) {
          return 'Password Not Match';
        }
        return null;
      });
}

Future<Response?> curlGetRequest(
    String path, Object? data, Map<String, dynamic> queryParams) async {
  try {
    Response res =
        await dio.get(path, data: data, queryParameters: queryParams);
    return res;
  } on DioException catch (error) {
    return error.response;
  }
}

Future<Response?> curlPostRequest(
    {required String path,
    Object? data,
    Map<String, dynamic>? queryParams,
    Options? options}) async {
  try {
    Response res = await dio.post(path,
        data: data, queryParameters: queryParams, options: options);
    return res;
  } on DioException catch (error) {
    return error.response;
  }
}
