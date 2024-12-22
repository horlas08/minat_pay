import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as contact_picker;
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/app.config.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/config/font.constant.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:minat_pay/model/app.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../bloc/repo/app/app_bloc.dart';
import '../../../../cubic/app_config_cubit.dart';
import '../../../../data/user/bill_service.dart';
import '../../../../model/data_providers.dart';
import '../../../../widget/Button.dart';

final PhoneController _phoneController = PhoneController(
    initialValue: const PhoneNumber(isoCode: IsoCode.NG, nsn: ''));
int test = 0;

Future<List<DataProviders>?> getDataFromServer(
    BuildContext context,
    ValueNotifier<bool> networkIsLoading,
    ValueNotifier<List<DataProviders>> networkProviders) async {
  networkIsLoading.value = true;
  context.loaderOverlay.show();
  List<DataProviders> list = [];
  print(context.read<AppBloc>().state.user?.apiKey);
  final res = await curl2GetRequest(
      path: getDataAvailability,
      options: Options(headers: {
        'Authorization': context.read<AppBloc>().state.user?.apiKey
      }));

  if (res == null && context.mounted) {
    context.loaderOverlay.hide();
    return alertHelper(context, 'error', "Check Your Internet Connection");
  }

  if (res?.statusCode == HttpStatus.ok) {
    res?.data.forEach(
      (name, datas) {
        print(datas['logo']);
        list.add(
          DataProviders(
              id: datas['id'],
              name: name,
              image: datas['logo'],
              data_type: datas['data_type']),
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
    List<DataProviders> networkProviders,
    ValueNotifier<DataProviders> network) async {
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

UnderlineInputBorder borderStyle = const UnderlineInputBorder(
  borderSide: BorderSide(
      style: BorderStyle.solid, color: AppColor.primaryColor, width: 2),
);
final contact_picker.FlutterNativeContactPicker _contactPicker =
    new contact_picker.FlutterNativeContactPicker();
final _dataFormKey = GlobalKey<FormState>();

class Data extends HookWidget {
  const Data({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      // phoneController.value = PhoneNumber(isoCode: IsoCode.NG, nsn: '');
      // return () {
      //   return phoneController.dispose();
      // };
    }, []);
    final ValueNotifier<bool> valid = useState(false);
    final user = context.read<AppBloc>().state.user;
    // final ValueNotifier<List?> networks = useState([]);
    final ValueNotifier<int?> selectedPlanIndex = useState(null);
    final ValueNotifier<Map<String, dynamic>?> selectedPlan = useState(null);
    final ValueNotifier<int> selectedNetwork = useState(1);
    final ValueNotifier<bool> openNetwork = useState(false);
    final ValueNotifier<bool> planAvailable = useState(false);
    final ValueNotifier<bool> networkIsLoading = useState(false);

    final ValueNotifier<List?> plans = useState([]);
    final ValueNotifier<List<DataProviders>> networkProviders = useState([]);
    final ValueNotifier<String> dataType = useState('');
    final ValueNotifier<DataProviders> network = useState(DataProviders());

    Future<Response?> buyData(
      BuildContext context, {
      required String variationId,
      required String phone,
      String? trxId,
      required String dataType,
      required String networkId,
    }) async {
      final airtimeRequest = BillService();
      final Response? res = await airtimeRequest.dataRequest(
        context,
        variationId: variationId,
        phone: phone,
        dataType: dataType,
        networkId: networkId,
      );
      return res;
    }

    handleCheckOut(BuildContext context) async {
      try {
        context.loaderOverlay.show();
        final res = await buyData(
          context,
          variationId: selectedPlan.value?['id'],
          phone: '0${_phoneController.value.nsn}',
          dataType: dataType.value,
          networkId: network.value.id!,
        );
        print(res);
        print(res?.statusCode);

        if (context.mounted && res == null) {
          await alertHelper(context, 'error', 'No Internet Connection');
        }
        //
        if (context.mounted) {
          if (res?.statusCode == HttpStatus.ok) {
            _phoneController.value = PhoneNumber(isoCode: IsoCode.NG, nsn: '');

            await putLastTransactionId(res?.data['data']['trx_id']);
            if (context.mounted) {
              await HapticFeedback.heavyImpact();
              if (context.mounted) {
                appModalWithoutRoot(context,
                    title: 'Data Purchase Successful',
                    child: successModalWidget(context,
                        message: res?.data['message']));
              }
            }
          } else {
            context.loaderOverlay.hide();
            return await alertHelper(
              context,
              'error',
              res?.data['message'],
              duration: 6,
            );
          }
        }
        if (context.mounted) {
          context.loaderOverlay.hide();
        }
      } on DioException catch (error) {
        if (!context.mounted) return;
        context.loaderOverlay.hide();
        await alertHelper(
          context,
          'error',
          error.response?.data['message'],
          duration: 6,
        );
      } on Exception catch (error) {
        if (!context.mounted) return;
        context.loaderOverlay.hide();
        await alertHelper(
          context,
          'error',
          error.toString(),
          duration: 6,
        );
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
                    CachedNetworkImage(
                      imageUrl: network.value.image!,
                      height: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
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
                user?.userType == true
                    ? Text(
                        '${currency(context)}${double.parse(selectedPlan.value?['amount']) - double.parse(selectedPlan.value?['amount_agent'])}',
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
                  margin: EdgeInsets.symmetric(horizontal: 100),
                  waitDuration: const Duration(seconds: 2),
                  preferBelow: false,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                  ),
                  richMessage: user!.userType == true
                      ? TextSpan(
                          text:
                              'You are getting cashback because You have Upgrade Your account from user to agent')
                      : TextSpan(
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
                        '${currency(context)}${selectedPlan.value?['amount_agent']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: AppFont.mulish,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        '${currency(context)}${selectedPlan.value?['amount']}',
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
                  '${_phoneController.value.countryCode} ${_phoneController.value.nsn}',
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
                if (Navigator.canPop(context)) {
                  Navigator.of(context, rootNavigator: true).pop(context);
                }

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

    useEffect(() {
      if (networkProviders.value.isEmpty) {
        getDataFromServer(context, networkIsLoading, networkProviders).then(
          (value) {
            dataType.value = networkProviders.value[0].data_type!.keys.first;

            network.value = networkProviders.value[0];
          },
        ).onError(
          (error, stackTrace) {
            if (!context.mounted) return;

            context.loaderOverlay.hide();
          },
        );
      }

      return null;
    }, []);

    useEffect(() {
      if (dataType.value != '') {
        dataType.value = network.value.data_type!.keys.first;
        selectedPlanIndex.value = 0;
        selectedPlan.value = network.value.data_type![dataType.value][0];
      }
      return null;
    }, [network.value]);

    return BlocConsumer<AppConfigCubit, App>(
      listener: (context, state) {
        if (state.pinState == true) {
          handleCheckOut(
            context,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          // extendBody: true,
          appBar: AppBar(
            title: const Text(
              'Mobile Data',
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
              )
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _dataFormKey,
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

                                // print(PhoneNumber.parse(contact!.phoneNumbers!.last,
                                //     callerCountry: IsoCode.NG));
                                _phoneController.value = PhoneNumber(
                                    isoCode: IsoCode.NG,
                                    nsn: contact!.phoneNumbers!.last);
                                if (_phoneController.value.isValid() &&
                                    _phoneController.value.isValidLength() &&
                                    context.mounted) {
                                  detectNetwork(
                                    context,
                                    '0${_phoneController.value.nsn}',
                                    networkProviders.value,
                                    network,
                                  );
                                }
                                // phoneController.value = PhoneNumber.parse(
                                //     contact!.phoneNumbers!.last,
                                //     callerCountry: IsoCode.NG);
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

                            controller: _phoneController,
                            // initialValue: phone.value,
                            // or use the
                            // PhoneNumber.parse(phone.value), // or use the
                            // controller
                            validator: PhoneValidator.compose([
                              PhoneValidator.required(context),
                              PhoneValidator.validMobile(context)
                            ]),

                            onChanged: (phoneNumber) {
                              print(_phoneController.value.nsn.length);
                              if (_phoneController.value.isValid() &&
                                  _phoneController.value.isValidLength() &&
                                  _phoneController.value.nsn.length >= 10) {
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
                                  getDataFromServer(context, networkIsLoading,
                                          networkProviders)
                                      .then(
                                    (value) {
                                      dataType.value = networkProviders
                                          .value[0].data_type!.keys.first;

                                      network.value = networkProviders.value[0];
                                    },
                                  );
                                },
                                icon: Icon(Icons.refresh_outlined)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (network.value.data_type != null)
                      if (network.value.data_type!.isNotEmpty)
                        Wrap(
                          alignment: WrapAlignment.start,
                          // crossAxisAlignment: WrapCrossAlignment.start,
                          // runAlignment: WrapAlignment.start,
                          spacing: 20,
                          runSpacing: 10,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...?network.value.data_type?.keys.map(
                              (name) {
                                return Stack(
                                  children: [
                                    TouchableOpacity(
                                      onTap: () {
                                        dataType.value = name;
                                        selectedPlanIndex.value = 0;
                                        selectedPlan.value = network.value
                                            .data_type![dataType.value][0];
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryColor
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: dataType.value == name
                                              ? Border.all(
                                                  color: AppColor.primaryColor,
                                                  width: 2,
                                                )
                                              : Border.fromBorderSide(
                                                  BorderSide.none),
                                        ),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    if (dataType.value == name)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.elliptical(30, 30),
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
                                );
                              },
                            )
                          ],
                        ),
                    const SizedBox(
                      height: 50,
                    ),
                    if (network.value.data_type != null)
                      network.value.data_type!.isNotEmpty
                          ? GridView.builder(
                              scrollDirection: Axis.vertical,
                              cacheExtent: 130,
                              padding: const EdgeInsets.only(bottom: 20),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              dragStartBehavior: DragStartBehavior.start,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemCount: network
                                  .value.data_type![dataType.value].length,
                              itemBuilder: (context, index) {
                                final agentPrice = double.parse(
                                        network.value.data_type![dataType.value]
                                            [index]['amount']) -
                                    double.parse(
                                        network.value.data_type![dataType.value]
                                            [index]['amount_agent']);

                                return TouchableOpacity(
                                  onTap: () {
                                    selectedPlan.value = network.value
                                        .data_type![dataType.value][index];

                                    print(selectedPlan.value);
                                    selectedPlanIndex.value = index;
                                  },
                                  activeOpacity: 0.7,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: selectedPlanIndex.value == index
                                          ? AppColor.primaryColor
                                          : Colors.black.withOpacity(0.1),
                                      border: Border.all(
                                          color: AppColor.primaryColor,
                                          width: 2,
                                          strokeAlign:
                                              BorderSide.strokeAlignInside),
                                    ),
                                    margin: const EdgeInsets.all(2),
                                    // color: AppColor.primaryColor,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          network.value
                                                  .data_type![dataType.value]
                                              [index]['plan'],
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                            fontSize: 12,
                                            color:
                                                selectedPlanIndex.value == index
                                                    ? Colors.white
                                                    : AppColor.secondaryColor,
                                          ),
                                        ),
                                        Text(
                                          network.value
                                                  .data_type![dataType.value]
                                              [index]['validity'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            height: 1.2,
                                            fontWeight:
                                                selectedPlanIndex.value == index
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          '${currency(context)} ${network.value.data_type![dataType.value][index]['amount'].toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: AppFont.mulish,
                                              height: 1.2,
                                              color: selectedPlanIndex.value ==
                                                      index
                                                  ? Colors.white
                                                  : AppColor.primaryColor),
                                        ),
                                        Text(
                                          'Agent -${currency(context)}$agentPrice',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: AppFont.mulish,
                                              fontSize: 10,
                                              color: selectedPlanIndex.value ==
                                                      index
                                                  ? Colors.white
                                                  : AppColor.primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text('No Data Available For This Type'),
                    if (selectedPlan.value != null &&
                        selectedPlanIndex.value != null)
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TouchableOpacity(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_dataFormKey.currentState!.validate()) {
                                appModalWithoutRoot(
                                  context,
                                  isDismissible: true,
                                  child: checkout(),
                                );
                              }
                            },
                            style: const ButtonStyle(
                              minimumSize: WidgetStatePropertyAll(
                                Size.fromHeight(65),
                              ),
                            ),
                            child: const Text(
                              "Pay Now",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
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
