class App {
  bool authState = false;
  bool pinState = false;
  bool enableFingerPrint;
  bool enableNotification;
  bool enableShakeToHideBalance;
  String themeMode = 'light';
  bool autoTheme = false;
  App({
    required this.authState,
    required this.pinState,
    required this.themeMode,
    required this.enableFingerPrint,
    required this.enableNotification,
    required this.enableShakeToHideBalance,
    required this.autoTheme,
  });

  App copyWith({
    bool? authState,
    bool? pinState,
    bool? enableFingerPrint,
    bool? enableNotification,
    bool? enableShakeToHideBalance,
    String? themeMode,
    bool? autoTheme,
  }) {
    return App(
      authState: authState ?? this.authState,
      pinState: pinState ?? this.pinState,
      enableFingerPrint: enableFingerPrint ?? this.enableFingerPrint,
      enableNotification: enableNotification ?? this.enableNotification,
      enableShakeToHideBalance:
          enableShakeToHideBalance ?? this.enableShakeToHideBalance,
      themeMode: themeMode ?? this.themeMode,
      autoTheme: autoTheme ?? this.autoTheme,
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
      enableShakeToHideBalance: json['enableShakeToHideBalance'],
      themeMode: json['themeMode'],
      autoTheme: json['autoTheme'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authState': authState,
      'themeMode': themeMode,
      'enableNotification': enableNotification,
      'enableFingerPrint': enableFingerPrint,
      'enableShakeToHideBalance': enableShakeToHideBalance,
      'autoTheme': autoTheme,
    };
  }
}
