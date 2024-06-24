import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';

import '../../../config/color.constant.dart';

Future showModal(BuildContext context) {
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
                  await showModalConfirm(context, pinInputController);

                  // print("Text is : " + pinInputController.text);
                },
                keyboardFontFamily: AppFont.aeonik,
              ),
            ),
          ],
        );
      });
}

Future showModalConfirm(BuildContext context, pinInputController) {
  Size size = MediaQuery.of(context).size;

  PinInputController pinInputConfirmController = PinInputController(length: 4);

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
                if (pinInputController.text != pinInputConfirmController.text) {
                  context.pop();

                  if (context.mounted) {
                    showModal(context);
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

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Swiper(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: RectSwiperPaginationBuilder(
            color: Colors.white,
            // space: 1,
            size: Size(15, 10),
            activeSize: Size(25, 10),
            activeColor: Colors.amber,
          ),
          margin: EdgeInsets.only(top: 20),
        ),
        itemBuilder: (context, index) => Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.circular(30),
          ),
          height: 200,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total Amount Spent",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.remove_red_eye)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${currency(context)}500,344",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: AppFont.mulish,
                    ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => showModal(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.all(5),
                  width: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        child: CircleAvatar(
                          backgroundColor: AppColor.primaryColor,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Fund Wallet",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
