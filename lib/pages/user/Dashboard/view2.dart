import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:minat_pay/config/app.config.dart';
import 'package:minat_pay/model/user.dart';
import 'package:minat_pay/widget/user/dashboard/quick_action.dart';
import 'package:minat_pay/widget/user/dashboard/transaction.dart';
// import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:widget_visibility_detector/widget_visibility_detector.dart';

import '../../../bloc/repo/app/app_bloc.dart';
import '../../../bloc/repo/app/app_event.dart';
import '../../../bloc/repo/app/app_state.dart';
import '../../../config/color.constant.dart';
import '../../../config/font.constant.dart';
import '../../../data/login_verify_2_service.dart';
import '../../../helper/helper.dart';
import '../../../helper/server.dart';
import '../../../main.dart';
import '../../../model/main_response.dart';
import '../../../widget/user/dashboard/balance_card.dart';
import '../../../widget/user/dashboard/header.dart';

Key _refreshKey = UniqueKey();

class Dashboard extends HookWidget {
  const Dashboard({super.key});

  Future showPinModal(BuildContext context, AppState state) {
    Size size = MediaQuery.of(context).size;
    PinInputController pinInputController = PinInputController(length: 4);

    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        isScrollControlled: true,
        useRootNavigator: true,
        showDragHandle: true,
        builder: (builder) {
          return Wrap(
            children: [
              const Center(
                child: Text(
                  "Create Transaction Pin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.aeonik,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Center(
                child: PinPlusKeyBoardPackage(
                  keyboardButtonShape: KeyboardButtonShape.rounded,
                  inputShape: InputShape.circular,
                  keyboardMaxWidth: 80,
                  btnHasBorder: false,
                  inputHasBorder: false,
                  inputFillColor: Colors.grey,
                  inputElevation: 3,
                  buttonFillColor: AppColor.primaryColor,
                  btnTextColor: Colors.white,
                  spacing: size.height * 0.06,
                  pinInputController: pinInputController,
                  onSubmit: () async {
                    context.pop();
                    return await showPinModalConfirm(
                        context, pinInputController, state);

                    // print("Text is : " + pinInputController.text);
                  },
                  keyboardFontFamily: AppFont.aeonik,
                ),
              ),
            ],
          );
        });
  }

