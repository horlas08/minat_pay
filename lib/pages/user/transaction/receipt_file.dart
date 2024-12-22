import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../config/color.constant.dart';
import '../../../config/font.constant.dart';
import '../../../helper/helper.dart';

class ReceiptFile extends StatelessWidget {
  final Map<String, String> data;
  const ReceiptFile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 2500,
        width: 500,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: const BoxDecoration(
          color: AppColor.primaryColor,
        ),
        child: Container(
          height: 2400,
          width: 500,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 7,
              ),
              const Text(
                "Transaction Receipt",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.mulish,
                    color: AppColor.greyColor,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Image.asset(
                  "assets/images/MinatPay-LOGO.png",
                  width: 150,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                " ${data['amount']!}",
                style: TextStyle(
                    fontSize: 25,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.mulish),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                data['status']!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${data['datetime']!}",
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColor.greyColor,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ...List.generate(
                data.length,
                (index) {
                  return RowList(
                    key: data.keys.toList()[index],
                    value: data.values.toList()[index],
                    showLine: data.values.length != index + 1,
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Support"),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "Thank you for using MinatPay",
                style: TextStyle(color: AppColor.primaryColor),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const AutoSizeText(
                "This receipt serves as evidence of the transaction.If you have any complaints, Please WhasApp us on 09138796779 or Email us at minatpay@gmail.com",
                style: TextStyle(
                  color: AppColor.greyColor,
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
