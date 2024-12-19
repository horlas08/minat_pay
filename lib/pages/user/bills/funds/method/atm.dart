import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_paystack_max/flutter_paystack_max.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:minat_pay/widget/Button.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart';
import 'package:widget_visibility_detector/widget_visibility_detector.dart';

import '../../../../../config/color.constant.dart';
import '../../../../../config/font.constant.dart';
import '../../../../../main.dart';
import '../../../../../service/http.dart';

final ImagePicker picker = ImagePicker();
final _amountController = TextEditingController(text: '');
final _formKey = GlobalKey<FormState>();
RadioGroupController myController = RadioGroupController();

enum PaymentMethod {
  opay(value: 'bank'),
  bank(value: 'bank_transfer'),
  ussd(value: 'ussd'),
  card(value: 'card');

  final String value;
  const PaymentMethod({required this.value});
  factory PaymentMethod.fromMap(String name) {
    return PaymentMethod.values.asNameMap()[name] ?? opay;
  }

  String toMap() => value;
}

class Atm extends HookWidget {
  const Atm({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      _amountController.text = '';
      return null;
    }, []);

    final user = context.read<AppBloc>().state.user;
    final ValueNotifier<String?> referrence = useState(null);
    Future<void> onInitializePaystack() async {
      try {
        context.loaderOverlay.show();
        final response = await dio.post(
          'https://api.paystack.co/transaction/initialize',
          data: {
            'email': user!.email!,
            'amount': double.parse(_amountController.text) * 100,
            'channels': [getPaymentMethodFromString(myController.value).value],
            'currency': 'NGN',
            'metadata': {
              'custom_filters': {
                'supported_bank_providers': ['999992'],
              }
            }
          },
          options: Options(
            headers: {
              'authorization':
                  "Bearer ${appServer.serverResponse.appconfiguration!.psecret!}"
            },
          ),
        );
        if (context.mounted) {
          context.loaderOverlay.hide();

          if (response.statusCode == HttpStatus.ok) {
            referrence.value = response.data['data']['reference'] as String;
            final Map<String, String> pathParam = {
              'url': response.data['data']['authorization_url'] as String,
              'reference': response.data['data']['reference'] as String,
            };
            print(referrence.value);
            context.pushNamed('paystack', extra: pathParam);
          } else {
            referrence.value = null;
            return await alertHelper(context, 'error',
                "payment initialization failed try again later");
          }
        }
        return;
        final request = PaystackTransactionRequest(
          reference: 'PST' + DateTime.now().millisecondsSinceEpoch.toString(),
          secretKey: appServer.serverResponse.appconfiguration!.psecret!,
          email: user!.email!,
          amount: double.parse(_amountController.text) * 100,
          currency: PaystackCurrency.ngn,
          metadata: {},
          channel: [
            PaystackPaymentChannel.mobileMoney,
            PaystackPaymentChannel.card,
            PaystackPaymentChannel.ussd,
            PaystackPaymentChannel.bankTransfer,
            PaystackPaymentChannel.bank,
            PaystackPaymentChannel.qr,
            PaystackPaymentChannel.eft,
            // PaystackPaymentChannel.opay,
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
        print(error);
        if (context.mounted) {
          context.loaderOverlay.hide();
          await alertHelper(context, 'error', error.toString());
        }
      }
    }

    return WidgetVisibilityDetector(
      onAppear: () async {
        if (!referrence.value.isEmptyOrNull) {
          final res = await PaymentService.verifyTransaction(
            paystackSecretKey:
                appServer.serverResponse.appconfiguration!.psecret!,
            referrence.value!,
          );

          if (res.data.status == PaystackTransactionStatus.success) {
            if (context.mounted) {
              return await alertHelper(
                  context, "success", "Payment Verification successful");
            }
          } else {
            if (context.mounted) {
              return await alertHelper(
                  context, "error", "Payment Verification fail");
            }
          }
          referrence.value = null;
        }
      },
      onDisappear: () {},
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioGroup(
                  controller: myController,
                  values: const [
                    "Opay",
                    "Bank Transfer",
                    "Card",
                    "Ussd",
                  ],
                  indexOfDefault: 0,
                  orientation: RadioGroupOrientation.vertical,
                  decoration: const RadioGroupDecoration(
                    spacing: 15.0,
                    labelStyle: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    activeColor: AppColor.primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Amount",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.mulish,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 25,
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
                  validator:
                      ValidationBuilder().required().minNumber(300).build(),
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
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.credit_card_rounded,
                          color: Colors.white,
                        ),
                        Text(
                          "Fund Account",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  PaymentMethod getPaymentMethodFromString(String value) {
    if (value == 'Opay') {
      return PaymentMethod.opay;
    } else if (value == 'Ussd') {
      return PaymentMethod.ussd;
    } else if (value == 'Bank Transfer') {
      return PaymentMethod.bank;
    } else if (value == 'Card') {
      return PaymentMethod.card;
    }
    return PaymentMethod.opay;
  }
}
