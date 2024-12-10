import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as contact_picker;
import 'package:form_validation/form_validation.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/bloc/repo/app/app_bloc.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/data/user/bill_service.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:minat_pay/model/airtime_providers.dart';
import 'package:minat_pay/widget/Button.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../config/app.config.dart';
import '../../../../cubic/app_config_cubit.dart';
import '../../../../data/mock/dummy_data.dart';
import '../../../../model/app.dart';
import '../../../../widget/app_header.dart';

final PhoneController phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.NG, nsn: ''));
final _airtimeFormKey = GlobalKey<FormState>();

Future<List<AirtimeProviders>> getAirtimeList(
    BuildContext context,
    ValueNotifier<bool> networkIsLoading,
    ValueNotifier<List<AirtimeProviders>> networkProviders) async {
  networkIsLoading.value = true;
  context.loaderOverlay.show();
  List<AirtimeProviders> list = [];

  final res = await curl2GetRequest(
      path: getAirtimeNetwork,
      options: Options(headers: {
        'Authorization': context.read<AppBloc>().state.user?.apiKey
      }));

  if (res == null && context.mounted) {
    context.loaderOverlay.hide();
    return alertHelper(context, 'error', "Check Your Internet Connection");
  }

  if (res?.statusCode == HttpStatus.ok) {
    list = List.generate(
      res?.data['data'].length,
      (index) {
        return AirtimeProviders(
          id: res?.data['data'][index]['id'],
          name: res?.data['data'][index]['name'],
          valId: res?.data['data'][index]['service_id'],
          image: res?.data['data'][index]['image'],
          user: res?.data['data'][index]['user'],
          agent: res?.data['data'][index]['agent'],
        );
      },
    );
  }

  networkProviders.value = list;
  networkIsLoading.value = false;
  if (context.mounted) {
    context.loaderOverlay.hide();
  }

  return list;
}

detectNetwork(
    BuildContext context,
    String number,
    List<AirtimeProviders> networkProviders,
    ValueNotifier<AirtimeProviders> network) async {
  try {
    context.loaderOverlay.show();
    final res = await curl2GetRequest(
        path: verifyNetwork,
        options: Options(headers: {
          'Authorization': context.read<AppBloc>().state.user?.apiKey
        }),
        queryParams: {'phone': number});
    if (res == null && context.mounted) {
      return alertHelper(context, 'error', 'Check Internet Connection');
    }
    final provider = networkProviders.firstWhere(
      (networkProvider) {
        return networkProvider.name == res?.data['network'];
      },
    );
    network.value = provider;
  } catch (e) {
    print(e);
  } finally {
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
  }
}

