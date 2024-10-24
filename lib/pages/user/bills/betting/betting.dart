import 'dart:io';

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
import '../../../../data/mock/dummy_data.dart';
import '../../../../helper/helper.dart';
import '../../../../model/app.dart';
import '../../../../model/betting_providers.dart';
import '../../../../widget/Button.dart';

final _formKey = GlobalKey<FormState>();

class Betting extends HookWidget {
  const Betting({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountController = useTextEditingController();

    final TextEditingController idController = useTextEditingController();

    final bettingProviderInputController = useTextEditingController();

    useEffect(() {
      amountController.text = '';
      idController.text = '';
      return null;
    }, []);
    final focusNode = useFocusNode();
    final ValueNotifier<int?> amountSelected = useState(null);
    UnderlineInputBorder borderStyle = const UnderlineInputBorder(
      borderSide: BorderSide(
          style: BorderStyle.solid, color: AppColor.primaryColor, width: 2),
    );
    final ValueNotifier<List<BettingProviders>> networkProviders = useState([]);
    final ValueNotifier<BettingProviders> selectedProvider =
        useState(BettingProviders());
    final ValueNotifier<bool> valid = useState(false);
    final ValueNotifier<String> userIdName = useState('');
    final ValueNotifier<BettingProviders> pickedNetwork =
        useState(BettingProviders());
    Future<void> onFocusChange() async {
      if (focusNode.hasFocus == false &&
          pickedNetwork.value != null &&
          idController.value.text != '') {
        context.loaderOverlay.show();
        final res = await curl2GetRequest(
            path: verifyBetting,
            queryParams: {
              'customer_id': idController.text,
              'service_id': pickedNetwork.value?.id,
            },
            options: Options(headers: {
              'Authorization': context.read<AppBloc>().state.user?.apiKey
            }));
        print(res?.data);

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
      if (idController.text.isNotEmpty) {
        onFocusChange();
      }

      return null;
    }, [selectedProvider.value]);

    final user = context.read<AppBloc>().state.user;
    Future<List<BettingProviders>> getBettingList(
        BuildContext context, ValueNotifier<bool> networkIsLoading) async {
      networkIsLoading.value = true;
      List<BettingProviders> list = [];
      final res = await curl2GetRequest(
          path: getBetting,
          options: Options(headers: {
            'Authorization': context.read<AppBloc>().state.user?.apiKey
          }));
      if (res?.statusCode == HttpStatus.ok) {
        list = List.generate(
          res?.data['data'].length,
          (index) {
            return BettingProviders(
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

      networkProviders.value = list;
      networkIsLoading.value = false;
      return list;
    }

    final bettingIsLoading = useState(false);
    useEffect(() {
      if (selectedProvider.value.id != null &&
          networkProviders.value.isNotEmpty) {
        pickedNetwork.value = networkProviders.value.firstWhere(
          (element) {
            return element.id == selectedProvider.value.id;
          },
        );
        bettingProviderInputController.text = pickedNetwork.value.name!;
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
        path: postBetting,
        data: {
          'amount': amount,
          'customer_id': idController.text,
          'service_id': pickedNetwork.value?.id,
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
            title: 'Betting',
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
                                  context, networkProvider, selectedProvider);
                            }
                          },
                          child: TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: false,
                            ),
                            validator: ValidationBuilder().required().build(),
                            controller: bettingProviderInputController,
                            enabled: false,
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
                          "User Id",
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
                          controller: idController,
                          focusNode: focusNode,
                          validator: ValidationBuilder().required().build(),
                          enabled:
                              bettingProviderInputController.text.isNotEmpty,
                          decoration: InputDecoration(
                            hintText: bettingProviderInputController
                                    .text.isEmpty
                                ? ''
                                : "Enter ${bettingProviderInputController.text} Number",
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
                        GridView.builder(
                          scrollDirection: Axis.vertical,
                          // cacheExtent: 30,
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
                                        SizedBox(
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
                                validator:
                                    ValidationBuilder().required().build(),
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: "Enter Amount",
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
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: false),
                                onTapOutside: (v) => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
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
