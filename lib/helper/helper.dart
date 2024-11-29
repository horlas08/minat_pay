import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:lottie/lottie.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:minat_pay/cubic/app_config_cubit.dart';
import 'package:minat_pay/model/providers.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../config/app.config.dart';
import '../config/font.constant.dart';
import '../data/user/pin_verify_service.dart';
import '../data/user/transaction_service.dart';
import '../main.dart';
import '../pages/auth/Login/login_verify_view.dart';
import '../service/http.dart';
import '../widget/Button.dart';

String _handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return "Timeout occurred while sending or receiving";
    // case DioExceptionType.badResponse:
    //   final statusCode = error.response?.statusCode;
    //   if (statusCode != null) {
    //     switch (statusCode) {
    //       case StatusCode.badRequest:
    //         return "Bad Request";
    //       case StatusCode.unauthorized:
    //       case StatusCode.forbidden:
    //         return "Unauthorized";
    //       case StatusCode.notFound:
    //         return "Not Found";
    //       case StatusCode.conflict:
    //         return 'Conflict';
    //
    //       case StatusCode.internalServerError:
    //         return "Internal Server Error";
    //     }
    //   }
    //   break;
    case DioExceptionType.cancel:
      break;
    case DioExceptionType.unknown:
      return "No Internet Connection";
    case DioExceptionType.badCertificate:
      return "Internal Server Error";
    case DioExceptionType.connectionError:
      return "Connection Error";
    default:
      return "Unknown Error";
  }
  return "Unknown Error";
}

extension PasswordValidationBuilder on ValidationBuilder {
  password() => add((value) {
        if (value == 'password') {
          return 'Password should not "password"';
        }
        return null;
      });
  matches(String n) => add((value) {
        if (value != n) {
          return 'Password Not Match';
        }
        return null;
      });
  minNumber(double min) => add((value) {
        if (double.parse(value!) < min) {
          return 'Minimum Value is $min';
        }
        return null;
      });
  max(double max) => add((value) {
        if (double.parse(value!) > max) {
          return 'Maximum Value is $max';
        }
        return null;
      });
}

extension BalanceValidationBuilder on ValidationBuilder {
  checkBalance(double max) => add((value) {
        if (double.parse(value!) > max) {
          return 'Insufficient Balance $max';
        }
        return null;
      });
}

extension GoRouterExtention on GoRouter {
  void clearAllRouteAndNavigate(String location) {
    while (canPop()) {
      pop();
    }
    pushReplacement(location);
  }
}

Future<Response?> curlGetRequest(
    {required String path,
    Object? data,
    Map<String, dynamic>? queryParams,
    Options? options}) async {
  try {
    Response res = await dio.get(path,
        data: data, queryParameters: queryParams, options: options);
    return res;
  } on DioException catch (error) {
    return error.response;
  }
}

Future<Response?> curl2GetRequest(
    {required String path,
    Object? data,
    Map<String, dynamic>? queryParams,
    Options? options}) async {
  try {
    Response res = await dio2.get(path,
        data: data, queryParameters: queryParams, options: options);
    return res;
  } on DioException catch (error) {
    print(error);
    return error.response;
  }
}

Future<Response?> curlPostRequest(
    {required String path,
    Object? data,
    Map<String, dynamic>? queryParams,
    Options? options}) async {
  try {
    Response res = await dio.post(path,
        data: data, queryParameters: queryParams, options: options);
    return res;
  } on DioException catch (error) {
    print("error enter");
    print(error);
    return error.response;
  }
}

Future<Response?> curlPutRequest(
    {required String path,
    Object? data,
    Map<String, dynamic>? queryParams,
    Options? options}) async {
  try {
    Response res = await dio.put(path,
        data: data, queryParameters: queryParams, options: options);
    return res;
  } on DioException catch (error) {
    return error.response;
  }
}

