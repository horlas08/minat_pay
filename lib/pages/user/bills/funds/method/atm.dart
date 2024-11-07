import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:minat_pay/widget/Button.dart';

import '../../../../../config/color.constant.dart';
import '../../../../../config/font.constant.dart';
import '../../../../../main.dart';

final ImagePicker picker = ImagePicker();
final _amountController = TextEditingController(text: '');
final _formKey = GlobalKey<FormState>();

class Atm extends HookWidget {
  const Atm({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _amountController.text = '';

      return null;
    }, []);

    final user = context.read<AppBloc>().state.user;

    Future<void> onInitializePaystack() async {
      try {
        context.loaderOverlay.show();

        final request = PaystackTransactionRequest(
          reference: 'PST' + DateTime.now().millisecondsSinceEpoch.toString(),
          secretKey: appServer.serverResponse.appconfiguration!.psecret!,
          email: user!.email!,
          amount: double.parse(_amountController.text) * 100,
          currency: PaystackCurrency.ngn,
          channel: [
            PaystackPaymentChannel.mobileMoney,
            PaystackPaymentChannel.card,
            PaystackPaymentChannel.ussd,
            PaystackPaymentChannel.bankTransfer,
            PaystackPaymentChannel.bank,
            PaystackPaymentChannel.qr,
            PaystackPaymentChannel.eft,
          ],
        );
        final initializedTransaction =
            await PaymentService.initializeTransaction(request);
        if (context.mounted) {
          context.loaderOverlay.hide();
        }

        if (!initializedTransaction.status) {
          if (context.mounted) {
            context.loaderOverlay.hide();
            await alertHelper(context, 'error', initializedTransaction.message);
          }

          return;
        }
        if (context.mounted) {
          final response = await PaymentService.showPaymentModal(
            context,
            transaction: initializedTransaction,
            callbackUrl: appServer.serverResponse.appconfiguration!.pcallback!,
          ).then((_) async {
            return await PaymentService.verifyTransaction(
              paystackSecretKey:
                  appServer.serverResponse.appconfiguration!.psecret!,
              initializedTransaction.data?.reference ?? request.reference,
            );
          });

          if (response.data.status == PaystackTransactionStatus.failed ||
              response.data.status == PaystackTransactionStatus.abandoned ||
              response.data.status == PaystackTransactionStatus.reversed) {
            if (context.mounted)
              return await alertHelper(
                  context, "error", "Payment Verification fail");
          }
          if (response.data.status == PaystackTransactionStatus.success) {
            if (context.mounted)
              return await alertHelper(
                  context, "success", "Payment Verification successful");
          }
          print(response.data);
        }
      } catch (error) {
        if (context.mounted) {
          await alertHelper(context, 'error', error.toString());
        }
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
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
                  hintText: "Enter Amount",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: AppColor.primaryColor,
                  ),
                  disabledBorder: InputBorder.none,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                validator: ValidationBuilder().required().build(),
                onTapOutside: (v) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Button(
                  onpressed: () {
                    if (_formKey.currentState!.validate()) {
                      onInitializePaystack();
                    }
                  },
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
            ],
          ),
        ),
      ),
    );
  }
}