  Future showPinModalConfirm(BuildContext context,
      PinInputController pinInputController, AppState state) {
    Size size = MediaQuery.of(context).size;

    PinInputController pinInputConfirmController =
        PinInputController(length: 4);

    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: true,
        isScrollControlled: true,
        useRootNavigator: true,
        showDragHandle: true,
        builder: (builder) {
          return Wrap(
            children: [
              const Center(
                child: Text(
                  "Confirm Transaction Pin",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.aeonik,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              PinPlusKeyBoardPackage(
                keyboardButtonShape: KeyboardButtonShape.rounded,
                inputShape: InputShape.circular,
                keyboardMaxWidth: 80,
                btnHasBorder: false,
                inputHasBorder: false,
                inputFillColor: Colors.grey,
                inputElevation: 3,
                buttonFillColor: AppColor.primaryColor,
                btnTextColor: Colors.white,
                spacing: size.height * 0.06,
                pinInputController: pinInputConfirmController,
                onSubmit: () async {
                  if (pinInputController.text !=
                      pinInputConfirmController.text) {
                    context.pop();
                    await alertHelper(context, 'error', "Pin Not Match");
                    if (context.mounted) {
                      return showPinModal(context, state);
                    }
                  }

                  if (context.mounted) {
                    context.loaderOverlay.show();
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final res = await curlPostRequest(
                      path: setPin,
                      data: {
                        'token': prefs.getString('token'),
                        'pin': pinInputController.text,
                        'confirm_pin': pinInputConfirmController.text,
                      },
                    );
                    // print(res?.data);
                    if (context.mounted && res?.statusCode == HttpStatus.ok) {
                      if (context.mounted) {
                        print(state.user!.hasPin);
                        final User? user = state.user?.copyWith(hasPin: true);
                        print(user);

                        context.read<AppBloc>().add(
                              AddUserEvent(
                                userData: user!.toMap(),
                              ),
                            );
                        print(state.user!.hasPin);

                        //
                        if (user != null) {
                          print(user.toMap());
                          context.read<AppBloc>().add(
                                AddUserEvent(
                                  userData: user.toMap(),
                                ),
                              );
                        }
                        context.loaderOverlay.hide();
                        if (context.canPop()) {
                          context.pop();
                          return await alertHelper(
                              context, "success", res?.data['message']);
                        }
                      } else {
                        if (context.mounted) context.loaderOverlay.hide();
                      }
                    }
                  }
                },
                keyboardFontFamily: AppFont.aeonik,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    AsyncMemoizer<MainResponse> mainMemoizer = AsyncMemoizer<MainResponse>();
    final retry = useState('');
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    void _onRefresh(BuildContext context) async {
      _refreshController.requestLoading();

      final res = await LoginVerifyWithOutPasswordService().request();
      if (res?.statusCode == HttpStatus.ok) {
        final accounts = (res?.data['data']['accounts'] as List)
            .map((itemWord) => itemWord as Map<String, dynamic>)
            .toList();

        final userData = res?.data['data']['user_data'];
        if (context.mounted) {
          context.read<AppBloc>().add(UpdateUserEvent(userData: userData));
          context.read<AppBloc>().add(AddAccountEvent(accounts: accounts));
        }
        _refreshController.refreshCompleted();
      } else {
        _refreshController.refreshFailed();
      }
    }

    useEffect(() {
      OneSignal.Debug.setLogLevel(
        OSLogLevel.verbose,
      );

      OneSignal.initialize("1bdf1b9f-7769-4f40-b73e-5d6e25107219");
      final user = context.read<AppBloc>().state.user;
      if (user != null) {
        OneSignal.login(user.id.toString()).then(
          (_) async {
            final String? oneSignalId = await OneSignal.User.getOnesignalId();

            if (oneSignalId != null) {
              final res = await curlPostRequest(path: storeDeviceToken, data: {
                'device_token': oneSignalId,
                'user_id': user.id,
              });
              print(res);
            } else {
              print('shit am null');
            }
          },
        );
      } else {
        print("user is null right now");
      }

      return null;
    }, []);

    showNotificationModal(
      BuildContext context,
    ) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'close',
        pageBuilder: (context, animation, secondaryAnimation) {
          return AlertDialog(
            // icon: Icon(Icons.add),
            title: Text(
              appServer.serverResponse.appconfiguration!.notificationTitle!,
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
                maxHeight: 150,
                minHeight: 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appServer
                      .serverResponse.appconfiguration!.notificationMessage!)
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      extendBody: true,
      body: FutureBuilder(
        key: _refreshKey,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // OneSignal.initialize(
            //     appServer.serverResponse.onesignalConfiguration!.appId!);
            return SmartRefresher(
              controller: _refreshController,
              header: const WaterDropHeader(),
              onRefresh: () => _onRefresh(context),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            const UserHeader(),
                            const SizedBox(
                              height: 30,
                            ),
                            if (appServer.serverResponse.appconfiguration!
                                    .notificationEnable! ==
                                'true')
                              TouchableOpacity(
                                onTap: () {
                                  showNotificationModal(
                                    context,
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle_notifications_outlined,
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: TextScroll(
                                          appServer
                                              .serverResponse
                                              .appconfiguration!
                                              .notificationMessage!,
                                          velocity: Velocity(
                                              pixelsPerSecond: Offset(50, 0)),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            const BalanceCard(),
                            const SizedBox(
                              height: 30,
                            ),
                            BlocListener<AppBloc, AppState>(
                              listener: (context, state) {
                                if (state.user!.hasPin == false) {
                                  final newUser =
                                      state.user!.copyWith(hasPin: true);
                                  print(newUser);
                                }
                              },
                              child: BlocBuilder<AppBloc, AppState>(
                                builder: (context, state) {
                                  return WidgetVisibilityDetector(
                                    onAppear: () {
                                      print(state.user!.hasPin);
                                      final newUser =
                                          state.user!.copyWith(hasPin: true);

                                      Future.delayed(
                                        Duration.zero,
                                        () {
                                          if (context.mounted &&
                                              state.user!.hasPin! == false) {
                                            showPinModal(context, state);
                                          }
                                        },
                                      );
                                    },
                                    onDisappear: () {
                                      print("do");
                                    },
                                    child: const QuickAction(),
                                  );
                                },
                              ),
                            ),
                            const Transaction(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Error From Server",
                  style: TextStyle(fontSize: 25),
                ),
                IconButton(
                  onPressed: () {
                    retry.value =
                        DateTime.now().microsecondsSinceEpoch.toString();
                    return;
                    // GoRouter.of(context).refresh();
                  },
                  icon: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Retry Again Later'),
                      Icon(Icons.refresh_outlined),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: mainMemoizer.runOnce(() => fetchData()),
      ),
    );
  }
}
