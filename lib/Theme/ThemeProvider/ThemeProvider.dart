import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeManager with ChangeNotifier {
  Brightness brightness = SchedulerBinding.instance.window.platformBrightness;
  ThemeMode _themeMode =
      SchedulerBinding.instance.window.platformBrightness == Brightness.light
          ? ThemeMode.light
          : ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;
  toogleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

