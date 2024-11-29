import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:minat_pay/model/providers.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:radio_group_v2/utils/radio_group_decoration.dart';
import 'package:radio_group_v2/widgets/view_models/radio_group_controller.dart';
import 'package:radio_group_v2/widgets/views/radio_group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../config/app.config.dart';
import '../../../config/color.constant.dart';
import '../../../helper/helper.dart';
import '../../../main.dart';
import '../../../model/epin_providers.dart';
import '../../../model/nin_provider.dart';

final _formKey = GlobalKey<FormState>();
RadioGroupController myController = RadioGroupController();

enum Network { mtn, airtel, glo }

class AirtimeToCash extends HookWidget {
  const AirtimeToCash({super.key});

  @override
  Widget build(BuildContext context) {
    final amountController = useTextEditingController();
    final nameController = useTextEditingController();
    final networkController = useTextEditingController();
    final ValueNotifier<List<NinProvider>> ninList = useState([]);
    final ValueNotifier<Providers> selectedNinType = useState(NinProvider());
    final ValueNotifier<bool> ninTypeIsLoading = useState(false);
    Future<Response?> changePinRequest(BuildContext context) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final res = await curlPostRequest(
        path: changePin,
        data: {
          "old_pin": amountController.text, //variationId,
          "pin": nameController.text, //variationId,
          "confirm_pin": networkController.text, //phone,
          "token": sharedPreferences.getString('token'), //phone,
        },
      );
      return res;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AppHeader(title: "Airtime to Cash"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RadioGroup(
                      controller: myController,
                      values: [
                        "Mtn",
                        "Airtel",
                        "Glo",
                        "9Mobile",
                      ],
                      indexOfDefault: 0,
                      orientation: RadioGroupOrientation.horizontal,
                      decoration: RadioGroupDecoration(
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
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationBuilder().required().build(),
                      controller: amountController,
                      style: const TextStyle(color: AppColor.primaryColor),
                      decoration: const InputDecoration(
                        hintText: "Enter Amount",
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryColor,
                        ),
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
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationBuilder().required().build(),
                      controller: nameController,
                      style: const TextStyle(color: AppColor.primaryColor),
                      decoration: const InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryColor,
                        ),
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
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (_formKey.currentState!.validate()) {
                          try {
                            final url = Uri.parse(
                                "https://wa.me/${appServer.serverResponse.contact!.whatsapp!}?text=hello%20am%20${nameController.text}%0Ai%20want%20to%20convert%20${amountController.text}%20Naira%20${myController.value}%20airtime%20%20to%20cash");
                            await launchUrl(url);
                          } on PlatformException catch (error) {
                            if (!context.mounted) return;
                            await alertHelper(
                                context, 'error', error.message ?? "error");
                          }
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          const Size.fromHeight(65),
                        ),
                      ),
                      child: const Text(
                        "Convert Now",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
  }

  getEpinList(BuildContext context, ninIsLoading, ninTypeList) async {
    ninIsLoading.value = true;
    List<EpinProviders> list = [];
    final res = await curl2GetRequest(
      path: getEpin,
      options: Options(
        headers: {'Authorization': context.read<AppBloc>().state.user?.apiKey},
      ),
    );

    if (res?.statusCode == HttpStatus.ok) {
      print(res);
      list = List.generate(
        res?.data['data'].length,
        (index) {
          return EpinProviders(
            id: res?.data['data'][index]['id'],
            name: res?.data['data'][index]['name'],
            amount: res?.data['data'][index]['amount'],
            amountAgent: res?.data['data'][index]['amount_agent'],
            type: res?.data['data'][index]['type'],
            amountApi: res?.data['data'][index]['amount_api'],
            instruction: res?.data['data'][index]['instruction'],
            number: res?.data['data'][index]['number'],
            status: res?.data['data'][index]['status'],
            image: res?.data['data'][index]['logo'],
          );
        },
      );
    }
    Future.delayed(const Duration(seconds: 10));

    ninTypeList.value = list;
    ninIsLoading.value = false;
    return list;
  }
}
