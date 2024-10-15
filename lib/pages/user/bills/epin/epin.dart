import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:minat_pay/widget/user/name_preview.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../bloc/repo/app/app_bloc.dart';
import '../../../../config/app.config.dart';
import '../../../../config/font.constant.dart';
import '../../../../cubic/app_config_cubit.dart';
import '../../../../helper/helper.dart';
import '../../../../model/app.dart';
import '../../../../model/epin_providers.dart';
import '../../../../widget/Button.dart';

final TextEditingController amountController = TextEditingController();

final TextEditingController quantityController = TextEditingController();

final epinProviderInputController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class Epin extends HookWidget {
  const Epin({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final ValueNotifier<int?> amountSelected = useState(null);
    UnderlineInputBorder borderStyle = const UnderlineInputBorder(
      borderSide: BorderSide(
          style: BorderStyle.solid, color: AppColor.primaryColor, width: 2),
    );
    final ValueNotifier<List<EpinProviders>> examProviders = useState([]);
    final user = context.read<AppBloc>().state.user;
    final ValueNotifier<EpinProviders> selectedProvider =
        useState(EpinProviders());
    final epinIsLoading = useState(false);
    final ValueNotifier<bool> valid = useState(false);
    final ValueNotifier<String> amountInTotal = useState('');
    final ValueNotifier<EpinProviders> pickedExamType =
        useState(EpinProviders());
    Future<void> handleQuantityChange() async {
      if (pickedExamType.value.amount != null &&
          quantityController.value.text != '') {
        final amount = user!.userType!
            ? pickedExamType.value.amountAgent
            : pickedExamType.value.amount;

        amountInTotal.value =
            "Total Amount Is ${(double.parse(amount!) * double.parse(quantityController.text)).toString()} NGN";
      } else {
        amountInTotal.value = '';
        await alertHelper(context, 'error', 'something went wrong');
      }
    }

    useEffect(() {
      focusNode.addListener(handleQuantityChange);
      return () => focusNode.removeListener(handleQuantityChange);
    }, [focusNode]);

    useEffect(() {
      if (quantityController.text.isNotEmpty) {
        handleQuantityChange();
      }

      return null;
    }, [selectedProvider.value]);

    Future<List<EpinProviders>> getEpinList(
        BuildContext context, ValueNotifier<bool> networkIsLoading) async {
      networkIsLoading.value = true;
      List<EpinProviders> list = [];
      final res = await curl2GetRequest(
        path: getEpin,
        options: Options(
          headers: {
            'Authorization': context.read<AppBloc>().state.user?.apiKey
          },
        ),
      );
      print(res);
      if (res?.statusCode == HttpStatus.ok) {
        list = List.generate(
          res?.data['data'].length,
          (index) {
            return EpinProviders(
              id: res?.data['data'][index]['id'],
              name: res?.data['data'][index]['name'],
              amount: res?.data['data'][index]['amount'],
              amountAgent: res?.data['data'][index]['amountAgent'],
              type: res?.data['data'][index]['type'],
              amountApi: res?.data['data'][index]['amountApi'],
              instruction: res?.data['data'][index]['instruction'],
              number: res?.data['data'][index]['number'],
              status: res?.data['data'][index]['status'],
              image: res?.data['data'][index]['logo'],
            );
          },
        );
      }
      Future.delayed(const Duration(seconds: 10));

      examProviders.value = list;
      networkIsLoading.value = false;
      return list;
    }

    useEffect(() {
      if (selectedProvider.value.id != null && examProviders.value.isNotEmpty) {
        pickedExamType.value = examProviders.value.firstWhere(
          (element) {
            return element.id == selectedProvider.value.id;
          },
        );
        epinProviderInputController.text = pickedExamType.value.name!;
      }

      return null;
    }, [selectedProvider.value]);

    Future<void> handleCheckOut(
      BuildContext context, {
      required String amount,
      // required String phone,
      // required String networkId,
    }) async {
      context.loaderOverlay.show();
      final res = await curl2PostRequest(
        path: buyEpin,
        data: {
          'epin': selectedProvider.value.id,
          'quantity': quantityController.text,
        },
        options: Options(headers: {
          'Authorization': context.read<AppBloc>().state.user?.apiKey
        }),
      );
      if (context.mounted && res == null) {
        Navigator.of(context, rootNavigator: true).pop();
        alertHelper(context, 'error', 'No Internet Connection');
      }

      if (context.mounted) {
        if (res?.statusCode == HttpStatus.ok) {
          await putLastTransactionId(res?.data['data']['trx_id']);
          if (context.mounted) {
            HapticFeedback.heavyImpact();
            appModalWithoutRoot(context,
                title: 'Exam pin Purchase Successful',
                child:
                    successModalWidget(context, message: res?.data['message']));
          }

          // alertHelper(context, 'success', res?.data['message']);
        } else {
          // Navigator.of(context, rootNavigator: true).pop();
          alertHelper(context, 'error', res?.data['message'], duration: 6);
        }
      }

      if (context.mounted) {
        context.loaderOverlay.hide();
      }
    }

    Widget checkout() {
      final double space = 15;
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Product Name",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: pickedExamType.value.image!,
                          height: 120,
                          fit: BoxFit.fill,
                          width: 120,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      pickedExamType.value.name!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: space,
            ),
            Row(
              children: [
                const Text(
                  "Amount",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  "${currency(context)}${double.parse(quantityController.text) * double.parse(user!.userType! ? pickedExamType.value.amountAgent! : pickedExamType.value.amount!)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: AppFont.mulish,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: space,
            ),
            Row(
              children: [
                const Text(
                  "Cashback",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  '${currency(context)} ${user.userType! ? double.parse(pickedExamType.value.amount!) - double.parse(pickedExamType.value.amountAgent!) : 0}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: AppFont.mulish,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: space,
            ),
            Button(
              onpressed: () {
                valid.value = false;
                Navigator.of(context, rootNavigator: true).pop();
                showConfirmPinRequest(context);
              },
              child: const Text(
                "Pay",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
          ],
        ),
      );
    }

    return BlocConsumer<AppConfigCubit, App>(
      listener: (context, state) {
        if (state.pinState == true) {
          handleCheckOut(
            context,
            amount: amountController.text,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const AppHeader(
            title: 'Exam Pin',
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Exam Type",
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
                        TouchableOpacity(
                          activeOpacity: 0.4,
                          onTap: () async {
                            final examProvider = examProviders.value.isNotEmpty
                                ? examProviders.value
                                : await getEpinList(context, epinIsLoading);
                            if (context.mounted) {
                              showProviderPicker(
                                  context, examProvider, selectedProvider);
                            }
                          },
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: false,
                            ),
                            validator: ValidationBuilder().required().build(),
                            controller: epinProviderInputController,
                            enabled: false,
                            style:
                                const TextStyle(color: AppColor.primaryColor),
                            decoration: InputDecoration(
                              hintText: "Select Provider",
                              hintStyle: const TextStyle(
                                fontSize: 18,
                                color: AppColor.primaryColor,
                              ),
                              suffixIcon: epinIsLoading.value
                                  ? const UnconstrainedBox(
                                      child: SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : const Icon(Icons.arrow_forward_ios_rounded),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabled: false,
                            ),
                            onTapOutside: (v) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Quantity",
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
                        TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          controller: quantityController,
                          focusNode: focusNode,
                          onChanged: (value) {
                            handleQuantityChange();
                          },
                          validator: ValidationBuilder().required().build(),
                          enabled: epinProviderInputController.text.isNotEmpty,
                          decoration: InputDecoration(
                            hintText: epinProviderInputController.text.isEmpty
                                ? ''
                                : "Enter Quantity",
                            hintStyle: const TextStyle(
                              fontSize: 18,
                              color: AppColor.primaryColor,
                            ),
                            disabledBorder: InputBorder.none,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          onTapOutside: (v) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (amountInTotal.value.isNotEmpty &&
                            quantityController.text.isNotEmpty)
                          NamePreview(text: amountInTotal.value),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (amountInTotal.value == '') {
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              appModalWithoutRoot(context,
                                  title: "CheckOut Preview", child: checkout());
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
      },
    );
  }
}
