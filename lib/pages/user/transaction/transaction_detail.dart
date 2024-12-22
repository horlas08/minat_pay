import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app.config.dart';
import '../../../helper/helper.dart';
import '../../../model/transaction_details.dart';
import '../../../widget/app_header.dart';

class TransactionDetail extends HookWidget {
  final String id;
  const TransactionDetail({
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> loading = useState(true);
    final ValueNotifier<Uint8List?> bytes = useState(null);
    final ValueNotifier<TransactionDetailsModel> transaction =
        useState(TransactionDetailsModel());
    Future<Response?> getTransactionDetails(BuildContext context,
        {required String id,
        required ValueNotifier<bool> loading,
        required ValueNotifier<TransactionDetailsModel>
            transactionDetail}) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      loading.value = true;
      final res = await curlGetRequest(path: singleTransactionPath, data: {
        'trxid': id,
        'token': prefs.getString('token'),
      });

      if (res == null && context.mounted) {
        return alertHelper(context, 'error', "Check Your Internet Connection");
      }
      print(res?.data['transaction_details']);
      try {
        transactionDetail.value =
            TransactionDetailsModel.fromMap(res?.data['transaction_details']);
        print("_______");
        print(jsonEncode(transactionDetail.value));
        print("_______");
        await prefs.setString(
            "lastTransactionData", jsonEncode(transactionDetail.value));
        loading.value = false;
      } catch (error) {
        print(error);
      }

      return null;

      // return res;
    }

    useEffect(() {
      if (bytes.value != null) buildImage(bytes.value!);
      return null;
    }, [bytes.value]);

    useEffect(() {
      getTransactionDetails(context,
          id: id, loading: loading, transactionDetail: transaction);
      return null;
    }, []);

    return Scaffold(
      appBar: const AppHeader(
        title: "Transaction Details",
        showAction: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: loading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      flex: 14,
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Positioned(
                                top: -20,
                                left: 0,
                                right: 0,
                                child: CircleAvatar(
                                  child: Icon(Icons.add),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 100,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      AppColor.primaryColor.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Text(
                                      transaction.value.service!,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "${transaction.value.amount}",
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontFamily: AppFont.mulish,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: AppColor.success,
                                          size: 20,
                                        ),
                                        Text(
                                          "Successful",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: AppColor.success,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(15),
                            constraints: const BoxConstraints(
                              minHeight: 100,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  "Transaction Details",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TransactionRow(
                                  left: 'Transaction Id',
                                  right: transaction.value.trxid,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TransactionRow(
                                  left: 'Date',
                                  right: DateFormat.yMMMEd().format(
                                    DateTime.parse(transaction.value.datetime!),
                                  ),
                                ),
                                TransactionRow(
                                  left: '',
                                  right: DateFormat('kk:mm:a').format(
                                    DateTime.parse(
                                      transaction.value.datetime!,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TransactionRow(
                                  left: 'Description',
                                  right: transaction.value.message,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            context.pushNamed('transactionReceipt');
                            // final res = await shareController.capture();
                            // bytes.value = res;
                            //
                            // final dir = await getTemporaryDirectory();
                            // final dest = path.join(dir.path, "widget.png");
                            // final file = await File(dest)
                            //     .writeAsBytes(bytes.value as List<int>);
                            //
                            // final result = await Share.shareXFiles(
                            //     [XFile('${dest}')],
                            //     text: 'Transaction Receipt');
                          },
                          child: const Text(
                            "Share Receipt",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget buildImage(Uint8List bytes) => Image.memory(bytes);

  Widget TransactionRow({required String left, required dynamic right}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              left,
              // style: const TextStyle(color: Colors.black),
            ),
          ),
          right is String
              ? Expanded(
                  flex: 2,
                  child: Text(
                    textAlign: TextAlign.right,
                    right,
                    style: const TextStyle(
                      // color: Colors.black,
                      fontFamily: AppFont.mulish,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : right,
        ],
      );
}
