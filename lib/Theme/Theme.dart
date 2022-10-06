import 'package:flutter/material.dart';

import 'AppInfo.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primarySwatch: MaterialColor(
    // 0xFF010060,
    AppInfo.appLightColorSchemeCode,
    {
      50: Color(AppInfo.appLightColorSchemeCode).withOpacity(0.1),
      100: Color(AppInfo.appLightColorSchemeCode).withOpacity(0.2),
      200: Color(AppInfo.appLightColorSchemeCode).withOpacity(0.3),
      300: Color(AppInfo.appLightColorSchemeCode).withOpacity(0.4),
      400: Color(AppInfo.appLightColorSchemeCode).withOpacity(0.5),
      500: Color(AppInfo.appLightColorSchemeCode).withOpacity(0.6),
      600: Color(AppInfo.appLightColorSchemeCode).withOpacity(0.7),
      700: Color(AppInfo.appLightColorSchemeCode).withOpacity(0.8),
      800: Color(AppInfo.appLightColorSchemeCode).withOpacity(0.9),
      900: Color(AppInfo.appLightColorSchemeCode).withOpacity(1),
    },
  ),
  // appBarTheme: AppBarTheme(
  //   brightness: Brightness.light,
  //   // color: Colors.white,
  // ),
  primaryColor: lightPrimaryColor,
  inputDecorationTheme: InputDecorationTheme(
      // fillColor: Colors.grey[150],
      // filled: true,
      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
      labelStyle: TextStyle(color: AppInfo.appLightColorRed.withOpacity(0.6))),
  buttonTheme: ButtonThemeData(
      buttonColor: AppInfo.appLightColorRed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      textTheme: ButtonTextTheme.primary),
  iconTheme: const IconThemeData(color: Colors.white),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: MaterialColor(
    // 0xFFE89AEE,
    // 0xFF8EC53B,
    //
    // {
    //   50: Color(0x178EC53B),
    //   100: Color(0x358EC53B),
    //   200: Color(0x4C8EC53B),
    //   300: Color(0x698EC53B),
    //   400: Color(0x838EC53B),
    //   500: Color(0x938EC53B),
    //   600: Color(0xB28EC53B),
    //   700: Color(0xC78EC53B),
    //   800: Color(0xE28EC53B),
    //   900: Color(0xFF8EC53B),
    // },
    AppInfo.appDarkColorSchemeCode,
    {
      50: Color(AppInfo.appDarkColorSchemeCode).withOpacity(0.1),
      100: Color(AppInfo.appDarkColorSchemeCode).withOpacity(0.2),
      200: Color(AppInfo.appDarkColorSchemeCode).withOpacity(0.3),
      300: Color(AppInfo.appDarkColorSchemeCode).withOpacity(0.4),
      400: Color(AppInfo.appDarkColorSchemeCode).withOpacity(0.5),
      500: Color(AppInfo.appDarkColorSchemeCode).withOpacity(0.6),
      600: Color(AppInfo.appDarkColorSchemeCode).withOpacity(0.7),
      700: Color(AppInfo.appDarkColorSchemeCode).withOpacity(0.8),
      800: Color(AppInfo.appDarkColorSchemeCode).withOpacity(0.9),
      900: Color(AppInfo.appDarkColorSchemeCode).withOpacity(1),
    },
  ),
  // secondaryHeaderColor: darkMainColor,
  inputDecorationTheme: InputDecorationTheme(
      // fillColor: Colors.grey[150],
      // filled: true,
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(15),
      // ),
      //   labelStyle: TextStyle(color:Color(0xFF2546EE).withOpacity(0.6))
      ),
  buttonTheme: ButtonThemeData(
      buttonColor: AppInfo.appDarkColor.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      textTheme: ButtonTextTheme.primary),
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.resolveWith(getColor),
    thumbColor: MaterialStateProperty.resolveWith(getColor),
  ),
);

Color getColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return blueColor;
  }
  return Colors.grey;
}
