import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_cashbook/app/modules/CollectionPage/views/collection_page.dart';
import 'package:my_cashbook/app/modules/Login/views/NumberLoginPage.dart';
import 'package:my_cashbook/app/modules/Splash_OnBoarding/OnBoarding.dart';
import 'package:my_cashbook/app/modules/home/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const String route = 'SplashPage';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool login = false;

  Future<bool> checkLogin() async {
    // await checkAppLock();
    var prefs = await SharedPreferences.getInstance();
    // await prefs.setString('userId', 'ZOBV4MtUohRjQY5W0VWHJrogtFi2');
    var userId = prefs.getString('userId');

    if (userId == null) {
      login = false;
    } else {
      login = true;
    }
    print('Login Status: $login');
    return login;
  }

  Future<bool> decideNavigation() async {
    var login = await checkLogin();
    if (login != null) {
      Timer(Duration(seconds: 3), () {
        Get.offNamed(login ? HomeView.route : OnBoarding.route);
      });
    }
    return login;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: decideNavigation(),
        builder: (context, AsyncSnapshot<bool> snap) {
          if (snap.hasError) {
            return Scaffold(
              body: SafeArea(
                child: Center(
                  child: Text(
                    'Something went wrong\nPlease restart the app.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          } else {
            if (snap.data != null) {
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Image.asset(
                      'assets/app_logo.png',
                      width: Get.width * 0.7,
                    )),
                    RichText(
                      text: TextSpan(
                          text: 'Trust of ',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: Get.width * 0.05),
                          children: [
                            TextSpan(
                                text: '10,00,000+ ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'Businesses'),
                          ]),
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                body: SafeArea(
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }
          }
        });
  }
}
