import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:minat_pay/widget/Button.dart';
import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';

import '../../../../../config/color.constant.dart';
import '../../../../../config/font.constant.dart';

final ImagePicker picker = ImagePicker();
final _amountController = TextEditingController(text: '0');

class Manual extends HookWidget {
  const Manual({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Monnify?> monnify = useState(null);
    final user = context.read<AppBloc>().state.user;
    void initializeMonnify() async {
      monnify.value = await Monnify.initialize(
        applicationMode: ApplicationMode.LIVE,
        apiKey: 'MK_PROD_7RQP2YJU3R',
        contractCode: '102023392663',
      );
    }

    useEffect(() {
      initializeMonnify();
      return null;
    }, []);

    void onInitializePayment() async {
      final amount = double.parse(_amountController.text);
      final paymentReference = DateTime.now().millisecondsSinceEpoch.toString();

      final transaction = TransactionDetails().copyWith(
        amount: amount,
        currencyCode: 'NGN',
        customerName: '${user?.firstName} ${user?.lastName}',
        customerEmail: user?.email,
        paymentReference: paymentReference,
        // metaData: {"ip": "196.168.45.22", "device": "mobile"},
        paymentMethods: [PaymentMethod.CARD, PaymentMethod.USSD],
        /*incomeSplitConfig: [SubAccountDetails("MFY_SUB_319452883968", 10.5, 500, true),
          SubAccountDetails("MFY_SUB_259811283666", 10.5, 1000, false)]*/
      );

      try {
        final response =
            await monnify.value?.initializePayment(transaction: transaction);

        // await alertHelper(context, 'success', response.toString());
        log(response.toString());
      } catch (e) {
        log('$e');
        await alertHelper(context, 'success', e.toString());
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Amount",
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
              controller: _amountController,
              decoration: const InputDecoration(
                hintText: "Enter Bank Name",
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
                onpressed: onInitializePayment,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.credit_card_rounded,
                      color: Colors.white,
                    ),
                    Text(
                      "Pay With Card",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ))
            // const Text(
            //   "Full Name",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontFamily: AppFont.mulish,
            //     fontSize: 20,
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // TextFormField(
            //   decoration: const InputDecoration(
            //     hintText: "Enter Full Name",
            //     hintStyle: TextStyle(
            //       fontSize: 18,
            //       color: AppColor.primaryColor,
            //     ),
            //     disabledBorder: InputBorder.none,
            //     border: InputBorder.none,
            //     enabledBorder: InputBorder.none,
            //     focusedBorder: InputBorder.none,
            //   ),
            //   onTapOutside: (v) {
            //     FocusManager.instance.primaryFocus?.unfocus();
            //   },
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // const Text(
            //   "Amount",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontFamily: AppFont.mulish,
            //     fontSize: 20,
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // TextFormField(
            //   keyboardType: const TextInputType.numberWithOptions(
            //     decimal: false,
            //     signed: false,
            //   ),
            //   decoration: const InputDecoration(
            //     hintText: "Enter Amount",
            //     hintStyle: TextStyle(
            //       fontSize: 18,
            //       color: AppColor.primaryColor,
            //     ),
            //     disabledBorder: InputBorder.none,
            //     border: InputBorder.none,
            //     enabledBorder: InputBorder.none,
            //     focusedBorder: InputBorder.none,
            //   ),
            //   onTapOutside: (v) {
            //     FocusManager.instance.primaryFocus?.unfocus();
            //   },
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // const Text(
            //   "Select Proof Of Payment",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontFamily: AppFont.mulish,
            //     fontSize: 20,
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // TouchableOpacity(
            //   onTap: () async {
            //     try {
            //       final XFile? image = await picker.pickImage(
            //         source: ImageSource.camera,
            //         imageQuality: 100,
            //         maxHeight: 500,
            //         maxWidth: 500,
            //       );
            //       if (image != null) {
            //       } else {
            //         await alertHelper(
            //             context, 'error', 'please select and image');
            //       }
            //     } catch (exception) {
            //       print(exception);
            //     }
            //   },
            //   child: TextFormField(
            //     keyboardType: const TextInputType.numberWithOptions(
            //       decimal: false,
            //       signed: false,
            //     ),
            //     // readOnly: true,
            //     decoration: const InputDecoration(
            //       prefixIcon: Icon(
            //         Icons.image,
            //         color: AppColor.primaryColor,
            //       ),
            //       enabled: false,
            //       hintText: "Select Image",
            //       hintStyle: TextStyle(
            //         fontSize: 18,
            //         color: AppColor.primaryColor,
            //       ),
            //       disabledBorder: InputBorder.none,
            //       border: InputBorder.none,
            //       enabledBorder: InputBorder.none,
            //       focusedBorder: InputBorder.none,
            //     ),
            //     onTapOutside: (v) {
            //       FocusManager.instance.primaryFocus?.unfocus();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
