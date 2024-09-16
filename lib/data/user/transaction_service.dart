import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app.config.dart';
import '../../helper/helper.dart';

class TransactionService {
  final int? limit;

  TransactionService({this.limit});

  Future<Response?> request() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Response? res = await curlGetRequest(
        path: transactionPath,
        data: limit != null
            ? {
                'limit': limit,
                'token': prefs.getString('token'),
              }
            : {
                'token': prefs.getString('token'),
              });
    return res;
  }
}
