import 'package:get/get.dart';
import 'package:my_cashbook/app/modules/CollectionPage/views/collection_page.dart';
import 'package:my_cashbook/app/modules/Dummy/dummyBinding.dart';
import 'package:my_cashbook/app/modules/Dummy/dummy_view.dart';
import 'package:my_cashbook/app/modules/Login/bindings/NumberLoginPageBindings.dart';
import 'package:my_cashbook/app/modules/Login/views/NumberLoginPage.dart';
import 'package:my_cashbook/app/modules/Login/views/OtpSubmitPage.dart';
import 'package:my_cashbook/app/modules/Settings/bindings/SettingsPageBindings.dart';
import 'package:my_cashbook/app/modules/Settings/controllers/SettingsPageController.dart';
import 'package:my_cashbook/app/modules/Splash_OnBoarding/OnBoarding.dart';
import 'package:my_cashbook/app/modules/Splash_OnBoarding/SplashPage.dart';
import 'package:my_cashbook/app/modules/home/SearchByBookName.dart';

import 'package:my_cashbook/app/modules/home/bindings/home_binding.dart';
import 'package:my_cashbook/app/modules/home/views/home_view.dart';

import '../../checkNumber.dart';
import '../modules/CollectionPage/bindings/CollectionPageBinding.dart';
import '../modules/Login/views/UserInfoInitialization.dart';
import '../modules/Settings/views/SettingsPage.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;
  static const COLLECTIONPAGE = Routes.COLLECTIONPAGE;
  static const SPLASHPAGE = Routes.SplashPage;
  static const ONBOARDING = Routes.OnBoarding;
  static const NUMBERlOGINPAGE = Routes.NumberLoginPage;
  static const CHECKNUMBER = Routes.CheckNumber;
  static const USERINFOINITIALIZATION = Routes.UserInfoInitialization;
  static const OTPSUBMITPAGE = Routes.OtpSubmitPage;
  static const SEARCHBYBOOKNAME = Routes.SearchByBookName;
  static const SETTINGSPAGE = Routes.SettingsPage;
  static const Dummy = Routes.dummy;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.COLLECTIONPAGE,
      page: () => CollectionPage(),
      binding: CollectionPageBinding(),
    ),
    GetPage(
      name: _Paths.SplashPage,
      page: () => SplashPage(),
      // binding: NumberLoginPageBindings(),
    ),
    GetPage(
      name: _Paths.OnBoarding,
      page: () => OnBoarding(),
      // binding: NumberLoginPageBindings(),
    ),
    GetPage(
      name: _Paths.NumberLoginPage,
      page: () => NumberLoginPage(),
      binding: NumberLoginPageBindings(),
    ),
    GetPage(
      name: _Paths.CheckNumber,
      page: () => CheckNumber(),
      // binding: NumberLoginPageBindings(),
    ),
    GetPage(
      name: _Paths.UserInfoInitialization,
      page: () => UserInfoInitialization(),
      binding: NumberLoginPageBindings(),
    ),
    GetPage(
      name: _Paths.OtpSubmitPage,
      page: () => OtpSubmitPage(),
      binding: NumberLoginPageBindings(),
    ),
    GetPage(
      name: _Paths.SearchByBookName,
      page: () => SearchByBookName(),
      // binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SettingsPage,
      page: () => SettingsPage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.dummy,
      page: () => DummyPage(),
      binding: DummyBindings(),
    ),
  ];
}
