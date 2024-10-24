import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app.config.dart';
import '../../../config/color.constant.dart';
import '../../../config/font.constant.dart';
import '../../../helper/helper.dart';

final _formKey = GlobalKey<FormState>();

class ChangePin extends HookWidget {
  const ChangePin({super.key});

  @override
  Widget build(BuildContext context) {
    final _oldPinController = useTextEditingController();
    final _newPinController = useTextEditingController();
    final _confirmPinController = useTextEditingController();
    Future<Response?> changePinRequest(BuildContext context) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final res = await curlPostRequest(
        path: changePin,
        data: {
          "old_pin": _oldPinController.text, //variationId,
          "pin": _newPinController.text, //variationId,
          "confirm_pin": _confirmPinController.text, //phone,
          "token": sharedPreferences.getString('token'), //phone,
        },
      );
      return res;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AppHeader(title: "Change Pin"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Change Transaction Pin",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFont.mulish,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationBuilder()
                          .required()
                          .minLength(4)
                          .maxLength(4)
                          .build(),
                      controller: _oldPinController,
                      style: const TextStyle(color: AppColor.primaryColor),
                      decoration: const InputDecoration(
                        hintText: "Old Pin",
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryColor,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onTapOutside: (v) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationBuilder()
                          .required()
                          .minLength(4)
                          .maxLength(4)
                          .build(),
                      controller: _newPinController,
                      style: const TextStyle(color: AppColor.primaryColor),
                      decoration: const InputDecoration(
                        hintText: "New Pin",
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryColor,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onTapOutside: (v) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationBuilder()
                          .required()
                          .maxLength(4)
                          .minLength(4)
                          .build(),
                      controller: _confirmPinController,
                      style: const TextStyle(color: AppColor.primaryColor),
                      decoration: const InputDecoration(
                        hintText: "Confirm Pin",
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryColor,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onTapOutside: (v) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (_formKey.currentState!.validate()) {
                          context.loaderOverlay.show();

                          final res = await changePinRequest(context);
                          print(res);
                          if (context.mounted) {
                            context.loaderOverlay.hide();
                          }
                          if (res == null && context.mounted) {
                            return await alertHelper(
                              context,
                              'error',
                              "Check Your Internet Connection",
                            );
                          }
                          if (res?.statusCode != HttpStatus.ok &&
                              context.mounted) {
                            await alertHelper(
                              context,
                              'error',
                              res?.data['message'],
                            );
                          } else {
                            if (context.mounted) {
                              await alertHelper(
                                context,
                                'success',
                                res?.data['message'],
                              );
                            }
                          }
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          const Size.fromHeight(65),
                        ),
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
