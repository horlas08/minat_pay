import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minat_pay/config/app.config.dart';

import '../../bloc/repo/app/app_bloc.dart';
import '../../helper/helper.dart';

class BillService {
  BillService();

  Future<Response?> airtimeRequest(
    BuildContext context, {
    required String amount,
    required String phone,
    required String network_id,
  }) async {
    Response? res = await curl2PostRequest(
        path: buyAirtime,
        data: {
          "amount": amount,
          "phone": phone,
          "trx_id":
              '$phone$network_id$amount${DateTime.now().microsecondsSinceEpoch}',
          "airtime_type": "vtu",
          "network_id": network_id
        },
        options: Options(headers: {
          'Authorization': context.read<AppBloc>().state.user?.apiKey
        }));
    return res;
  }

  Future<Response?> dataRequest(
    BuildContext context, {
    required String variationId,
    required String phone,
    String? trxId,
    required String dataType,
    required String networkId,
  }) async {
    Response? res = await curl2PostRequest(
        path: buyData,
        data: {
          "variation_id": variationId, //variationId,
          "phone": phone, //phone,
          "trx_id": trxId ?? '$phone${DateTime.now().microsecondsSinceEpoch}',
          "data_type": dataType,
          "network_id": networkId
        },
        options: Options(headers: {
          'Authorization': context.read<AppBloc>().state.user?.apiKey
        }));
    return res;
  }
}
