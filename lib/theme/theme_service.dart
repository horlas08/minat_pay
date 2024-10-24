import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:minat_pay/main.dart';
import 'package:minat_pay/theme/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  ThemeService._();
  static late SharedPreferences prefs;
  static ThemeService? _instance;

  static Future<ThemeService> get instance async {
    if (_instance == null) {
      prefs = await SharedPreferences.getInstance();
      _instance = ThemeService._();
    }
    return _instance!;
  }

  final allThemes = <String, ThemeData>{
    'dark': darkTheme(appServer),
    'light': lightTheme(appServer),
  };

  String get previousThemeName {
    String? themeName = prefs.getString('previousThemeName');
    if (themeName == null) {
      themeName = 'light';
      // final isPlatformDark =
      //     WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      // themeName = isPlatformDark ? 'light' : 'dark';
    }
    return themeName;
  }

  get initial {
    String? themeName = prefs.getString('theme');
    final themeMode = getThemeMode();

    return ThemeModel(
      themeMode: themeMode,
      lightTheme: allThemes['light']!,
      darkTheme: allThemes['dark']!,
    );

    return allThemes[themeName];
  }

  ThemeMode getThemeMode() {
    final index = prefs.getInt('themeMode');
    return ThemeMode.values[index ?? 0];
  }

  save(String newThemeName) {
    var currentThemeName = prefs.getString('theme');
    if (currentThemeName != null) {
      prefs.setString('previousThemeName', currentThemeName);
    }
    prefs.setString('theme', newThemeName);
  }

  ThemeData getByName(String name) {
    return allThemes[name]!;
  }
}
