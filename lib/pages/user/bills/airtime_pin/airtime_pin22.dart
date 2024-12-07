import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/model/providers.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:minat_pay/widget/user/name_preview.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../bloc/repo/app/app_bloc.dart';
import '../../../../config/app.config.dart';
import '../../../../config/font.constant.dart';
import '../../../../cubic/app_config_cubit.dart';
import '../../../../helper/helper.dart';
import '../../../../model/airtime_pin_plan.dart';
import '../../../../model/airtime_providers.dart';
import '../../../../model/app.dart';
import '../../../../widget/Button.dart';
import '../airtime/airtime.dart';

final _formKey = GlobalKey<FormState>();

class AirtimePin extends HookWidget {
  const AirtimePin({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();

    final TextEditingController idController = useTextEditingController();

    final networkInputController = useTextEditingController();
    final planInputController = useTextEditingController();
    final quantityInputController = useTextEditingController();

    useEffect(() {
      amountController.text = '';
      idController.text = '';
      return null;
    }, []);
    final focusNode = useFocusNode();

    final ValueNotifier<List<AirtimePinPlan>> planProviders = useState([]);
    final ValueNotifier<List<AirtimePinPlan>> allGlobalPlanList = useState([]);
    final ValueNotifier<List<AirtimeProviders>> networkProviders = useState([]);
    final ValueNotifier<AirtimeProviders> selectedProvider =
        useState(AirtimeProviders());
    final ValueNotifier<String> userIdName = useState('');
    final ValueNotifier<AirtimePinPlan> pickedPlan = useState(AirtimePinPlan());
    // Future<void> onFocusChange() async {
    //   if (focusNode.hasFocus == false &&
    //       pickedPlan.value != null &&
    //       idController.value.text != '') {
    //     context.loaderOverlay.show();
    //     final res = await curl2GetRequest(
    //         path: verifyBetting,
    //         queryParams: {
    //           'customer_id': idController.text,
    //           'service_id': pickedPlan.value?.id,
    //         },
    //         options: Options(headers: {
    //           'Authorization': context.read<AppBloc>().state.user?.apiKey
    //         }));
    //     print(res?.data);
    //
    //     if (context.mounted) {
    //       context.loaderOverlay.hide();
    //       if (res?.statusCode != HttpStatus.ok) {
    //         userIdName.value = '';
    //         await alertHelper(context, 'error', res?.data['message']);
    //       } else {
    //         userIdName.value = res?.data['data']['customer_name'];
    //       }
    //     }
    //   }
    // }
    //
    // useEffect(() {
    //   focusNode.addListener(onFocusChange);
    //   return () => focusNode.removeListener(onFocusChange);
    // }, [focusNode]);
    // useEffect(() {
    //   if (idController.text.isNotEmpty) {
    //     onFocusChange();
    //   }
    //
    //   return null;
    // }, [selectedProvider.value]);

    // final user = context.read<AppBloc>().state.user;
    Future<List<AirtimePinPlan>> getPlanList(
      BuildContext context,
      ValueNotifier<bool> networkIsLoading,
    ) async {
      networkIsLoading.value = true;
      List<AirtimePinPlan> list = [];
      List<AirtimePinPlan> allList = [];
      if (allGlobalPlanList.value.isNotEmpty) {
        list = allGlobalPlanList.value.where(
          (element) {
            return element.network == selectedProvider.value.id;
          },
        ).toList();
        planProviders.value = list;
        networkIsLoading.value = false;
        return list;
      }
      final res = await curl2GetRequest(
        path: getAirtimePlan,
        data: {
          "val_id": selectedProvider.value.id,
        },
        options: Options(
          headers: {
            'Authorization': context.read<AppBloc>().state.user?.apiKey
          },
        ),
      );
      if (res?.statusCode == HttpStatus.ok) {
        allList = AirtimePinPlan.fromJsonList(res?.data['data']);
        allGlobalPlanList.value = allList;
        list = allList.where(
          (element) {
            return element.network == selectedProvider.value.id;
          },
        ).toList();
      }

      planProviders.value = list;
      networkIsLoading.value = false;
      return planProviders.value;
    }

    final planIsLoading = useState(false);
    final networkIsLoading = useState(false);
    useEffect(() {
      if (selectedProvider.value.id != null &&
          networkProviders.value.isNotEmpty) {
        selectedProvider.value = networkProviders.value.firstWhere(
          (element) {
            return element.id == selectedProvider.value.id;
          },
        );
        networkInputController.text = selectedProvider.value.name!;
        pickedPlan.value = AirtimePinPlan();
        planInputController.text = '';
        planProviders.value = allGlobalPlanList.value.where(
          (element) {
            return element.id == selectedProvider.value.id;
          },
        ).toList();
      }

      return null;
    }, [selectedProvider.value]);
    useEffect(() {
      if (pickedPlan.value.id != null && planProviders.value.isNotEmpty) {
        pickedPlan.value = planProviders.value.firstWhere(
          (element) {
            return element.id == pickedPlan.value.id;
          },
        );
        planInputController.text = pickedPlan.value.name!;
      }

      return null;
    }, [pickedPlan.value]);
    Future<void> handleCheckOut(
      BuildContext context, {
      required String amount,
      // required String phone,
      // required String networkId,
    }) async {
      context.loaderOverlay.show();
      final res = await curl2PostRequest(
        path: postBetting,
        data: {
          'amount': amount,
          'customer_id': idController.text,
          'service_id': pickedPlan.value?.id,
          'trx_id': DateTime.now().microsecondsSinceEpoch,
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
          amountController.text = '';
          idController.text = '';
          await putLastTransactionId(res?.data['data']['trx_id']);
          if (context.mounted) {
            HapticFeedback.heavyImpact();
            appModalWithoutRoot(context,
                title: 'Betting Fund Successful',
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
                    Image.network(
                      '${pickedPlan.value?.logo}',
                      height: 20,
                      width: 20,
                    ),
                    Text(
                      pickedPlan.value!.name!,
                      style: const TextStyle(
                        fontSize: 18,
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
                  "${currency(context)}${amountController.text}",
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
                  '${currency(context)}0',
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
                  "User Id",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  idController.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Button(
              onpressed: () {
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
          appBar: AppHeader(
            title: 'Airtime Pin',
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select Network",
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
                                final List<Providers> networkProvider =
                                    networkProviders.value.isNotEmpty
                                        ? networkProviders.value
                                        : await getAirtimeList(context,
                                            networkIsLoading, networkProviders);
                                if (context.mounted) {
                                  showProviderPicker(context, networkProvider,
                                      selectedProvider);
                                }
                              },
                              child: TextFormField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: false,
                                  signed: false,
                                ),
                                validator:
                                    ValidationBuilder().required().build(),
                                controller: networkInputController,
                                enabled: false,
                                onChanged: (value) {
                                  print(value);
                                },
                                style: const TextStyle(
                                    color: AppColor.primaryColor),
                                decoration: InputDecoration(
                                  hintText: "Select Network",
                                  hintStyle: const TextStyle(
                                    fontSize: 18,
                                    color: AppColor.primaryColor,
                                  ),
                                  suffixIcon: networkIsLoading.value
                                      ? const UnconstrainedBox(
                                          child: SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.arrow_forward_ios_rounded),
                                  // border: InputBorder.none,
                                  // enabledBorder: InputBorder.none,
                                  // errorBorder: InputBorder.none,
                                  // focusedErrorBorder: InputBorder.none,
                                  // focusedBorder: InputBorder.none,
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
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Select Plan",
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
                                if (selectedProvider.value.id == null) {
                                  await alertHelper(context, 'error',
                                      'please select network');
                                  return;
                                }
                                final plans = planProviders.value.isNotEmpty
                                    ? planProviders.value
                                    : await getPlanList(context, planIsLoading);
                                if (context.mounted) {
                                  showProviderPicker(
                                      context, plans, pickedPlan);
                                }
                              },
                              child: TextFormField(
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: false,
                                  signed: false,
                                ),
                                validator:
                                    ValidationBuilder().required().build(),
                                controller: planInputController,
                                enabled: false,
                                style: const TextStyle(
                                    color: AppColor.primaryColor),
                                decoration: InputDecoration(
                                  hintText: "Select Plan",
                                  hintStyle: const TextStyle(
                                    fontSize: 18,
                                    color: AppColor.primaryColor,
                                  ),
                                  suffixIcon: planIsLoading.value
                                      ? const UnconstrainedBox(
                                          child: SizedBox(
                                            width: 15,
                                            height: 15,
                                            child: CircularProgressIndicator(),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.arrow_forward_ios_rounded),
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
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          controller: quantityInputController,
                          focusNode: focusNode,
                          validator: ValidationBuilder().required().build(),
                          enabled: networkInputController.text.isNotEmpty,
                          decoration: InputDecoration(
                            hintText: networkInputController.text.isEmpty
                                ? ''
                                : "Enter ${networkInputController.text} Quantity",
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
                        Builder(
                          builder: (context) {
                            if (userIdName.value != '') {
                              return NamePreview(text: userIdName.value);
                            }
                            return const SizedBox();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (userIdName.value == '') {
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
