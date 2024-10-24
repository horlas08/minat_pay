// import 'package:nb_utils/nb_utils.dart';
//
// Future<void> initialize() async {
//   sharedPreferences = await SharedPreferences.getInstance();
// }

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:minat_pay/config/color.constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

bool mConfirmationDialog(
  Function onTap,
  BuildContext context,
) {
  showConfirmDialogCustom(context,
      dialogType: DialogType.CONFIRMATION,
      primaryColor: AppColor.primaryColor,
      negativeText:
          appServer.serverResponse.exitpopupConfiguration!.negativeText!,
      positiveText:
          appServer.serverResponse.exitpopupConfiguration!.positiveText!,
      customCenterWidget:
          appServer.serverResponse.exitpopupConfiguration!.enableImage == "true"
              ? CachedNetworkImage(
                  imageUrl: appServer
                      .serverResponse.exitpopupConfiguration!.exitImageUrl!,
                  width: 70,
                  height: 70,
                ).paddingOnly(top: 16)
              : SizedBox(),
      title: appServer.serverResponse.exitpopupConfiguration!.title,
      onAccept: (c) {
    exit(0);
  });
  return true;
}

String getStringAsyncHelper(String key, {String defaultValue = ''}) {
  return getStringAsync(key, defaultValue: defaultValue);
}

Future<bool> exitConfirmation(BuildContext context) async {
  if (appServer.serverResponse.appconfiguration?.isExitPopupScreen == "true") {
    return mConfirmationDialog(() {
      context.pop();
    }, context);
  } else {
    return true;
    // exit(0);
  }
}

Future<bool> exitApp(BuildContext context) async {
  if (appServer.serverResponse.appconfiguration!.isExitPopupScreen == "true") {
    return mConfirmationDialog(() {
      context.pop();
    }, context);
  } else {
    exit(0);
  }
}
