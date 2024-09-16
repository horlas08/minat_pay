import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/widget/Button.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:show_confirm_modal/show_confirm_modal.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../cubic/app_config_cubit.dart';
import '../../../helper/helper.dart';
import '../../../model/app.dart';

class AppSettings extends HookWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    const double space = 35;
    // final ValueNotifier<bool> EnableFingePrint = useState(false);
    // final ValueNotifier<bool> EnableNotification = useState(false);
    //
    // useEffect(() {}, []);

    return Scaffold(
      appBar: const AppHeader(title: "App Settings"),
      body: BlocConsumer<AppConfigCubit, App>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.all(
                    18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TouchableOpacity(
                        onTap: () {
                          context.pushNamed('profile');
                        },
                        behavior: HitTestBehavior.deferToChild,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_off_outlined,
                                  ),
                                  Text(
                                    "Profile Settings",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ]),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: space,
                      ),
                      TouchableOpacity(
                        behavior: HitTestBehavior.deferToChild,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications,
                                  ),
                                  Text(
                                    "Enable Notification",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ]),
                            FlutterSwitch(
                              width: 55.0,
                              height: 30.0,
                              valueFontSize: 15.0,
                              toggleSize: 20.0,
                              value: state.enableNotification,
                              borderRadius: 30.0,
                              padding: 4.0,
                              activeIcon: const Icon(
                                Icons.check,
                                size: 15,
                                color: AppColor.primaryColor,
                              ),
                              inactiveIcon: const Icon(
                                Icons.close,
                                size: 15,
                                color: AppColor.primaryColor,
                              ),

                              activeColor: AppColor.primaryColor,
                              // activeToggleColor: AppColor.primaryColor,
                              showOnOff: true,
                              onToggle: (bool value) {
                                context
                                    .read<AppConfigCubit>()
                                    .enableNotification(value);
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: space,
                      ),
                      TouchableOpacity(
                        behavior: HitTestBehavior.deferToChild,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(
                                    Icons.fingerprint,
                                  ),
                                  Text(
                                    "Enable Finger Print",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ]),
                            FlutterSwitch(
                              width: 55.0,
                              height: 30.0,
                              valueFontSize: 15.0,
                              toggleSize: 20.0,
                              value: state.enableFingerPrint,
                              borderRadius: 30.0,
                              padding: 4.0,
                              activeIcon: const Icon(
                                Icons.check,
                                size: 15,
                                color: AppColor.primaryColor,
                              ),
                              inactiveIcon: const Icon(
                                Icons.close,
                                size: 15,
                                color: AppColor.primaryColor,
                              ),

                              activeColor: AppColor.primaryColor,
                              // activeToggleColor: AppColor.primaryColor,
                              showOnOff: true,
                              onToggle: (bool value) {
                                context
                                    .read<AppConfigCubit>()
                                    .enableFingerPrint(value);
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: space,
                ),
                Container(
                  padding: const EdgeInsets.all(
                    18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      TouchableOpacity(
                        onTap: () {
                          context.pushNamed('changePin');
                        },
                        behavior: HitTestBehavior.deferToChild,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(children: [
                              Icon(
                                Icons.password,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Change Pin",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: space,
                      ),
                      TouchableOpacity(
                        onTap: () {
                          context.pushNamed('changePassword');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(children: [
                              Icon(
                                Icons.lock_clock_outlined,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                            Icon(Icons.arrow_forward_ios_rounded)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: space,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(
                          18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          "Delete Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      enableFeedback: true,
                      onTap: () {
                        showConfirm(
                          context: context,
                          onCancel: () {},
                          onConfirm: () {},
                          title: "Delete My Account",
                          content:
                              "Are you Sure You Want To Delete Your Account",
                        );
                        showDeleteAcc();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(
                          18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.delete,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: space,
                ),
                Button(
                  onpressed: () async {
                    await handleLogOut(context);
                  },
                  child: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void showDeleteAcc() {}
}
