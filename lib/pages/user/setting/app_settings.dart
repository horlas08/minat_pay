import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/widget/Button.dart';
import 'package:minat_pay/widget/app_header.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:show_confirm_modal/show_confirm_modal.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../bloc/repo/app/app_event.dart';
import '../../../bloc/repo/app/app_state.dart';
import '../../../config/app.config.dart';
import '../../../cubic/app_config_cubit.dart';
import '../../../helper/helper.dart';
import '../../../model/app.dart';

class AppSettings extends HookWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    const double space = 35;
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: const AppHeader(title: "App Settings"),
        body: SingleChildScrollView(
          child: BlocBuilder<AppConfigCubit, App>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                ),
                child: BlocBuilder<AppBloc, AppState>(
                  builder: (context, appState) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        if (!appState.user!.userType!)
                          Container(
                            height: 100,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              image: DecorationImage(
                                opacity: 0.3,
                                fit: BoxFit.cover,
                                image:
                                    AssetImage("assets/images/upgradeBg.jpg"),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Upgarde To Agent",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        "Unlock Exclusive Offer and Discount On All Our product",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                      AppColor.primaryColor,
                                    ),
                                    foregroundColor: WidgetStateProperty.all(
                                      Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    showUpgradeModal(context);
                                  },
                                  child: const Text("Upgrade Now"),
                                )
                              ],
                            ),
                          ),
                        if (!appState.user!.userType!)
                          const SizedBox(
                            height: 20,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person_off_outlined,
                                          ),
                                          Text(
                                            "Profile Settings",
                                            style: TextStyle(
                                              fontSize: 15,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.notifications,
                                          ),
                                          Text(
                                            "Enable Notification",
                                            style: TextStyle(
                                              fontSize: 15,
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
                                        if (value) {
                                          OneSignal.User.pushSubscription
                                              .optIn();
                                        } else {
                                          OneSignal.User.pushSubscription
                                              .optOut();
                                        }

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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.fingerprint,
                                          ),
                                          Text(
                                            "Enable Finger Print",
                                            style: TextStyle(
                                              fontSize: 15,
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
                                        print(value);
                                        context
                                            .read<AppConfigCubit>()
                                            .enableFingerPrint(value);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.devices_fold_outlined,
                                          ),
                                          Text(
                                            "Shake To Hide Balance",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ]),
                                    FlutterSwitch(
                                      width: 55.0,
                                      height: 30.0,
                                      valueFontSize: 15.0,
                                      toggleSize: 20.0,
                                      value: state.enableShakeToHideBalance,
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
                                      showOnOff: true,
                                      onToggle: (bool value) {
                                        context
                                            .read<AppConfigCubit>()
                                            .enableShakeToHideBalance(value);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          fontSize: 15,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          fontSize: 15,
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
                                  12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Text(
                                  "Delete Account",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
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
                                  onConfirm: () {
                                    handleDeleteAccount(context);
                                  },
                                  title: "Delete My Account",
                                  content:
                                      "Are you Sure You Want To Delete Your Account",
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: space,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ThemeSwitcher(
                                clipper: const ThemeSwitcherCircleClipper(),
                                builder: (context) {
                                  return BlocBuilder<AppConfigCubit, App>(
                                    builder: (context, state) {
                                      return InkWell(
                                        onTap: () {
                                          context
                                              .read<AppConfigCubit>()
                                              .changeAutoThemeMode(true);
                                          context.updateThemeMode(
                                            themeMode: ThemeMode.system,
                                            animateTransition: true,
                                            isReversed: WidgetsBinding
                                                    .instance
                                                    .platformDispatcher
                                                    .platformBrightness ==
                                                Brightness.light,
                                          );
                                          // context.toggleThemeMode(
                                          //   animateTransition: true,
                                          //   isReversed: state.themeMode == 'light',
                                          // );
                                          // context
                                          //     .read<AppConfigCubit>()
                                          //     .toggleThemeMode();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: WidgetsBinding
                                                          .instance
                                                          .platformDispatcher
                                                          .platformBrightness ==
                                                      Brightness.light
                                                  ? AppColor.darkBg
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          height: 40,
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const Icon(
                                                Icons.system_security_update,
                                              ),
                                              const Text(
                                                "System Mode",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (context
                                                  .read<AppConfigCubit>()
                                                  .state
                                                  .autoTheme)
                                                const Icon(
                                                  Icons.check,
                                                  color: AppColor.success,
                                                )
                                            ],
                                          ),
                                        ),
                                      );
                                      return InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          ThemeModelInheritedNotifier.of(
                                                          context)
                                                      .themeMode ==
                                                  ThemeMode.light
                                              ? Icons.brightness_2_outlined
                                              : Icons.sunny,
                                          // size: 35,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ThemeSwitcher(
                                clipper: const ThemeSwitcherCircleClipper(),
                                builder: (context) {
                                  return BlocBuilder<AppConfigCubit, App>(
                                    builder: (context, state) {
                                      return InkWell(
                                        onTap: () {
                                          context
                                              .read<AppConfigCubit>()
                                              .changeAutoThemeMode(false);
                                          context.toggleThemeMode(
                                            animateTransition: true,
                                            isReversed:
                                                state.themeMode == 'light',
                                          );
                                          context
                                              .read<AppConfigCubit>()
                                              .toggleThemeMode();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: ThemeModelInheritedNotifier
                                                              .of(context)
                                                          .themeMode ==
                                                      ThemeMode.light
                                                  ? AppColor.darkBg
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          height: 40,
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(
                                                ThemeModelInheritedNotifier.of(
                                                                context)
                                                            .themeMode ==
                                                        ThemeMode.light
                                                    ? Icons
                                                        .brightness_2_outlined
                                                    : Icons.sunny,
                                                // size: 35,
                                              ),
                                              Text(
                                                ThemeModelInheritedNotifier.of(
                                                                context)
                                                            .themeMode ==
                                                        ThemeMode.light
                                                    ? "Light Mode"
                                                    : "Dark Mode",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (!context
                                                  .read<AppConfigCubit>()
                                                  .state
                                                  .autoTheme)
                                                const Icon(
                                                  Icons.check,
                                                  color: AppColor.success,
                                                )
                                            ],
                                          ),
                                        ),
                                      );
                                      return InkWell(
                                        onTap: () {},
                                        child: Icon(
                                          ThemeModelInheritedNotifier.of(
                                                          context)
                                                      .themeMode ==
                                                  ThemeMode.light
                                              ? Icons.brightness_2_outlined
                                              : Icons.sunny,
                                          // size: 35,
                                        ),
                                      );
                                    },
                                  );
                                },
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
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  handleDeleteAccount(BuildContext context) async {
    context.loaderOverlay.show();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = await curlDeleteRequest(path: '/deleteuser', data: {
      'token': prefs.getString('token'),
    });

    if (res == null) {
      if (context.mounted) {
        context.pop();
        context.loaderOverlay.hide();
      }
      return await alertHelper(context, "error", "internet Connection");
    }
    if (res.statusCode == HttpStatus.ok) {
      if (context.mounted) {
        handleLogOut(context);
        return await alertHelper(context, "error", res.data['mwessage']);
      }
    } else {
      if (context.mounted) {
        context.loaderOverlay.hide();
        await alertHelper(context, 'error', res.data['error']);
      }
    }
  }

  void showUpgradeModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          // icon: Icon(Icons.add),
          title: const Text(
            "Upgrade Account",
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
              maxHeight: 130,
              minHeight: 100,
            ),
            child: Form(
                // key: _bvnKey,
                child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Upgrade To Agent And Enjoy Exclusive Benefits and Discounts on our services. You Will be charged NGN2000 to upgrade to Agent',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      handleUpgrade(context);
                    },
                    child: const Text(
                      'Pay And Upgrade Now',
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

  handleUpgrade(BuildContext context) async {
    context.loaderOverlay.show();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final resp = await curlPutRequest(
      path: upgradeToAgent,
      data: {
        'token': prefs.getString("token"),
      },
    );
    if (resp == null) {
      if (context.mounted) {
        context.pop();
        context.loaderOverlay.hide();
        await alertHelper(context, "error", "internet Connection");
      }
      return;
    }

    if (resp.statusCode == HttpStatus.ok) {
      final res = await refreshUSerDetail();
      if (res == null && context.mounted) {
        context.pop();
        context.loaderOverlay.hide();
        await alertHelper(
            context, "error", "Unable to Update Check Internet Connection");
        return;
      }

      if (res?.statusCode == HttpStatus.ok && context.mounted) {
        context
            .read<AppBloc>()
            .add(UpdateUserEvent(userData: res?.data['data']['user_data']));
        context.pop();
        context.loaderOverlay.hide();

        await alertHelper(context, "success", resp.data['message']);
        return;
      }
    } else {
      if (context.mounted) {
        context.loaderOverlay.hide();
        context.pop();
        await alertHelper(context, 'error', resp.data['message']);
        return;
      }
    }
  }
}