Future<Response?> curlDeleteRequest(
    {required String path,
    Object? data,
    Map<String, dynamic>? queryParams,
    Options? options}) async {
  try {
    Response res = await dio.delete(path,
        data: data, queryParameters: queryParams, options: options);
    return res;
  } on DioException catch (error) {
    return error.response;
  }
}

Future<Response?> curl2PostRequest(
    {required String path,
    Object? data,
    Map<String, dynamic>? queryParams,
    Options? options}) async {
  try {
    Response res = await dio2.post(path,
        data: data, queryParameters: queryParams, options: options);
    return res;
  } on DioException catch (error) {
    return error.response;
  }
}

alertHelper(BuildContext context, String type, String message,
    {int duration = 4}) async {
  return await Flushbar(
    title: type == 'error' ? 'Oops Error' : 'Success',
    message: message,
    backgroundColor: type == 'error' ? AppColor.danger : AppColor.success,
    duration: Duration(seconds: duration),
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}

void showAppDialog(
  BuildContext context, {
  double height = 220,
  bool useRootNavigator = false,
  required Widget child,
  EdgeInsetsGeometry? margin = const EdgeInsets.symmetric(horizontal: 20),
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "true",
    useRootNavigator: useRootNavigator,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: height,
          margin: margin,
          child: SizedBox.expand(
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: child,
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<double> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: 0, end: 1);
      } else {
        tween = Tween(begin: 0, end: 1);
      }

      return ScaleTransition(
        scale: tween.animate(anim),
        // position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

String currency(BuildContext context) {
  // Locale locale = Localizations.localeOf(context);
  var format =
      NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
  return format.currencySymbol;
}

Future appModalWithoutRoot(context,
    {String? title, Widget? child, bool? isDismissible = true}) async {
  return showModalBottomSheet(
      context: context,
      isDismissible: isDismissible ?? true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (builder) {
        return Wrap(
          children: [
            if (title != null)
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.aeonik,
                    fontSize: 25,
                  ),
                ),
              ),
            const SizedBox(
              height: 60,
            ),
            if (child != null) child,
          ],
        );
      });
}

String getEmailMask(String text) {
  return '${text.substring(0, 4)}******${text.substring(text.length - 9, text.length)}';
}

