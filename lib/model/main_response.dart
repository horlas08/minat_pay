class MainResponse {
  Appconfiguration? appconfiguration;
  Theme? theme;
  Contact? contact;
  OnesignalConfiguration? onesignalConfiguration;
  ExitpopupConfiguration? exitpopupConfiguration;

  MainResponse(
      {this.appconfiguration,
      this.theme,
      this.contact,
      this.onesignalConfiguration,
      this.exitpopupConfiguration});

  MainResponse.fromJson(Map<String, dynamic> json) {
    appconfiguration = json['appconfiguration'] != null
        ? new Appconfiguration.fromJson(json['appconfiguration'])
        : null;

    theme = json['theme'] != null ? new Theme.fromJson(json['theme']) : null;
    contact =
        json['contact'] != null ? new Contact.fromJson(json['contact']) : null;
    onesignalConfiguration = json['onesignal_configuration'] != null
        ? new OnesignalConfiguration.fromJson(json['onesignal_configuration'])
        : null;
    exitpopupConfiguration = json['exitpopup_configuration'] != null
        ? new ExitpopupConfiguration.fromJson(json['exitpopup_configuration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appconfiguration != null) {
      data['appconfiguration'] = this.appconfiguration!.toJson();
    }

    if (this.theme != null) {
      data['theme'] = this.theme!.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact!.toJson();
    }
    if (this.onesignalConfiguration != null) {
      data['onesignal_configuration'] = this.onesignalConfiguration!.toJson();
    }
    if (this.exitpopupConfiguration != null) {
      data['exitpopup_configuration'] = this.exitpopupConfiguration!.toJson();
    }
    return data;
  }
}

class Appconfiguration {
  String? notificationEnable;
  String? notificationMessage;
  String? notificationTitle;
  String? isExitPopupScreen;
  String? pcallback;
  String? psecret;

  Appconfiguration({
    this.notificationEnable,
    this.notificationMessage,
    this.notificationTitle,
    this.isExitPopupScreen,
    this.pcallback,
    this.psecret,
  });

  Appconfiguration.fromJson(Map<String, dynamic> json) {
    notificationEnable = json['notificationEnable'];
    notificationMessage = json['notification_message'];
    notificationTitle = json['notification_title'];
    isExitPopupScreen = json['isExitPopupScreen'];
    pcallback = json['pcallback'];
    psecret = json['psecret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationEnable'] = this.notificationEnable;
    data['notification_message'] = this.notificationMessage;
    data['notification_title'] = this.notificationTitle;
    data['isExitPopupScreen'] = this.isExitPopupScreen;
    data['pcallback'] = this.pcallback;
    data['psecret'] = this.psecret;
    return data;
  }
}

class Theme {
  String? themeStyle;
  String? customColor;

  Theme({
    this.themeStyle,
    this.customColor,
  });

  Theme.fromJson(Map<String, dynamic> json) {
    themeStyle = json['themeStyle'];
    customColor = json['customColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['themeStyle'] = this.themeStyle;
    data['customColor'] = this.customColor;

    return data;
  }
}

class Contact {
  String? call;
  String? email;
  String? whatsapp;

  Contact({this.call, this.email, this.whatsapp});

  Contact.fromJson(Map<String, dynamic> json) {
    call = json['call'];
    email = json['email'];
    whatsapp = json['whatsapp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['call'] = this.call;
    data['email'] = this.email;
    data['whatsapp'] = this.whatsapp;
    return data;
  }
}

class OnesignalConfiguration {
  String? appId;
  String? restApiKey;

  OnesignalConfiguration({this.appId, this.restApiKey});

  OnesignalConfiguration.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    restApiKey = json['rest_api_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['rest_api_key'] = this.restApiKey;
    return data;
  }
}

class ExitpopupConfiguration {
  String? title;
  String? positiveText;
  String? negativeText;
  String? enableImage;
  String? exitImageUrl;

  ExitpopupConfiguration(
      {this.title,
      this.positiveText,
      this.negativeText,
      this.enableImage,
      this.exitImageUrl});

  ExitpopupConfiguration.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    positiveText = json['positive_text'];
    negativeText = json['negative_text'];
    enableImage = json['enable_image'];
    exitImageUrl = json['exit_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['positive_text'] = this.positiveText;
    data['negative_text'] = this.negativeText;
    data['enable_image'] = this.enableImage;
    data['exit_image_url'] = this.exitImageUrl;
    return data;
  }
}
