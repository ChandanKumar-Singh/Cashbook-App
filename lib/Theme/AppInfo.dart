import 'package:flutter/material.dart';

class AppInfo {
  static const String appName = 'My CashBook';
  static const String appPackageName = 'com.example.cq_school';
  static const String appLogo = 'assets/appConstants/appLogo.png';

  //Colors
  static const Color appLightColorGold = Color(0xFFAF6714);
  static const Color appLightColorRed = Color(0xFF002DFF);
  static const Color appLightColorWhite = Color(0xFFFFFFFF);
  static const Color appLightColorGreen = Color(0xFF009B32);
  static const int appLightColorSchemeCode = 0xFF002DFF;
  static const int appLightColorSchemeCode2 =
      0xFFFFFFFF; //copy the int code of your main color and replace this to new one.

  static const Color appDarkColor =
      Color.fromRGBO(114, 114, 110, 0.4666666666666667);
  static const int appDarkColorSchemeCode = 0x7772726E;

  static const String starterUrl =
      'https://karmkshetra.com/erp/lordshivaacademy/index.php/apis/v1/Api/sessions';
  static const String baseUrl =
      'https://karmkshetra.com/erp/lordshivaacademy/index.php/apis/v1/Api/';
  static const String baseUrl2 =
      'https://karmkshetra.com/erp/lordshivaacademy/';
  static const String assetsUrl = 'uploads/dp/';
}
