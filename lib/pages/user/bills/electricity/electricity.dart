import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/model/app.dart';
import 'package:minat_pay/model/electricity_providers.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../bloc/repo/app/app_bloc.dart';
import '../../../../config/app.config.dart';
import '../../../../config/font.constant.dart';
import '../../../../cubic/app_config_cubit.dart';
import '../../../../data/mock/dummy_data.dart';
import '../../../../helper/helper.dart';
import '../../../../widget/Button.dart';
import '../../../../widget/user/name_preview.dart';

final TextEditingController amountController = TextEditingController();
final TextEditingController meterController = TextEditingController();

final providerInputController = TextEditingController();
final _formKey = GlobalKey<FormState>();

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
      'trx_id': DateTime.now().microsecondsSinceEpoch,
    },
    options: Options(
        headers: {'Authorization': context.read<AppBloc>().state.user?.apiKey}),
  );

  if (context.mounted && res == null) {
    Navigator.of(context, rootNavigator: true).pop();
    alertHelper(context, 'error', 'No Internet Connection');
  }

  if (context.mounted) {
    if (res?.statusCode == HttpStatus.ok) {
      // Navigator.of(context, rootNavigator: true).pop();
      appModalWithoutRoot(context,
          title: ' Purchase Successful',
          child: successModalWidget(context, message: res?.data['message']));
    } else {
      // Navigator.of(context, rootNavigator: true).pop();
      alertHelper(context, 'error', res?.data['message'], duration: 6);
    }
  }

  if (context.mounted) {
    context.loaderOverlay.hide();
  }
}

Future validateDisco(BuildContext context,
    {required ValueNotifier<String> electricityType,
    required String? selectedProvider}) async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  print(electricityType.value);
  final res = await curl2GetRequest(
    path: verifyMeter,
    queryParams: {
      'meter_number': meterController.text,
      'disco': selectedProvider,
      'meter_type': electricityType.value,
    },
    options: Options(
      headers: {'Authorization': context.read<AppBloc>().state.user?.apiKey},
    ),
  );

  return res;
}

