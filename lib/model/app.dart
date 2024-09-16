class App {
  bool authState = false;
  bool pinState = false;
  bool enableFingerPrint = true;
  bool enableNotification = true;
  String themeMode = 'light';
  App({
    required this.authState,
    required this.pinState,
    required this.themeMode,
    required this.enableFingerPrint,
    required this.enableNotification,
  });

  App copyWith({
    bool? authState,
    bool? pinState,
    bool? enableFingerPrint,
    bool? enableNotification,
    String? themeMode,
  }) {
    return App(
      authState: authState ?? this.authState,
      pinState: pinState ?? this.pinState,
      enableFingerPrint: enableFingerPrint ?? this.enableFingerPrint,
      enableNotification: enableNotification ?? this.enableNotification,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  String toString() {
    return 'App{authState: $authState, themeMode: $themeMode, enableNotification: $enableNotification,enableFingerPrint: $enableFingerPrint,}';
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      authState: json['authState'],
      pinState: json['pinState'],
      enableNotification: json['enableNotification'],
      enableFingerPrint: json['enableFingerPrint'],
      themeMode: json['themeMode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authState': authState,
      'themeMode': themeMode,
      'enableNotification': enableNotification,
      'enableFingerPrint': enableFingerPrint,
    };
  }
}
