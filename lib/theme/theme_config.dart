import 'package:flutter/material.dart';

import '../config/color.constant.dart';
import '../config/font.constant.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primaryColor).copyWith(
      primary: AppColor.primaryColor, secondary: AppColor.secondaryColor),
  useMaterial3: true,
  fontFamily: AppFont.aeonik,
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 40),
    titleMedium: TextStyle(
      fontSize: 25,
    ),
    bodyLarge: TextStyle(
        fontSize: 22, fontWeight: FontWeight.w900, fontFamily: AppFont.mulish),
    titleSmall: TextStyle(
      fontSize: 15,
    ),
    labelSmall: TextStyle(color: AppColor.greyColor),
  ),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
    fillColor: AppColor.greyLightColor.withOpacity(0.1),
    filled: true,
    errorMaxLines: 2,
    errorStyle: const TextStyle(
      color: AppColor.danger,
      fontSize: 12,
      fontFamily: AppFont.mulish,
      fontWeight: FontWeight.bold,
    ),

    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    // contentPadding: EdgeInsets.all(8),
    hintStyle: const TextStyle(
      color: AppColor.primaryColor,
      fontFamily: AppFont.mulish,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    titleTextStyle: TextStyle(color: Colors.black),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(AppColor.primaryColor),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  ),
);

ThemeData darkTheme = lightTheme.copyWith(
  scaffoldBackgroundColor: AppColor.darkBg,
  // scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 40),
    titleMedium: TextStyle(
      fontSize: 25,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontFamily: AppFont.mulish),
    titleSmall: TextStyle(
      fontSize: 15,
      color: Colors.white,
    ),
    labelSmall: TextStyle(
// color: AppColor.greyColor,
      color: Colors.white,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColor.darkBg,
  ),
  dialogBackgroundColor: AppColor.darkBg,
  appBarTheme: const AppBarTheme(
    color: AppColor.darkBg,
    titleTextStyle: TextStyle(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
);
