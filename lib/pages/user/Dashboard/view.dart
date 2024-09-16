import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/widget/user/dashboard/quick_action.dart';
import 'package:minat_pay/widget/user/dashboard/transaction.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../bloc/repo/app/app_event.dart';
import '../../../config/color.constant.dart';
import '../../../config/font.constant.dart';
import '../../../data/login_verify_2_service.dart';
import '../../../helper/helper.dart';
import '../../../widget/user/dashboard/balance_card.dart';
import '../../../widget/user/dashboard/header.dart';

RefreshController _refreshController = RefreshController(initialRefresh: false);
void _onRefresh(BuildContext context) async {
  _refreshController.requestLoading();

  final res = await LoginVerifyWithOutPasswordService().request();
  if (res?.statusCode == HttpStatus.ok) {
    final accounts = (res?.data['data']['accounts'] as List)
        .map((itemWord) => itemWord as Map<String, dynamic>)
        .toList();

    final userData = res?.data['data']['user_data'];
    if (context.mounted) {
      context.read<AppBloc>().add(UpdateUserEvent(userData: userData));
      context.read<AppBloc>().add(AddAccountEvent(accounts: accounts));
    }
    _refreshController.refreshCompleted();
  } else {
    _refreshController.refreshFailed();
  }

  // monitor network fetch

  // if failed,use refreshFailed()
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Future showPinModal(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    PinInputController pinInputController = PinInputController(length: 4);

    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        useRootNavigator: true,
        showDragHandle: true,
        builder: (builder) {
          return Wrap(
            children: [
              const Center(
                child: Text(
                  "Create Transaction Pin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                child: PinPlusKeyBoardPackage(
                  keyboardButtonShape: KeyboardButtonShape.rounded,
                  inputShape: InputShape.circular,
                  keyboardMaxWidth: 80,
                  btnHasBorder: false,
                  inputHasBorder: false,
                  inputFillColor: Colors.grey,
                  inputElevation: 3,
                  buttonFillColor: AppColor.primaryColor,
                  btnTextColor: Colors.white,
                  spacing: size.height * 0.06,
                  pinInputController: pinInputController,
                  onSubmit: () async {
                    /// ignore: avoid_print
                    context.pop();
                    await showPinModalConfirm(context, pinInputController);

                    // print("Text is : " + pinInputController.text);
                  },
                  keyboardFontFamily: AppFont.aeonik,
                ),
              ),
            ],
          );
        });
  }

  Future showPinModalConfirm(BuildContext context, pinInputController) {
    Size size = MediaQuery.of(context).size;

    PinInputController pinInputConfirmController =
        PinInputController(length: 4);

    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        useRootNavigator: true,
        showDragHandle: true,
        builder: (builder) {
          return Wrap(
            children: [
              const Center(
                child: Text(
                  "Confirm Transaction Pin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.aeonik,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              PinPlusKeyBoardPackage(
                keyboardButtonShape: KeyboardButtonShape.rounded,
                inputShape: InputShape.circular,
                keyboardMaxWidth: 80,
                btnHasBorder: false,
                inputHasBorder: false,
                inputFillColor: Colors.grey,
                inputElevation: 3,
                buttonFillColor: AppColor.primaryColor,
                btnTextColor: Colors.white,
                spacing: size.height * 0.06,
                pinInputController: pinInputConfirmController,
                onSubmit: () async {
                  if (pinInputController.text !=
                      pinInputConfirmController.text) {
                    context.pop();

                    if (context.mounted) {
                      showPinModal(context);
                      await alertHelper(context, 'error', "Pin Not Match");
                    }
                  }

                  /// ignore: avoid_print
                  print("Text is : " + pinInputConfirmController.text);
                },
                keyboardFontFamily: AppFont.aeonik,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SmartRefresher(
        controller: _refreshController,
        header: const WaterDropHeader(),
        onRefresh: () => _onRefresh(context),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const UserHeader(),
                  const SizedBox(
                    height: 30,
                  ),
                  TouchableOpacity(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.circle_notifications_outlined,
                            color: Colors.white,
                          ),
                          Expanded(
                            flex: 2,
                            child: TextScroll(
                              '"Stay close to anything that makes you glad you are alive." -Hafez',
                              velocity:
                                  Velocity(pixelsPerSecond: Offset(50, 0)),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const BalanceCard(),
                  const SizedBox(
                    height: 30,
                  ),
                  const QuickAction(),
                  const Transaction()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
