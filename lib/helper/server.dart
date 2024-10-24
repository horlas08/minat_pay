import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:minat_pay/config/app.config.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../model/main_response.dart';

Future handleResponse(Response<dynamic> response) async {
  // if (!await isNetworkAvailable()) {
  //   print("no internet");
  //   throw errorInternetNotAvailable;
  // }

  if (response.statusCode.isSuccessful()) {
    return response.data;
  } else {
    try {
      var body = response.data;
      throw body['message'];
    } on Exception catch (e) {
      log(e);
      // throw errorSomethingWentWrong;
    }
  }
}

Future<MainResponse> fetchData() async {
  final dio = Dio();
  final response = await dio.get(backendUrl);

  return await handleResponse(response).then((json1) async {
    final mModel = MainResponse.fromJson(json1);
    appServer.saveServerResponse(json1);
    return mModel;
  }).catchError((e) {
    log(e);
    print(e);
    throw e;
  });
}

Color hexStringToHexInt(String hex) {
  hex = hex.replaceFirst('#', '');
  hex = hex.length == 6 ? 'ff$hex' : hex;
  int val = int.parse(hex, radix: 16);
  return Color(val);
}
