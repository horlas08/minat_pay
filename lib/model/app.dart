class App {
  bool authState = false;
  String themeMode = 'light';
  App({required this.authState, required this.themeMode});

  App copyWith({
    bool? authState,
    String? themeMode,
  }) {
    return App(
      authState: authState ?? this.authState,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  String toString() {
    return 'App{authState: $authState, themeMode: $themeMode}';
  }

  factory App.fromJson(Map<String, dynamic> json) {
    return App(authState: json['authState'], themeMode: json['themeMode']);
  }

  Map<String, dynamic> toJson() {
    return {'authState': authState, 'themeMode': themeMode};
  }
}
