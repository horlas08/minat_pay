import 'package:flutter/material.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../config/font.constant.dart';

Future paymentModal({required BuildContext context, String? title}) {
  return showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (context) {
        return Stack(children: [
          Positioned(
            left: 4,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                // context.go('/user/data');
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Center(
                  child: Text(
                    "${title ?? 'Complete Payment'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFont.aeonik,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Center(
                  child: const Text(
                    "N50.00",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFont.aeonik),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Product Name",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: AppFont.mulish,
                          fontWeight: FontWeight.bold,
                          color: AppColor.greyColor),
                    ),
                    Text(
                      "Airtime",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: AppFont.mulish,
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondaryColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Product Name",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: AppFont.mulish,
                          fontWeight: FontWeight.bold,
                          color: AppColor.greyColor),
                    ),
                    Text(
                      "Airtime",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: AppFont.mulish,
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondaryColor),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 40,
                // ),

                const SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Product Name",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppFont.mulish,
                            fontWeight: FontWeight.bold,
                            color: AppColor.greyColor),
                      ),
                      Text(
                        "AirtimeLa",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppFont.mulish,
                            fontWeight: FontWeight.bold,
                            color: AppColor.secondaryColor),
                      ),
                    ],
                  ),
                ),
                TouchableOpacity(
                  child: ElevatedButton(
                    onPressed: () {
                      paymentModal(
                          context: context, title: "Complete Data Payment");
                    },
                    style: const ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size.fromHeight(65),
                      ),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]);
      });
}
