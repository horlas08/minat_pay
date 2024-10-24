import 'dart:ui';

import 'package:minat_pay/config/color.constant.dart';
import 'package:mobx/mobx.dart';

import '../model/main_response.dart';

part 'app_server.g.dart';

class AppServer = AppServerBase with _$AppServer;

abstract class AppServerBase with Store {
  @observable
  Color primaryColor = AppColor.primaryColor;
  @observable
  MainResponse serverResponse = MainResponse();

  @action
  void changePrimaryColor(Color color) {
    primaryColor = color;
  }

  @action
  void saveServerResponse(Map<String, dynamic> json) {
    serverResponse = MainResponse.fromJson(json);
  }
}

// Singleton instance of ThemeStore
final AppServer themeStore = AppServer();
