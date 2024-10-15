import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../../config/color.constant.dart';
import '../../../config/font.constant.dart';
import '../../../model/transaction_details.dart';
import '../../../widget/app_header.dart';

WidgetsToImageController shareController = WidgetsToImageController();

Future<void> fetchCacheData(ValueNotifier<TransactionDetailsModel> transaction,
    ValueNotifier<bool> loading) async {
  loading.value = true;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString("lastTransactionData")!);
  transaction.value = TransactionDetailsModel.fromMap(
      jsonDecode(prefs.getString("lastTransactionData")!));
  loading.value = false;
}

class Receipt extends HookWidget {
  const Receipt({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Uint8List?> bytes = useState(null);
    final ValueNotifier<bool> loading = useState(true);

    final transaction = useState(
      TransactionDetailsModel(
          message: '', amount: '', datetime: '', service: ''),
    );
    useEffect(() {
      fetchCacheData(transaction, loading);

      return null;
    }, []);
    return Scaffold(
      appBar: const AppHeader(
        title: "Transaction Receipt",
        showAction: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: loading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    flex: 14,
                    child: WidgetsToImage(
                      controller: shareController,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 35,
                            ),
                            ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/minatpay_icon.png',
                                width: 50,
                              ),
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 3,
                              ),
                              margin: const EdgeInsets.all(10),
                              constraints: const BoxConstraints(
                                minHeight: 100,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 5,
                                    offset: const Offset(0, 15),
                                    spreadRadius: 15,
                                    blurStyle: BlurStyle.outer,
                                  )
                                ],
                                color: Colors.white,
                                // borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        'assets/images/MinatPay-LOGO.png',
                                        height: 20,
                                      ),
                                      const Text(
                                        "Receipt From Minat Pay ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text('${DateFormat.yMMMEd().format(
                                      DateTime.parse(
                                        transaction.value.datetime!,
                                      ),
                                    )} ${DateFormat('kk:mm:a').format(DateTime.parse(
                                      transaction.value.datetime!,
                                    ))}'),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TransactionRow(
                                    left: 'Amount',
                                    right: transaction.value.amount,
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
                                    left: 'Status',
                                    right: const Row(
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
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // if (transaction.value.data != null &&
                                  //     transaction.value.data!.isNotEmpty)
                                  //   ...List.generate(
                                  //     transaction.value.data!.length,
                                  //     (index) {
                                  //       return TransactionRow(
                                  //         left: 'Status',
                                  //         right: const Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.center,
                                  //           children: [
                                  //             Icon(
                                  //               Icons.check_circle,
                                  //               color: AppColor.success,
                                  //               size: 20,
                                  //             ),
                                  //             Text(
                                  //               "Successful",
                                  //               style: TextStyle(
                                  //                 fontSize: 20,
                                  //                 color: AppColor.success,
                                  //                 fontWeight: FontWeight.normal,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       );
                                  //     },
                                  //   ),
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
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await shareController.capture();
                        bytes.value = res;

                        final dir = await getTemporaryDirectory();
                        final dest = path.join(dir.path, "widget.png");
                        final file = await File(dest)
                            .writeAsBytes(bytes.value as List<int>);

                        final result = await Share.shareXFiles(
                            [XFile('${dest}')],
                            text: 'Transaction Receipt');
                      },
                      child: const Text(
                        "Share Receipt",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

Widget TransactionRow({required String left, required dynamic right}) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        right is String
            ? Expanded(
                flex: 2,
                child: Text(
                  textAlign: TextAlign.right,
                  right,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppFont.mulish,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : right,
      ],
    );
