import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../bloc/repo/app/app_state.dart';
import '../../../config/app.config.dart';
import '../../../config/color.constant.dart';
import '../../../config/font.constant.dart';
import '../../../helper/helper.dart';

final _formKey = GlobalKey<FormState>();

class Referral extends HookWidget {
  const Referral({super.key});

  @override
  Widget build(BuildContext context) {
    final _oldPinController = useTextEditingController();
    final _newPinController = useTextEditingController();
    final _confirmPinController = useTextEditingController();
    final amountController = useTextEditingController();

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

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final balance = double.tryParse(state.user!.refBal.toString());
        final currencyFormatter =
            NumberFormat.currency(locale: "en_NG", symbol: "₦");
        String formattedCurrency = currencyFormatter.format(balance ?? 0.0);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: const AppHeader(title: "Referral Program"),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Refer your friends and earn",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.mulish,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "use your referral code to invite your friends and earn once they join, fund their account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.mulish,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'assets/images/referral.png',
                        height: 300,
                      ),
                      const Text(
                        "Your Referral Code",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.mulish,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color:
                                isLight(context) ? Colors.black : Colors.white,
                            style: BorderStyle.solid,
                            // strokeAlign: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                state.user!.username!,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: isLight(context)
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              width: 80,
                              child: TouchableOpacity(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: state.user!.username!,
                                    ),
                                  ).then(
                                    (value) {
                                      if (!context.mounted) return;
                                      alertHelper(context, 'success',
                                          'Copy Successfully');
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.copy_sharp,
                                      color: isLight(context)
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    const Text(
                                      "copy",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "You will only receive your bonus once your friends or the person you refer have fund their wallet with more than 1,500 Naira",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFont.mulish,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Referral Balance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  "${formattedCurrency}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFont.mulish,
                                  ),
                                ),
                                const Spacer(),
                                TouchableOpacity(
                                  onTap: () async {
                                    // showAppDialog(child: Text('data'),);
                                    showAppDialog(
                                      context,
                                      useRootNavigator: true,
                                      child: Form(
                                        key: _formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                  decimal: false,
                                                  signed: false,
                                                ),
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: ValidationBuilder()
                                                    .required()
                                                    .build(),
                                                controller: amountController,
                                                style: const TextStyle(
                                                    color:
                                                        AppColor.primaryColor),
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Enter Amount",
                                                  hintStyle: TextStyle(
                                                    fontSize: 18,
                                                    color:
                                                        AppColor.primaryColor,
                                                  ),
                                                  border: InputBorder.none,
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  focusedErrorBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                ),
                                                onTapOutside: (v) {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                },
                                              ),
                                              Spacer(),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();

                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    try {
                                                      context.loaderOverlay
                                                          .show();
                                                      final res =
                                                          await curl2PostRequest(
                                                              path:
                                                                  postWithdrawal,
                                                              data: {
                                                                'amount':
                                                                    amountController
                                                                        .text,
                                                              },
                                                              options: Options(
                                                                  headers: {
                                                                    'Authorization': context
                                                                        .read<
                                                                            AppBloc>()
                                                                        .state
                                                                        .user
                                                                        ?.apiKey
                                                                  }));
                                                      if (res?.statusCode ==
                                                          HttpStatus.ok) {
                                                        if (context.mounted) {
                                                          context.loaderOverlay
                                                              .hide();
                                                          context.pop();
                                                          await alertHelper(
                                                              context,
                                                              'success',
                                                              res?.data[
                                                                  'message']);
                                                        }
                                                      } else {
                                                        throw Exception(res
                                                            ?.data['message']);
                                                      }
                                                    } on DioException catch (error) {
                                                      if (context.mounted) {
                                                        context.loaderOverlay
                                                            .hide();
                                                        context.pop();
                                                        await alertHelper(
                                                            context,
                                                            'error',
                                                            error.response
                                                                    ?.data[
                                                                'message']);
                                                      }
                                                    } on Exception catch (error) {
                                                      if (context.mounted) {
                                                        context.loaderOverlay
                                                            .hide();
                                                        context.pop();
                                                        await alertHelper(
                                                            context,
                                                            'error',
                                                            error.toString());
                                                      }
                                                    } finally {
                                                      amountController.text =
                                                          '';
                                                    }
                                                  }
                                                },
                                                style: ButtonStyle(
                                                  minimumSize:
                                                      WidgetStateProperty.all(
                                                    const Size.fromHeight(65),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Withdraw Now",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );

                                    return;
                                    try {
                                      final url =
                                          Uri.parse("https://minatpay.com");
                                      await launchUrl(url);
                                    } on PlatformException catch (error) {
                                      if (!context.mounted) return;
                                      await alertHelper(context, 'error',
                                          error.message ?? "error");
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "withdraw",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