Widget successModalWidget(BuildContext context, {required String message}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    child: Column(
      children: [
        SizedBox(
          height: 200,
          child: Lottie.asset('assets/lottie/success.json'),
        ),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Button(
          onpressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text(
            "Continue",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        TextButton(
          onPressed: () async {
            final id = await getLastTransactionId();
            if (context.mounted) {
              context
                  .pushNamed('transactionDetails', pathParameters: {'id': id!});
            }
          },
          child: const Text(
            'View Receipt',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        )
      ],
    ),
  );
}

Future<Response?> confirmTransactionPinRequest({required String pin}) async {
  final pinVerifyRequest = PinVerifyService(pin: pin);

  final Response? res = await pinVerifyRequest.request();
  return res;
}

_fingerPrintShow(BuildContext context) async {
  try {
    return await auth.authenticate(
      localizedReason: 'Please authenticate access your account',
      options: const AuthenticationOptions(
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: true,
        sensitiveTransaction: true,
      ),
      authMessages: const <AuthMessages>[
        AndroidAuthMessages(
          signInTitle: 'Oops! Biometric authentication required!',
          cancelButton: 'No thanks',
        ),
        IOSAuthMessages(
          cancelButton: 'No thanks',
        ),
      ],
    );

    // ···
  } on PlatformException catch (error) {
    if (context.mounted) {
      await alertHelper(context, 'error', error.toString());
    }
  }
}

Future showConfirmPinRequest(BuildContext context, {Function? callback}) async {
  Size size = MediaQuery.of(context).size;
  PinInputController pinInputController = PinInputController(length: 4);
  context.read<AppConfigCubit>().comfirmPinState(false);
  final showBiometric = await canAuth();
  final availableBiometric = await availableBiometrics();
  final deviceSupportBio = showBiometric &&
          availableBiometric.isNotEmpty &&
          (availableBiometric.contains(BiometricType.face) ||
              availableBiometric.contains(BiometricType.strong)) ||
      (availableBiometric.contains(BiometricType.weak) ||
          availableBiometric.contains(BiometricType.fingerprint));
  if (!context.mounted) return;
  return showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (context) {
        return Wrap(
          children: [
            const Center(
              child: Text(
                "Enter Transaction Pin",
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
                buttonFillColor: appServer.primaryColor,
                btnTextColor: Colors.white,
                spacing: size.height * 0.06,
                leftExtraInputWidget:
                    context.read<AppConfigCubit>().state.enableFingerPrint &&
                            deviceSupportBio
                        ? Expanded(
                            child: IconButton(
                              onPressed: () async {
                                final didAuth = await _fingerPrintShow(context);
                                if (context.mounted) {
                                  if (didAuth) {
                                    if (Navigator.maybeOf(context) != null) {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(context);
                                    }
                                    context
                                        .read<AppConfigCubit>()
                                        .comfirmPinState(true);
                                  } else {
                                    context
                                        .read<AppConfigCubit>()
                                        .comfirmPinState(false);
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.fingerprint,
                                color: AppColor.primaryColor,
                                size: 25,
                              ),
                            ),
                          )
                        : null,
                pinInputController: pinInputController,
                onSubmit: () async {
                  context.loaderOverlay.show();
                  final res = await confirmTransactionPinRequest(
                      pin: pinInputController.text);
                  print(res);
                  if (res == null && context.mounted) {
                    context.loaderOverlay.hide();
                    if (Navigator.maybeOf(context) != null) {
                      Navigator.of(context, rootNavigator: true).pop(context);
                    }
                    return alertHelper(
                        context, "error", "Check Your Internet Connection");
                  }
                  if (context.mounted) {
                    context.loaderOverlay.hide();
                    if (Navigator.maybeOf(context) != null) {
                      Navigator.of(context, rootNavigator: true).pop(context);
                    }
                    if (res?.statusCode == HttpStatus.ok) {
                      return context
                          .read<AppConfigCubit>()
                          .comfirmPinState(true);
                      // Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      context.read<AppConfigCubit>().comfirmPinState(false);
                      Future.delayed(
                        Duration.zero,
                        () async {
                          if (context.mounted) {
                            return await alertHelper(
                                context, 'error', res?.data['message']);
                          }
                        },
                      );
                      return;
                    }
                  }

                  // print("Text is : " + pinInputController.text);
                },
                keyboardFontFamily: AppFont.aeonik,
              ),
            ),
          ],
        );
      });
}

String generateTrx() {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return '${List.generate(r.nextInt(30), (index) => _chars[r.nextInt(_chars.length)]).join()}${DateTime.now().microsecondsSinceEpoch}';
}

String getNetworkById(String network) {
  if (network.toLowerCase() == 'mtn') {
    return '1';
  } else if (network.toLowerCase() == 'glo') {
    return '2';
  } else if (network.toLowerCase() == 'airtel') {
    return '3';
  }
  return '4';
}

showProviderPicker(BuildContext context, List<Providers> providers,
    ValueNotifier<Providers> selectedProvider) {
  showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (builder) {
        return Container(
          constraints: const BoxConstraints(
            minWidth: double.maxFinite,
            minHeight: 200,
            maxHeight: 430,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Wrap(
                children: [
                  const Text(
                    "Select Providers",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFont.aeonik,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Column(
                    children: [
                      ...providers.map(
                        (provider) {
                          return SizedBox(
                            height: 50,
                            child: TouchableOpacity(
                              activeOpacity: 0.3,
                              onTap: () {
                                selectedProvider.value = provider;

                                print(provider.toString());
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: provider.image!,
                                    width: 25,
                                    height: 30,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      provider.name!,
                                      style: const TextStyle(fontSize: 20),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                  const Spacer(),
                                  provider.id == selectedProvider.value.id &&
                                          selectedProvider.value.id != null
                                      ? const Icon(
                                          Icons.check_circle,
                                        )
                                      : const Icon(
                                          Icons.circle_outlined,
                                        )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

showProviderLoading(
  BuildContext context,
) {
  showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (builder) {
        return Container(
          constraints:
              const BoxConstraints(minWidth: double.maxFinite, minHeight: 200),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0),
            child: Wrap(
              children: [
                Text(
                  "Select Providers",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFont.aeonik,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                Center(child: CircularProgressIndicator()),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      });
}

Future<Response?> getTransaction({int? limit}) async {
  final transactionRequest = TransactionService(limit: limit);

  final Response? res = await transactionRequest.request();
  return res;
}

Future<String?> getLastTransactionId() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("lastTrxId");
}

Future<Future<bool>> putLastTransactionId(String id) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.setString("lastTrxId", id);
}

Future<Response?> refreshUSerDetail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final res = await curlGetRequest(path: getUserDetails, data: {
    'token': prefs.getString('token'),
  });

  return res;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

Future<void> deleteFile(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    // Error in getting access to the file.
  }
}

final formatCurrency = new NumberFormat.simpleCurrency();
Widget RowList(
    {required String key,
    required String value,
    bool showLine = true,
    Widget? suffixIcon}) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            key.capitalize(),
            style: TextStyle(
              fontFamily: AppFont.aeonik,
              color: Colors.black.withOpacity(0.6),
              fontWeight: FontWeight.w100,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AutoSizeText(
                  "${value.toLowerCase().contains('amount') ? "₦" : ""}${value.capitalize()}",
                  style: TextStyle(
                    fontFamily: AppFont.mulish,
                    color: key == 'status'
                        ? value == 'successful'
                            ? AppColor.success
                            : AppColor.danger
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                ),
                if (suffixIcon != null) suffixIcon
              ],
            ),
          ),
        ],
      ),
      if (showLine)
        const SizedBox(
          height: 5,
        ),
      if (showLine) const Divider(),
      SizedBox(
        height: 15,
      )
    ],
  );
}

Future<void> handleLogOut(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.clear();
  if (context.mounted) {
    context.read<AppConfigCubit>().changeAuthState(false);

    if (!context.read<AppConfigCubit>().state.onboardSkip) {
      prefs.setBool('onboardSkip', true);
      context.read<AppConfigCubit>().changeOnboardStatus(true);
    }

    context.go('/login');
    return;
  }
  return;
  // print(GoRouterState.of(context).fullPath);
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // if (!context.mounted) return;
  // String? username = prefs.getString("userName");
  //
  // context.loaderOverlay.show();
  // final res = await curlPostRequest(path: "/logout", data: {
  //   'token': prefs.getString("token"),
  // });
  // if (context.mounted) {
  //   if (res?.statusCode == 200) {
  //     await prefs.clear();
  //     if (context.mounted) {
  //       context.read<AppConfigCubit>().changeAuthState(false);
  //
  //       if (!context.read<AppConfigCubit>().state.onboardSkip) {
  //         prefs.setBool('onboardSkip', true);
  //         context.read<AppConfigCubit>().changeOnboardStatus(true);
  //       }
  //
  //       context.go('/login');
  //       context.loaderOverlay.hide();
  //       return;
  //     }
  //   } else {
  //     context.loaderOverlay.hide();
  //     return await alertHelper(context, "error", res?.data['message']);
  //   }
  // }
}

bool isLight(BuildContext context) {
  if (context.watch<AppConfigCubit>().state.autoTheme) {
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.light;
  }
  // if (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
  //     Brightness.light) {}
  // if (Theme.of(context).brightness == Brightness.light) {}
  if (context.watch<AppConfigCubit>().state.themeMode == 'light') {
    return true;
  }
  return false;
}
