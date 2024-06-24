import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:minat_pay/config/color.constant.dart';

import '../service/http.dart';

String _handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return "Timeout occurred while sending or receiving";
    // case DioExceptionType.badResponse:
    //   final statusCode = error.response?.statusCode;
    //   if (statusCode != null) {
    //     switch (statusCode) {
    //       case StatusCode.badRequest:
    //         return "Bad Request";
    //       case StatusCode.unauthorized:
    //       case StatusCode.forbidden:
    //         return "Unauthorized";
    //       case StatusCode.notFound:
    //         return "Not Found";
    //       case StatusCode.conflict:
    //         return 'Conflict';
    //
    //       case StatusCode.internalServerError:
    //         return "Internal Server Error";
    //     }
    //   }
    //   break;
    case DioExceptionType.cancel:
      break;
    case DioExceptionType.unknown:
      return "No Internet Connection";
    case DioExceptionType.badCertificate:
      return "Internal Server Error";
    case DioExceptionType.connectionError:
      return "Connection Error";
    default:
      return "Unknown Error";
  }
  return "Unknown Error";
}

extension PasswordValidationBuilder on ValidationBuilder {
  password() => add((value) {
        if (value == 'password') {
          return 'Password should not "password"';
        }
        return null;
      });
  matches(String n) => add((value) {
        if (value != n) {
          return 'Password Not Match';
        }
        return null;
      });
}

extension GoRouterExtention on GoRouter {
  void clearAllRouteAndNavigate(String location) {
    while (canPop()) {
      pop();
    }
    pushReplacement(location);
  }
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

alertHelper(BuildContext context, String type, String message) async {
  return await Flushbar(
    title: type == 'error' ? 'Oops Error' : 'Success',
    message: message,
    backgroundColor: type == 'error' ? AppColor.danger : AppColor.success,
    duration: const Duration(seconds: 4),
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}

String currency(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format =
      NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
  return format.currencySymbol;
}
