import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/model/app.dart';
import 'package:minat_pay/widget/user/name_preview.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../bloc/repo/app/app_bloc.dart';
import '../../../../config/app.config.dart';
import '../../../../config/font.constant.dart';
import '../../../../cubic/app_config_cubit.dart';
import '../../../../helper/helper.dart';
import '../../../../model/cable_providers.dart';
import '../../../../widget/Button.dart';

final _formKey = GlobalKey<FormState>();

UnderlineInputBorder borderStyle = const UnderlineInputBorder(
  borderSide: BorderSide(
      style: BorderStyle.solid, color: AppColor.primaryColor, width: 2),
);
final cableProviderInputController = TextEditingController();
final cablePlanInputController = TextEditingController();

class Cable extends HookWidget {
  const Cable({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();

    final TextEditingController idController = useTextEditingController();

    useEffect(() {
      amountController.text = '';
      idController.text = '';
      cableProviderInputController.text = '';
      cablePlanInputController.text = '';
      return null;
    }, []);
    final focusNode = useFocusNode();
    final ValueNotifier<int?> amountSelected = useState(null);

    final ValueNotifier<List<CableProviders>> networkProviders = useState([]);

    final ValueNotifier<bool> valid = useState(false);
    final ValueNotifier<bool> isPlanLoading = useState(false);
    final ValueNotifier<List<Map<String, dynamic>>> plans = useState([]);
    final ValueNotifier<String> userIdName = useState('');
    final ValueNotifier<Map<String, dynamic>?> selectedPlan = useState(null);
    final ValueNotifier<CableProviders> pickedNetwork =
        useState(CableProviders());
    Future<void> onFocusChange() async {
      if (focusNode.hasFocus == false && idController.value.text != '') {
        context.loaderOverlay.show();

        final res = await curl2GetRequest(
            path: verifyCable,
            queryParams: {
              'customer_id': idController.text,
              'service_id': pickedNetwork.value?.id,
            },
            options: Options(headers: {
              'Authorization': context.read<AppBloc>().state.user?.apiKey
            }));

        if (context.mounted) {
          if (res == null) {
            await alertHelper(context, 'error', "Connection Timeout");
            return;
          }
          context.loaderOverlay.hide();
          if (res.statusCode != HttpStatus.ok) {
            userIdName.value = '';
            await alertHelper(context, 'error', res.data['message']);
          } else {
            userIdName.value = res.data['data']['customer_name'];
          }
        }
      }
    }

    useEffect(() {
      if (selectedPlan.value != null) {
        cablePlanInputController.text = selectedPlan.value?['plan'];
      }
      return null;
    }, [selectedPlan.value]);
    useEffect(() {
      focusNode.addListener(onFocusChange);
      return () => focusNode.removeListener(onFocusChange);
    }, [focusNode]);
    useEffect(() {
      if (idController.text.isNotEmpty) {
        onFocusChange();
      }
      return null;
    }, [pickedNetwork.value]);
    final user = context.read<AppBloc>().state.user;

    Future<List<CableProviders>> getBettingList(
        BuildContext context, ValueNotifier<bool> networkIsLoading) async {
      networkIsLoading.value = true;
      List<CableProviders> list = [];
      final res = await curl2GetRequest(
          path: getCable,
          options: Options(headers: {
            'Authorization': context.read<AppBloc>().state.user?.apiKey
          }));
      if (res?.statusCode == HttpStatus.ok) {
        list = List.generate(
          res?.data['data'].length,
          (index) {
            return CableProviders(
              id: res?.data['data'][index]['id'],
              name: res?.data['data'][index]['name'],
              product_id: res?.data['data'][index]['service_id'],
              service: res?.data['data'][index]['service'],
              logo: res?.data['data'][index]['image'],
              image: res?.data['data'][index]['image'],
            );
          },
        );
      }
      Future.delayed(const Duration(seconds: 10));

      networkProviders.value = list;
      networkIsLoading.value = false;
      return list;
    }

    final bettingIsLoading = useState(false);
    useEffect(() {
      if (pickedNetwork.value.id != null && networkProviders.value.isNotEmpty) {
        pickedNetwork.value = networkProviders.value.firstWhere(
          (element) {
            return element.id == pickedNetwork.value.id!;
          },
        );
        cableProviderInputController.text = pickedNetwork.value.name!;
        idController.text = '';
        userIdName.value = '';
      }

      return null;
    }, [pickedNetwork.value]);
    getCablePlans(BuildContext context) async {
      isPlanLoading.value = true;

      final res = await curl2GetRequest(
        path: getCableVariation,
        data: {
          'service_id': pickedNetwork.value.id,
        },
        options: Options(
          headers: {
            'Authorization': context.read<AppBloc>().state.user?.apiKey,
          },
        ),
      );

      isPlanLoading.value = false;
      if (res?.statusCode == HttpStatus.ok) {
        plans.value = [...res?.data['data']];
      } else {
        plans.value = [];
      }
    }

    Future<void> handleCheckOut(
      BuildContext context, {
      required String amount,
      // required String phone,
      // required String networkId,
    }) async {
      context.loaderOverlay.show();
      final res = await curl2PostRequest(
        path: postCable,
        data: {
          'smartcard_number': idController.text,
          'variation_id': selectedPlan.value?['val_id'],
          'service_id': pickedNetwork.value.id,
          'trx_id': DateTime.now().microsecondsSinceEpoch,
        },
        options: Options(headers: {
          'Authorization': context.read<AppBloc>().state.user?.apiKey
        }),
      );

      if (context.mounted && res == null) {
        Navigator.of(context, rootNavigator: true).pop();
        await alertHelper(context, 'error', 'No Internet Connection');
      }

      if (context.mounted) {
        if (res?.statusCode == HttpStatus.ok) {
          amountController.text = '';
          idController.text = '';
          cableProviderInputController.text = '';
          cablePlanInputController.text = '';
          await putLastTransactionId(res?.data['data']['trx_id']);
          if (context.mounted) {
            HapticFeedback.heavyImpact();
            appModalWithoutRoot(context,
                title: 'Cable Purchase Successful',
                child:
                    successModalWidget(context, message: res?.data['message']));
          }

          // alertHelper(context, 'success', res?.data['message']);
        } else {
          context.loaderOverlay.hide();
          // Navigator.of(context, rootNavigator: true).pop();
          await alertHelper(
            context,
            'error',
            res?.data['message'],
            duration: 6,
          );
        }
      }

      if (context.mounted) {
        if (context.loaderOverlay.visible) context.loaderOverlay.hide();
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
                      '${pickedNetwork.value?.logo}',
                      height: 20,
                      width: 20,
                    ),
                    Text(
                      pickedNetwork.value!.name!,
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
                  "${currency(context)}${selectedPlan.value?['amount']}",
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
                  '${currency(context)}${int.parse(selectedPlan.value?['amount']) - int.parse(selectedPlan.value?['amount_agent'])}',
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
                  "Product Id",
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
                valid.value = false;
                Navigator.of(context, rootNavigator: true).pop();
                showConfirmPinRequest(context);

                // valid.addListener(
                //   () {
                //     if (valid.value) {
                //       handleCheckOut(
                //         context,
                //         amount: amountController.text,
                //       );
                //     }
                //   },
                // );
                // valid.removeListener(
                //   () {
                //     valid.value;
                //   },
                // );
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

    useEffect(() {
      if (pickedNetwork.value.id != null) {
        getCablePlans(context);
      }
      return null;
    }, [pickedNetwork.value]);

    return BlocConsumer<AppConfigCubit, App>(
      listener: (context, state) {
        handleCheckOut(
          context,
          amount: amountController.text,
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Cable",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppFont.mulish,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pushNamed('transactions');
                },
                child: const Text('History',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: AppFont.mulish,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
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
                          "Select Provider",
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
                            final networkProvider =
                                networkProviders.value.isNotEmpty
                                    ? networkProviders.value
                                    : await getBettingList(
                                        context, bettingIsLoading);
                            if (context.mounted) {
                              showProviderPicker(
                                  context, networkProvider, pickedNetwork);
                            }
                          },
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: false,
                            ),
                            validator: ValidationBuilder().required().build(),
                            controller: cableProviderInputController,
                            // enableInteractiveSelection: false,
                            enabled: false,
                            onChanged: (value) {},
                            style:
                                const TextStyle(color: AppColor.primaryColor),
                            decoration: InputDecoration(
                              hintText: "Select Provider",
                              hintStyle: const TextStyle(
                                fontSize: 18,
                                color: AppColor.primaryColor,
                              ),
                              suffixIcon: bettingIsLoading.value
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

                              // enabled: false,
                            ),
                            onTapOutside: (v) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (pickedNetwork.value.id != null)
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
                        if (pickedNetwork.value.id != null)
                          if (!isPlanLoading.value && plans.value.isNotEmpty)
                            InkWell(
                              onTap: () {
                                showCablePlans(context, plans, selectedPlan);
                                print(plans.value);
                              },
                              child: TextFormField(
                                validator:
                                    ValidationBuilder().required().build(),
                                controller: cablePlanInputController,
                                enabled: false,
                                onChanged: (value) {},
                                style: const TextStyle(
                                    color: AppColor.primaryColor),
                                decoration: InputDecoration(
                                  hintText: "Select Plan",
                                  hintStyle: const TextStyle(
                                    fontSize: 18,
                                    color: AppColor.primaryColor,
                                  ),
                                  suffixIcon: bettingIsLoading.value
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

                                  // enabled: false,
                                ),
                                onTapOutside: (v) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                              ),
                            )
                          else
                            const CircularProgressIndicator(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Product Id",
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: idController,
                          focusNode: focusNode,
                          validator: ValidationBuilder().required().build(),
                          enabled: cableProviderInputController.text.isNotEmpty,
                          decoration: InputDecoration(
                            hintText: cableProviderInputController.text.isEmpty
                                ? ''
                                : "Enter ${cableProviderInputController.text} Number",
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
                        if (userIdName.value != '')
                          ElevatedButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (userIdName.value == '') {
                                return;
                              }
                              if (_formKey.currentState!.validate()) {
                                appModalWithoutRoot(context,
                                    title: "CheckOut Preview",
                                    child: checkout());
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

  void showCablePlans(
      BuildContext context,
      ValueNotifier<List<Map<String, dynamic>>> plans,
      ValueNotifier<Map<String, dynamic>?> selectedPlan) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        useRootNavigator: true,
        showDragHandle: true,
        builder: (builder) {
          return Container(
            constraints: const BoxConstraints(
              minWidth: double.maxFinite,
              minHeight: 200,
              maxHeight: 430,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      plans.value.length,
                      (index) {
                        return TouchableOpacity(
                          onTap: () {
                            selectedPlan.value = plans.value[index];

                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        '${plans.value[index]['plan']} ₦${plans.value[index]['amount']}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                        // maxLines: 2,
                                        // overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                                // Spacer(),
                                plans.value[index]['id'] ==
                                            selectedPlan.value?['id'] &&
                                        selectedPlan.value != null
                                    ? const Icon(
                                        Icons.check_circle,
                                        size: 25,
                                      )
                                    : const Icon(
                                        Icons.circle_outlined,
                                        size: 15,
                                      )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
