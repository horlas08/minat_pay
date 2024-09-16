import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
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

String currency(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  var format =
      NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
  return format.currencySymbol;
}

Future appModalWithoutRoot(context,
    {String? title, Widget? child, bool? isDismissible = true}) {
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

Future showConfirmPinRequest(BuildContext context, {Function? callback}) {
  Size size = MediaQuery.of(context).size;
  PinInputController pinInputController = PinInputController(length: 4);

  // final ValueNotifier<bool> valid = useState(false);

  return showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (builder) {
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
                buttonFillColor: AppColor.primaryColor,
                btnTextColor: Colors.white,
                spacing: size.height * 0.06,
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
                      Future.delayed(
                        Duration.zero,
                        () async {
                          await alertHelper(
                              context, 'error', res?.data['message']);
                        },
                      );
                      context.read<AppConfigCubit>().comfirmPinState(false);
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

Future<void> handleLogOut(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  context.loaderOverlay.show();
  final res = await curlPostRequest(path: "/logout", data: {
    'token': prefs.getString("token"),
  });
  if (context.mounted) {
    if (res?.statusCode == 200) {
      prefs.clear();
      HydratedBloc.storage.clear();
      if (context.mounted) {
        while (context.canPop() == true) {
          context.pop();
        }
        context.go('/login');
        context.loaderOverlay.hide();
      }
    } else {
      context.loaderOverlay.hide();
      return await alertHelper(context, "error", res?.data['message']);
    }
  }
}
