import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../config/app.config.dart';
import '../../../config/color.constant.dart';
import '../../../config/font.constant.dart';
import '../../../helper/helper.dart';
import '../../../model/nin_provider.dart';

final _formKey = GlobalKey<FormState>();

class Nin extends HookWidget {
  const Nin({super.key});

  @override
  Widget build(BuildContext context) {
    final ninTypeController = useTextEditingController();
    final amountController = useTextEditingController();
    final ninNumberPinController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoeNumberPinController = useTextEditingController();
    final ValueNotifier<List<NinProvider>> ninList = useState([]);
    final ValueNotifier<NinProvider> selectedNinType = useState(NinProvider());
    final ValueNotifier<bool> ninTypeIsLoading = useState(false);

    Future<Response?> ninServiceRequest(BuildContext context) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final res = await curl2PostRequest(
        path: postNin,
        data: {
          "ninid_type": selectedNinType.value.id,
          "nin": ninNumberPinController.text,
          "email": emailController.text,
        },
        options: Options(headers: {
          'Authorization': context.read<AppBloc>().state.user?.apiKey
        }),
      );
      return res;
    }

    useEffect(() {
      if (selectedNinType.value.id != null) {
        ninTypeController.text = selectedNinType.value.name!;
        amountController.text = selectedNinType.value.amount!;
      }
      return null;
    }, [selectedNinType.value]);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AppHeader(title: "NIN Service"),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "This service is for those who can\'t remember their NIN number or want to convert their NIN to plastic type",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFont.mulish,
                        fontSize: 16,
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
                      controller: ninTypeController,
                      readOnly: true,
                      onTap: () async {
                        final examProvider = ninList.value.isNotEmpty
                            ? ninList.value
                            : await getNinTypeRequest(
                                context, ninTypeIsLoading, ninList);
                        if (context.mounted) {
                          showProviderPicker(
                              context, examProvider, selectedNinType);
                        }
                      },
                      style: const TextStyle(color: AppColor.primaryColor),
                      decoration: InputDecoration(
                        hintText: "NIN Type",
                        hintStyle: const TextStyle(
                          fontSize: 18,
                          color: AppColor.primaryColor,
                        ),
                        border: InputBorder.none,
                        suffixIcon: ninTypeIsLoading.value
                            ? const UnconstrainedBox(
                                child: SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const Icon(Icons.arrow_forward_ios_rounded),
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
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationBuilder().required().build(),
                      controller: amountController,
                      readOnly: true,
                      style: const TextStyle(color: AppColor.primaryColor),
                      decoration: const InputDecoration(
                        hintText: "Service Amount",
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
                    TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationBuilder().required().build(),
                      controller: ninNumberPinController,
                      maxLength: 11,
                      style: const TextStyle(color: AppColor.primaryColor),
                      decoration: const InputDecoration(
                        hintText: "Enter NIN or Phone number",
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
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   validator: ValidationBuilder().required().build(),
                    //   controller: phoeNumberPinController,
                    //   style: const TextStyle(color: AppColor.primaryColor),
                    //   keyboardType: TextInputType.numberWithOptions(
                    //     decimal: true,
                    //     signed: false,
                    //   ),
                    //   decoration: const InputDecoration(
                    //     hintText: "Enter Phone No(used for nin)",
                    //     hintStyle: TextStyle(
                    //       fontSize: 18,
                    //       color: AppColor.primaryColor,
                    //     ),
                    //     border: InputBorder.none,
                    //     enabledBorder: InputBorder.none,
                    //     errorBorder: InputBorder.none,
                    //     focusedErrorBorder: InputBorder.none,
                    //     focusedBorder: InputBorder.none,
                    //   ),
                    //   onTapOutside: (v) {
                    //     FocusManager.instance.primaryFocus?.unfocus();
                    //   },
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: ValidationBuilder().required().email().build(),
                      controller: emailController,
                      style: const TextStyle(color: AppColor.primaryColor),
                      decoration: const InputDecoration(
                        hintText: "Email",
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
                          context.loaderOverlay.show();

                          final res = await ninServiceRequest(context);

                          if (context.mounted) {
                            context.loaderOverlay.hide();
                          }
                          if (res == null && context.mounted) {
                            return await alertHelper(
                              context,
                              'error',
                              "Check Your Internet Connection",
                            );
                          }
                          if (res?.statusCode != HttpStatus.ok &&
                              context.mounted) {
                            await alertHelper(
                              context,
                              'error',
                              res?.data['message'],
                            );
                          } else {
                            if (context.mounted) {
                              selectedNinType.value = NinProvider();
                              amountController.text = '';
                              emailController.text = '';
                              ninNumberPinController.text = '';
                              phoeNumberPinController.text = '';
                              await alertHelper(
                                context,
                                'success',
                                res?.data['message'],
                              );
                            }
                          }
                        }
                      },
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          const Size.fromHeight(65),
                        ),
                      ),
                      child: const Text(
                        "Make Payment",
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

  getNinTypeRequest(BuildContext context, ninIsLoading, ninTypeList) async {
    ninIsLoading.value = true;
    List<NinProvider> list = [];
    final res = await curl2GetRequest(
      path: getNin,
      options: Options(
        headers: {'Authorization': context.read<AppBloc>().state.user?.apiKey},
      ),
    );

    if (res?.statusCode == HttpStatus.ok) {
      print(res);
      list = List.generate(
        res?.data['data'].length,
        (index) {
          return NinProvider(
            id: res?.data['data'][index]['id'],
            name: res?.data['data'][index]['name'],
            status: res?.data['data'][index]['status'],
            slug: res?.data['data'][index]['logo'],
            amount: res?.data['data'][index]['amount'],
          );
        },
      );
    }

    ninTypeList.value = list;
    ninIsLoading.value = false;
    return list;
  }
}
