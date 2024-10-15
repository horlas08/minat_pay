import 'dart:io';
import 'dart:math';

import 'package:animated_icon/animated_icon.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/app.config.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/helper/helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../../../bloc/repo/app/app_bloc.dart';
import '../../../../../bloc/repo/app/app_event.dart';
import '../../../../../bloc/repo/app/app_state.dart';
import '../../../../../widget/Button.dart';

final _bvnKey = GlobalKey<FormState>();
final bnvFieldController = TextEditingController();

class Bank extends HookWidget {
  const Bank({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> balanceColor = [Colors.red, Colors.greenAccent, Colors.purple];
    final ValueNotifier<int> accountType = useState(1);
    final accounts = context.read<AppBloc>().state.accounts;

    Future<Response?> generateMonnifyAccount(BuildContext context) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final res = await curlPostRequest(
          path: accountType.value == 1 ? generatemonnify : generatepsb,
          data: {
            'token': prefs.getString('token'),
            'bvn': bnvFieldController.text,
          });

      return res;
    }

    showBvnModal(BuildContext context) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'close',
        pageBuilder: (context, animation, secondaryAnimation) {
          return AlertDialog(
            // icon: Icon(Icons.add),
            title: const Text(
              "Enter Bvn",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              // height: 100,
              // width: double.infinity,
              constraints: const BoxConstraints(
                maxHeight: 180,
                minHeight: 100,
              ),
              child: Form(
                  key: _bvnKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bnv',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextFormField(
                        validator: ValidationBuilder().required().build(),
                        controller: bnvFieldController,
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: const TextStyle(color: AppColor.primaryColor),
                        decoration: const InputDecoration(
                          hintText: "",
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: AppColor.primaryColor,
                          ),
                          contentPadding: EdgeInsets.all(10),
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
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_bvnKey.currentState!.validate()) {
                              context.loaderOverlay.show();
                              final resp =
                                  await generateMonnifyAccount(context);
                              if (resp == null && context.mounted) {
                                context.pop();
                                context.loaderOverlay.hide();
                                return await alertHelper(context, "error",
                                    "Err Internet Connection");
                              }
                              if (resp?.statusCode == HttpStatus.ok) {
                                final res = await refreshUSerDetail();
                                if (res == null && context.mounted) {
                                  context.pop();
                                  context.loaderOverlay.hide();
                                  return await alertHelper(context, "error",
                                      "Unable to Update Check Internet Connection");
                                }
                                print(res);
                                if (res?.statusCode == HttpStatus.ok &&
                                    context.mounted) {
                                  context.read<AppBloc>().add(UpdateUserEvent(
                                      userData: res?.data['data']
                                          ['user_data']));
                                  context.pop();
                                  context.loaderOverlay.hide();

                                  return await alertHelper(context, "success",
                                      resp?.data['message']);
                                }
                              } else {
                                if (context.mounted) {
                                  context.loaderOverlay.hide();
                                  await alertHelper(
                                      context, 'error', resp?.data['message']);
                                }
                              }
                              if (context.mounted &&
                                  context.loaderOverlay.visible) {
                                context.loaderOverlay.hide();
                              }
                            }
                          },
                          child: Text(
                            'Create Bank',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          );
        },
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          print(state.user?.hasPsb!);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: AnimateIcon(
                        key: UniqueKey(),
                        onTap: () {},
                        iconType: IconType.continueAnimation,
                        height: 70,
                        width: 70,
                        color: Color.fromRGBO(
                            Random.secure().nextInt(255),
                            Random.secure().nextInt(255),
                            Random.secure().nextInt(255),
                            1),
                        animateIcon: AnimateIcons.bell,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            !state.user!.hasMonnify! && !state.user!.hasPsb!
                                ? "Account Generate Tips"
                                : "Fund Tips",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            !state.user!.hasMonnify! && !state.user!.hasPsb!
                                ? "Click Below Button To Generate An Account"
                                : "Transfer To Any Of This Account Number Below To Fund Your Wallet Automatically",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (!state.user!.hasMonnify! || !state.user!.hasPsb!)
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      if (!state.user!.hasMonnify!)
                        Expanded(
                          child: Button(
                            onpressed: () {
                              if (accountType.value != 1) {
                                accountType.value = 1;
                              }
                              showBvnModal(context);
                            },
                            child: const Text(
                              "Generate Monnify Acc.",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (!state.user!.hasMonnify! && !state.user!.hasPsb!)
                        const SizedBox(
                          width: 10,
                        ),
                      if (!state.user!.hasPsb!)
                        Expanded(
                          child: Button(
                            onpressed: () {
                              if (accountType.value != 2) {
                                accountType.value = 2;
                              }
                              showBvnModal(context);
                            },
                            child: const Text(
                              "Generate Psb Acc",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ...?accounts?.map(
                (account) {
                  return Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // color: balanceColor[2],
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Virtual Account",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                account.accountNumber!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Bank Bank",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                account.bankName!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Account Name",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                account.accountName!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TouchableOpacity(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      )),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Share",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      AnimateIcon(
                                        key: UniqueKey(),
                                        onTap: () {},
                                        iconType: IconType.continueAnimation,
                                        height: 20,
                                        width: 20,
                                        color: Colors.white,
                                        animateIcon: AnimateIcons.share,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  final result = await Share.share(
                                      'Account Number: ${account.accountNumber}  \n Account Name: ${account.accountName} \n Bank Name: ${account.bankName}');

                                  if (result.status ==
                                      ShareResultStatus.success) {
                                    print(
                                        'Thank you for sharing your account details');
                                  }
                                },
                              ),

                              // const Spacer(),
                              TouchableOpacity(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      )),
                                  padding: const EdgeInsets.all(10),
                                  child: const Row(
                                    children: [
                                      Text(
                                        "Copy",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.copy,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: account.accountNumber!,
                                    ),
                                  ).then(
                                    (value) {
                                      alertHelper(context, 'success',
                                          'Account Number (${account.accountNumber!}) Copy SuccessFul');
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
    );
  }
}
