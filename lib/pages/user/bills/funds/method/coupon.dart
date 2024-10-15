import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/app.config.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../config/color.constant.dart';
import '../../../../../config/font.constant.dart';
import '../../../../../widget/Button.dart';

final _couponKeyForm = GlobalKey<FormState>();
final _couponController = TextEditingController();

class Coupon extends StatelessWidget {
  const Coupon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _couponKeyForm,
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
              // keyboardType: const TextInputType.numberWithOptions(
              //   decimal: false,
              //   signed: false,
              // ),
              controller: _couponController,
              autovalidateMode: AutovalidateMode.onUnfocus,
              validator: ValidationBuilder().required().build(),
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
            const SizedBox(
              height: 20,
            ),
            Button(
              onpressed: () async {
                if (_couponKeyForm.currentState!.validate()) {
                  await requestFundWithCoupon(context);
                }
              },
              child: const Text(
                'Fund Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> requestFundWithCoupon(BuildContext context) async {
  context.loaderOverlay.show();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final res = await curlPostRequest(
    path: couponFunding,
    data: {
      'coupon': _couponController.text,
      'token': prefs.getString('token'),
    },
  );

  print(res);
  if (context.mounted) {
    context.loaderOverlay.hide();
    if (res?.statusCode == HttpStatus.ok) {
      _couponController.text = '';
      await alertHelper(context, 'success', res?.data['message']);
    } else {
      _couponController.text = '';
      await alertHelper(context, 'error', res?.data['message']);
    }
  }
}
