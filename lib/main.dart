import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import 'package:my_cashbook/Theme/LanguageProvider/LanguageProvider.dart';
import 'package:my_cashbook/Theme/Theme.dart';
import 'package:my_cashbook/Theme/ThemeProvider/ThemeProvider.dart';
import 'package:my_cashbook/translations/codegen_loader.g.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DB/CollectionDBProvider.dart';
import 'DB/HomeDBProvider.dart';
import 'Theme/LanguageProvider/Languages.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase database = FirebaseDatabase.instance;
  // APICacheDBModel apiCacheDBModel =
  //     await APICacheDBModel(key: 'hiii', syncData: 'name: cks');
  // var cacheData = await APICacheManager().addCacheData(apiCacheDBModel);
  // print(cacheData);
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  bool appLockEnabled = false;
  Locale _locale = Locale('en');

  void setLocale(Locale value) {
    print(value.languageCode);
    setState(() {
      _locale = value;
    });
  }

  @override
  void initState() {
    super.initState();
    // checkLogin();
  }

  /*
  @override
  void didChangeDependencies()async {
    await setLocale().then((languageCode) {
      setState(() {
        _locale = Locale(languageCode);
      });
    });
    super.didChangeDependencies();
  }


   */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: checkAppLock(),
        builder: (context, AsyncSnapshot<bool> snap) {
          if (snap.hasError) {
            return GetMaterialApp(
              home: Scaffold(
                body: SafeArea(
                  child: Center(
                    child: Text(
                      'Something went wrong\nPlease restart the app.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          } else {
            if (snap.data != null) {
              return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (context) => ThemeManager()),
                    ChangeNotifierProvider(create: (context) => DBProvider()),
                    ChangeNotifierProvider(create: (context) => CollectionDBProvider()),
                    ChangeNotifierProvider(
                        create: (context) => LanguageProvider()),
                  ],
                  builder: (context, _) {
                    return Consumer<LanguageProvider>(
                        builder: (context, lang, child) {
                      return Consumer<ThemeManager>(
                          builder: (context, theme, child) {
                        return GetMaterialApp(
                          debugShowCheckedModeBanner: false,
                          title: "Application",
                          themeMode: theme.themeMode,
                          theme: lightTheme,
                          darkTheme: darkTheme,
                          initialRoute:
                              // login ? AppPages.NUMBERlOGINPAGE : AppPages.NUMBERlOGINPAGE,

                              AppPages.SPLASHPAGE,
                          getPages: AppPages.routes,
                          // locale: Locale('hi'),
                          // supportedLocales: [
                          //   ...Languages.languages.map((e) => Locale(e.code)).toList(),
                          // ],
                          // supportedLocales: [
                          //   Locale('en', ''), // English, no country code
                          //   Locale('es', ''), // Spanish, no country code
                          // ],
                          // localizationsDelegates: AppLocalizations.localizationsDelegates,
                          localizationsDelegates: context.localizationDelegates,
                          // supportedLocales: Languages.languages.map((e) => e).toList(),
                          supportedLocales: context.supportedLocales,
                          locale: context.locale,
                          // localizationsDelegates: [
                          //   AppLocalizations.delegate,
                          //   GlobalMaterialLocalizations.delegate,
                          //   GlobalWidgetsLocalizations.delegate,
                          //   GlobalCupertinoLocalizations.delegate,
                          // ],
                        );
                      });
                    });
                  });
            } else {
              return GetMaterialApp(
                home: Scaffold(
                  body: SafeArea(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              );
            }
          }
        });
  }

  Future<bool> checkAppLock() async {
    var prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('appLock', true);
    try {
      var containLock = prefs.containsKey('appLock');
      if (containLock) {
        appLockEnabled = prefs.getBool('appLock')!;
        print('App lock status: ${appLockEnabled}');
        if (appLockEnabled) {
          final LocalAuthentication auth = LocalAuthentication();
          final bool canAuthenticateWithBiometrics =
              await auth.canCheckBiometrics;
          final bool canAuthenticate =
              canAuthenticateWithBiometrics || await auth.isDeviceSupported();
          if (canAuthenticate) {
            final List<BiometricType> availableBiometrics =
                await auth.getAvailableBiometrics();
            if (availableBiometrics.contains(BiometricType.strong) ||
                availableBiometrics.contains(BiometricType.face)) {
              try {
                final bool didAuthenticate = await auth.authenticate(
                    localizedReason:
                        'Please authenticate to enable App Lock in app');
                if (didAuthenticate) {
                  // Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (context) => page));
                } else {
                  // Navigator.pop(context);
                  // appLockEnabled.value = false;
                  // Fluttertoast.showToast(msg: 'Could\'nt authenticate.');
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                }
              } on PlatformException catch (e) {
                print(e);
                Fluttertoast.showToast(msg: e.message!);
                // ...
              }
            }
          }
        }
      } else {
        print('No App Lock Available yet');
      }
    } catch (e) {
      print(e);
    }
    return appLockEnabled;
    // print(appLockEnabled.value);
  }
}