class Airtime extends HookWidget {
  const Airtime({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();

    useEffect(() {
      amountController.text = '';
      phoneController.value = PhoneNumber(isoCode: IsoCode.NG, nsn: '');
      return null;
    }, []);
    final ValueNotifier<int?> selectedPlan = useState(null);

    final ValueNotifier<bool> networkIsLoading = useState(false);
    final ValueNotifier<List<AirtimeProviders>> networkProviders = useState([]);
    final user = context.read<AppBloc>().state.user;
    final ValueNotifier<AirtimeProviders> network =
        useState(AirtimeProviders());

    final balance = context.read<AppBloc>().state.user?.balance;
    UnderlineInputBorder borderStyle = const UnderlineInputBorder(
      borderSide: BorderSide(
          style: BorderStyle.solid, color: AppColor.primaryColor, width: 2),
    );
    final contact_picker.FlutterNativeContactPicker _contactPicker =
        contact_picker.FlutterNativeContactPicker();

    useEffect(() {
      print(networkProviders.value);
      if (networkProviders.value.isEmpty) {
        getAirtimeList(context, networkIsLoading, networkProviders).then(
          (value) => network.value = networkProviders.value[0],
        );
      }
      return null;
    }, []);

    Widget checkout() {
      const double space = 15;
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
                    if (network.value.image != null)
                      CachedNetworkImage(
                        imageUrl: network.value.image!,
                        width: 25,
                        height: 30,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    if (network.value.image != null)
                      Text(
                        network.value.name!,
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
                  '${currency(context)}${user!.userType! ? (double.parse(network.value.agent!) / 100 * double.parse(amountController.text)).toString() : (double.parse(network.value.user!) / 100 * double.parse(amountController.text)).toString()}',
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
                  "Phone Number",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  '${phoneController.value.countryCode} ${phoneController.value.nsn}',
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

    Future<Response?> buyAirtime(
      BuildContext context, {
      required String amount,
      required String phone,
      required String network_id,
    }) async {
      final airtimeRequest = BillService();
      final Response? res = await airtimeRequest.airtimeRequest(context,
          amount: amount, phone: phone, network_id: network_id);
      return res;
    }

    Future<void> handleCheckOut(BuildContext context,
        {required String amount,
        required String phone,
        required String networkId}) async {
      try {
        context.loaderOverlay.show();
        final res = await buyAirtime(context,
            amount: amount, phone: phone, network_id: networkId);

        if (context.mounted && res == null) {
          context.loaderOverlay.hide();
          // Navigator.of(context, rootNavigator: false).pop();
          return alertHelper(context, 'error', 'No Internet Connection');
        }

        if (context.mounted) {
          if (res?.statusCode == HttpStatus.ok) {
            amountController.text = '';
            phoneController.value =
                const PhoneNumber(isoCode: IsoCode.NG, nsn: '');
            await putLastTransactionId(res?.data['trx_id']);
            if (context.mounted) {
              await HapticFeedback.heavyImpact();
              if (context.mounted) {
                appModalWithoutRoot(context,
                    title: 'Airtime Purchase Successful',
                    child: successModalWidget(context,
                        message: res?.data['message']));
              }
            }
          } else {
            // Navigator.of(context, rootNavigator: true).pop();
            alertHelper(context, 'error', res?.data['message'], duration: 6);
          }
        }

        if (context.mounted) {
          context.loaderOverlay.hide();
        }
      } on DioException catch (error) {
        if (context.mounted) {
          context.loaderOverlay.hide();

          await alertHelper(context, 'error', error.response?.data['message']);
        }
      } on Exception catch (error) {
        if (context.mounted) {
          context.loaderOverlay.hide();

          await alertHelper(context, 'error', error.toString());
        }
      }
    }

    return BlocConsumer<AppConfigCubit, App>(
      listener: (context, state) {
        if (state.pinState == true) {
          handleCheckOut(
            context,
            amount: amountController.text,
            phone: '0${phoneController.value.nsn}',
            networkId: network.value.id!,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const AppHeader(title: 'Airtime Subscription'),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _airtimeFormKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          child: IconButton(
                              onPressed: () async {
                                final contact =
                                    await _contactPicker.selectContact();

                                phoneController.value = PhoneNumber(
                                  isoCode: IsoCode.NG,
                                  nsn: contact!.phoneNumbers!.last,
                                );
                                if (phoneController.value.isValid() &&
                                    phoneController.value.isValidLength() &&
                                    context.mounted) {
                                  detectNetwork(
                                    context,
                                    '0${phoneController.value.nsn}',
                                    networkProviders.value,
                                    network,
                                  );
                                }
                              },
                              icon: const Icon(Icons.people_alt_rounded)),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: PhoneFormField(
                            decoration: InputDecoration(
                              filled: false,
                              hintText: "Phone Number",
                              helperText: '',
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
                            onTapOutside: (v) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            enableSuggestions: true,
                            controller: phoneController,
                            validator: PhoneValidator.compose([
                              PhoneValidator.required(context),
                              PhoneValidator.validMobile(context)
                            ]),
                            onChanged: (phoneNumber) {
                              if (phoneController.value.isValid() &&
                                  phoneController.value.isValidLength()) {
                                detectNetwork(context, '0${phoneNumber.nsn}',
                                    networkProviders.value, network);
                              }
                            },
                            enabled: true,
                            isCountrySelectionEnabled: false,
                            countryButtonStyle: const CountryButtonStyle(
                              showDialCode: true,
                              showIsoCode: false,
                              showFlag: false,
                              showDropdownIcon: false,
                              flagSize: 20,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFont.aeonik,
                                fontSize: 23,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        networkProviders.value.isNotEmpty
                            ? TouchableOpacity(
                                activeOpacity: 0.4,
                                onTap: () {
                                  showProviderPicker(
                                      context, networkProviders.value, network);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                    imageUrl: network.value.image!,
                                    height: 40,
                                    width: 40,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  getAirtimeList(context, networkIsLoading,
                                          networkProviders)
                                      .then(
                                    (value) {
                                      if (value != null && value.isNotEmpty) {
                                        network.value =
                                            networkProviders.value[0];
                                      }
                                    },
                                  );
                                },
                                icon: Icon(Icons.refresh_outlined),
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Top Up",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(bottom: 20),
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        // dragStartBehavior: DragStartBehavior.start,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemCount: airtimePrice.length,

                        itemBuilder: (context, index) {
                          return TouchableOpacity(
                            onTapUp: (_) {
                              selectedPlan.value = null;
                            },
                            onTap: () {
                              selectedPlan.value = index;

                              amountController.text =
                                  airtimePrice[index]['price'].toString();
                            },
                            activeOpacity: 0.7,
                            // onTapDown: (_) => selectedPlan.value = null,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppColor.primaryColor,
                                    width: 2,
                                    strokeAlign: BorderSide.strokeAlignInside),
                              ),
                              margin: const EdgeInsets.all(15),

                              // color: AppColor.primaryColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currency(context),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: AppFont.mulish,
                                          fontSize: 15,
                                          // color: Theme.of(context).brightness ==
                                          //         Brightness.light
                                          //     ? Colors.black
                                          //     : Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        airtimePrice[index]['price'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: AppColor.primaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: amountController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (double.parse(value) >
                                    double.parse(balance!)) {
                                  return 'Insufficient Balance';
                                }
                              }

                              final validator = Validator(
                                validators: [
                                  const NumberValidator(),
                                  const RequiredValidator(),
                                  const MinNumberValidator(number: 50),
                                ],
                              );

                              return validator.validate(
                                label: 'Amount',
                                value: value,
                              );
                            },
                            decoration: InputDecoration(
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
                              filled: false,
                              hintText: "Enter Amount",
                              helperText: '',
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
                            onChanged: (value) {
                              final valueChangeLookUp = airtimePrice.where(
                                (element) {
                                  return element['price'] == value;
                                },
                              ).toList();
                              if (valueChangeLookUp.isNotEmpty) {
                                selectedPlan.value = valueChangeLookUp[0]['id'];
                              } else {
                                selectedPlan.value = null;
                              }
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            onTapOutside: (v) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextButton(
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColor.primaryColor),
                          ),
                          onPressed: () {
                            if (_airtimeFormKey.currentState!.validate()) {
                              // showConfirmPinRequest(context);
                              appModalWithoutRoot(context,
                                  isDismissible: true, child: checkout()
                                  // child: successModalWidget(
                                  //   message: 'Airtime Purchase Successfully',
                                  // ),
                                  );
                            }
                          },
                          child: const Text(
                            "Pay",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    Text(
                      "Your Balance is ${currency(context)} ${balance}",
                      style: const TextStyle(
                        fontFamily: AppFont.mulish,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
