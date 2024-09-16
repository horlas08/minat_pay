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
    // enabledBorder: OutlineInputBorder(
    //   borderSide: const BorderSide(
    //     color: AppColor.greyColor,
    //     width: 3,
    //   ),
    //   borderRadius: BorderRadius.circular(8),
    // ),

    // focusedErrorBorder: OutlineInputBorder(
    //   borderSide: const BorderSide(
    //     color: AppColor.danger,
    //     width: 3,
    //   ),
    //   borderRadius: BorderRadius.circular(8),
    // ),
    // errorBorder: OutlineInputBorder(
    //   borderSide: const BorderSide(
    //     color: AppColor.danger,
    //     width: 3,
    //   ),
    //   borderRadius: BorderRadius.circular(8),
    // ),
    errorStyle: const TextStyle(
        color: AppColor.danger,
        fontSize: 12,
        fontFamily: AppFont.mulish,
        fontWeight: FontWeight.bold),
    // border: OutlineInputBorder(
    //   borderSide: const BorderSide(
    //     color: AppColor.greyColor,
    //     width: 3,
    //   ),
    //   borderRadius: BorderRadius.circular(8),
    // ),
    // focusedBorder: OutlineInputBorder(
    //   borderSide: const BorderSide(
    //     color: AppColor.primaryColor,
    //     width: 3,
    //   ),
    //   borderRadius: BorderRadius.circular(8),
    // ),
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
  scaffoldBackgroundColor: Colors.black.withOpacity(0.4),
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
);

ThemeData pinkTheme = lightTheme.copyWith(
  // primaryColor: const Color(0xFFF49FB6),
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
  scaffoldBackgroundColor: const Color(0xFFFAF8F0),
);

ThemeData halloweenTheme = lightTheme.copyWith(
  // primaryColor: const Color(0xFF55705A),
  scaffoldBackgroundColor: const Color(0xFFE48873),
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
);

ThemeData darkBlueTheme = lightTheme.copyWith(
  // primaryColor: const Color(0xFF1E1E2C),
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
  scaffoldBackgroundColor: const Color(0xFF2D2D44),
);
