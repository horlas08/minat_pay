import 'package:flutter/material.dart';

import '../../../../../config/color.constant.dart';
import '../../../../../config/font.constant.dart';

class Coupon extends StatelessWidget {
  const Coupon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter Coupon",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppFont.mulish,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
              signed: false,
            ),
            decoration: const InputDecoration(
              hintText: "xxxx-xxxxx-xxxx",
              hintStyle: TextStyle(
                fontSize: 18,
                color: AppColor.primaryColor,
              ),
              disabledBorder: InputBorder.none,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onTapOutside: (v) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ],
      ),
    );
  }
}