class Electricity extends HookWidget {
  const Electricity({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List<ElectricityProviders>> networkProviders =
        useState([]);
    final ValueNotifier<int?> amountSelected = useState(null);
    final ValueNotifier<ElectricityProviders> selectedProvider =
        useState(ElectricityProviders());
    final ValueNotifier<String> electricityType = useState('prepaid');
    final ValueNotifier<bool> valid = useState(false);
    final ValueNotifier<ElectricityProviders> pickedNetwork =
        useState(ElectricityProviders());
    final user = context.read<AppBloc>().state.user;
    final networkIsLoading = useState(false);
    final ValueNotifier<String?> userIdName = useState(null);
    final focusNode = useFocusNode();
    Future<List<ElectricityProviders>> getNetworkList(
        BuildContext context, ValueNotifier<bool> networkIsLoading) async {
      networkIsLoading.value = true;
      List<ElectricityProviders> list = [];
      final res = await curl2GetRequest(
          path: getElectricityDisco,
          options: Options(headers: {
            'Authorization': context.read<AppBloc>().state.user?.apiKey
          }));
      if (res?.statusCode == HttpStatus.ok) {
        list = List.generate(
          res?.data['data'].length,
          (index) {
            return ElectricityProviders(
              id: res?.data['data'][index]['id'],
              name: res?.data['data'][index]['name'],
              serviceId: res?.data['data'][index]['service_id'],
              service: res?.data['data'][index]['service'],
              logo: res?.data['data'][index]['image'],
              image: res?.data['data'][index]['image'],
            );
          },
        );
      }
      Future.delayed(const Duration(seconds: 10));
      print(res);
      networkProviders.value = list;
      networkIsLoading.value = false;
      return list;
    }

    Future<void> onFocusChange() async {
      if (focusNode.hasFocus == false &&
          pickedNetwork.value.id != null &&
          meterController.value.text != '') {
        context.loaderOverlay.show();
        final res = await curl2GetRequest(
            path: verifyMeter,
            queryParams: {
              'meter_number': meterController.text,
              'disco': pickedNetwork.value.id,
              'meter_type': electricityType.value,
            },
            options: Options(headers: {
              'Authorization': context.read<AppBloc>().state.user?.apiKey
            }));
        print(res?.statusCode);
        if (context.mounted) {
          context.loaderOverlay.hide();
          if (res?.statusCode != HttpStatus.ok) {
            userIdName.value = '';
            await alertHelper(context, 'error', res?.data['message']);
          } else {
            userIdName.value = res?.data['data']['customer_name'];
          }
        }
      }
    }

    useEffect(() {
      focusNode.addListener(onFocusChange);
      return () => focusNode.removeListener(onFocusChange);
    }, [focusNode]);

    useEffect(() {
      if (meterController.text.isNotEmpty) {
        onFocusChange();
      }

      return null;
    }, [selectedProvider.value, electricityType.value]);

    UnderlineInputBorder borderStyle = const UnderlineInputBorder(
      borderSide: BorderSide(
          style: BorderStyle.solid, color: AppColor.primaryColor, width: 2),
    );

    useEffect(() {
      if (selectedProvider.value.id != null &&
          networkProviders.value.isNotEmpty) {
        print(networkProviders.value);
        pickedNetwork.value = networkProviders.value.firstWhere(
          (element) {
            return element.id == selectedProvider.value.id;
          },
        );
        providerInputController.text = selectedProvider.value.name!;
      }

      return null;
    }, [selectedProvider.value]);

    useEffect(() {
      validateDisco(
        context,
        electricityType: electricityType,
        selectedProvider: selectedProvider.value.id,
      );
      return null;
    }, [electricityType.value]);

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
                      pickedNetwork.value!.logo!,
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        pickedNetwork.value!.name!,
                        softWrap: true,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
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
                user?.userType == true
                    ? Text(
                        '${currency(context)}${amountController.value}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: AppFont.mulish,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        '${currency(context)}0',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: AppFont.mulish,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                Tooltip(
                  height: 20,
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  waitDuration: const Duration(seconds: 2),
                  preferBelow: false,
                  decoration: const BoxDecoration(
                    color: AppColor.primaryColor,
                  ),
                  richMessage: user!.userType == true
                      ? const TextSpan(
                          text:
                              'You are getting cashback because You have Upgrade Your account from user to agent')
                      : const TextSpan(
                          text:
                              'Upgrade Your account from user to agent to enjoy unlimited cashback'),
                  child: const Icon(Icons.info_outline_rounded),
                )
              ],
            ),
            SizedBox(
              height: space,
            ),
            Row(
              children: [
                const Text(
                  "Payable",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                user.userType == true
                    ? Text(
                        '${currency(context)}${amountController.text}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: AppFont.mulish,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        '${currency(context)}${amountController.text}',
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
                  "Meter Number",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  '${meterController.text}',
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
                if (Navigator.canPop(context)) {
                  Navigator.of(context, rootNavigator: true).pop(context);
                }
                showConfirmPinRequest(context);

                // valid.addListener(
                //   () {
                //     if (valid.value == true) {
                //       handleCheckOut(
                //         context,
                //         amount: amountController.text,
                //         // phone: '0${phoneController.value.nsn}',
                //         // networkId: selectedNetwork.value.toString(),
                //       );
                //     }
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
          appBar: AppBar(
            title: const Text(
              "Electricity",
              style: TextStyle(
                fontSize: 20,
                fontFamily: AppFont.mulish,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'History',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: AppFont.mulish,
                      fontWeight: FontWeight.bold),
                ),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    : await getNetworkList(
                                        context, networkIsLoading);
                            if (context.mounted) {
                              showProviderPicker(
                                  context, networkProvider, selectedProvider);
                            }
                          },
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: false,
                            ),
                            validator: ValidationBuilder().required().build(),
                            controller: providerInputController,
                            enabled: false,
                            style:
                                const TextStyle(color: AppColor.primaryColor),
                            decoration: InputDecoration(
                              hintText: "Select Provider",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                TouchableOpacity(
                                  onTap: () {
                                    electricityType.value = 'prepaid';
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 150,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: electricityType.value == 'prepaid'
                                          ? Border.all(
                                              color: AppColor.primaryColor,
                                              width: 2,
                                            )
                                          : const Border.fromBorderSide(
                                              BorderSide.none),
                                    ),
                                    child: const Text(
                                      "Prepaid",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                if (electricityType.value == 'prepaid')
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.elliptical(30, 30),
                                        ),
                                        color: AppColor.primaryColor,
                                      ),
                                      padding: const EdgeInsets.only(
                                          top: 4, left: 4),
                                      child: const Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Stack(
                              children: [
                                TouchableOpacity(
                                  child: Container(
                                    height: 60,
                                    width: 150,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          electricityType.value == 'postpaid'
                                              ? Border.all(
                                                  color: AppColor.primaryColor,
                                                  width: 2,
                                                )
                                              : const Border.fromBorderSide(
                                                  BorderSide.none),
                                    ),
                                    child: const Text(
                                      "Postpaid",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onTap: () {
                                    electricityType.value = 'postpaid';
                                  },
                                ),
                                if (electricityType.value == 'postpaid')
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.elliptical(30, 30),
                                        ),
                                        color: AppColor.primaryColor,
                                      ),
                                      padding: const EdgeInsets.only(
                                          top: 4, left: 4),
                                      child: const Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Meter Number",
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
                          onChanged: (value) {},
                          maxLength: 20,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: meterController,
                          focusNode: focusNode,
                          validator: ValidationBuilder()
                              .required()
                              .maxLength(11)
                              .build(),
                          decoration: const InputDecoration(
                            hintText: "Enter Meter Number",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: AppColor.primaryColor,
                            ),
                            disabledBorder: InputBorder.none,
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
                          height: 20,
                        ),
                        Builder(
                          builder: (context) {
                            if (userIdName.value != null) {
                              return NamePreview(text: userIdName.value!);
                            }
                            return const SizedBox();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Select Amount",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFont.mulish,
                            fontSize: 20,
                          ),
                        ),
                        GridView.builder(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.only(bottom: 20),
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemCount: bettingPrice.length,
                          itemBuilder: (context, index) {
                            return TouchableOpacity(
                              onTapDown: (_) => amountSelected.value = index,
                              onTapUp: (_) => amountSelected.value = null,
                              onTap: () {
                                amountController.text =
                                    bettingPrice[index]['price'].toString();
                              },
                              activeOpacity: 0.7,
                              // onTapDown: (_) => selectedPlan.value = null,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: amountSelected.value == index
                                      ? AppColor.primaryColor
                                      : Colors.black.withOpacity(0.04),
                                  border: Border.all(
                                      color: AppColor.primaryColor,
                                      width: 2,
                                      strokeAlign:
                                          BorderSide.strokeAlignInside),
                                ),
                                margin: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          currency(context),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: AppFont.mulish,
                                            fontSize: 15,
                                            color: amountSelected.value == index
                                                ? Colors.white
                                                : AppColor.secondaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          bettingPrice[index]['price']
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color:
                                                  amountSelected.value == index
                                                      ? Colors.white
                                                      : AppColor.primaryColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Pay",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: AppFont.mulish,
                                            fontSize: 10,
                                            color: amountSelected.value == index
                                                ? Colors.white
                                                : AppColor.secondaryColor,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "${currency(context)}${bettingPrice[index]['price']}",
                                          style: TextStyle(
                                              fontFamily: AppFont.mulish,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                              color:
                                                  amountSelected.value == index
                                                      ? Colors.white
                                                      : AppColor.primaryColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: amountController,
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: "50, - 1,000,000",
                                  helperText: '',
                                  prefix: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      currency(context),
                                      style: const TextStyle(
                                        fontFamily: AppFont.mulish,
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                  ),
                                  focusedBorder: borderStyle,
                                  enabledBorder: borderStyle,
                                  focusedErrorBorder: borderStyle,
                                  errorBorder: borderStyle,
                                  border: borderStyle,
                                  contentPadding: const EdgeInsets.all(8),
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFont.aeonik,
                                    fontSize: 23,
                                  ),
                                ),
                                validator:
                                    ValidationBuilder().required().build(),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: false),
                                onTapOutside: (v) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_formKey.currentState!.validate()) {
                              appModalWithoutRoot(
                                context,
                                title: "Electricity Checkout Preview",
                                child: checkout(),
                              );
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
