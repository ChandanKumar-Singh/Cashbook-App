import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_cashbook/DB/AuthManager.dart';
import 'package:my_cashbook/Models/UserModel.dart';
import 'package:my_cashbook/Theme/AppInfo.dart';
import 'package:my_cashbook/app/modules/Login/views/NumberLoginPage.dart';
import 'package:my_cashbook/app/modules/Login/views/UserInfoInitialization.dart';
import 'package:my_cashbook/app/modules/home/SearchByBookName.dart';
import 'package:my_cashbook/app/modules/home/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/100%secure.dart';
import '../controllers/NumberLoginPageController.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:telephony/telephony.dart';

class OtpSubmitPage extends GetView<NumberLoginPageController> {
  static const String route = '/OtpSubmitPage';
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signIn(String otp) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
      verificationId: controller.verfId.value,
      smsCode: otp,
    ))
        .then((value) async {
      controller.uid.value = value.user!.uid;
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', controller.uid.value);
      print(prefs.getString('userId'));

      print('${value.user!.uid}  this is uid');
      controller.signing.value = false;
      print('finally sinning details : ${controller.signing.value}');
      var exist = await userExist(value.user!);
      print('result of user exist or not $exist');
      if (!exist) {
        Get.to(UserInfoInitialization());
      } else {
        Get.offAllNamed(HomeView.route);
      }
      controller.otpCode.value = '';
      controller.signing.value = false;
    });
  }

  Future<bool> userExist(User user) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    var snap = await ref.get();
    var result = snap.docs.any((element) {
      print(
          'testing for user : +${controller.phoneCode.value}${controller.numberController.value.text}');
      print(
          'element id : +${controller.phoneCode.value}${controller.numberController.value.text}');
      return element.id ==
          '+${controller.phoneCode.value}${controller.numberController.value.text}';
    });
    return result;
    // UserModel userModel = UserModel.
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;

    return Obx(() {
      print(controller.phoneCode.value);
      print('otpCode: ${controller.otpCode.value}');
      print('signing: ${controller.signing.value}');

      return Scaffold(
        body: Column(
          children: [
            Obx(() {
              var code = controller.otpCode.value;
              var signing = controller.signing.value;
              if (signing) {
                print(code);
                showSignInDialog(context);
                var otp;
                if (code.length > 6) {
                  otp = code.substring(0, 6);
                } else {
                  otp = code;
                }
                print('Otp Received : ${code}');
                print('Otp Edited : $otp');
                signIn(otp);
              }
              return Container();
            }),
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: theme.backgroundColor.withOpacity(0.7),
              toolbarHeight: 120,
              elevation: 1,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                print('Go Back');
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: theme.iconTheme.color,
                              )),
                          SizedBox(width: 5),
                          Text(
                            'Back',
                            // style: theme.textTheme.headline6,
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: () {
                              print('Help');
                            },
                            child: Text(
                              'HELP',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.9)),
                            ),
                          ),
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        // height: 50,
                        // width: 50,
                        margin: EdgeInsets.only(left: 10),
                        // padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.cardColor.withOpacity(0.3),
                        ),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.password_rounded,
                            color: theme.iconTheme.color,
                          ),
                        )),
                      ),
                      SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verify OTP',
                              // style: theme.textTheme.headline6,
                            ),
                            SizedBox(height: 7),
                            Obx(() {
                              return RichText(
                                  maxLines: 2,
                                  text: TextSpan(
                                      text:
                                          'We have send otp to your mobile number +${controller.phoneCode.value} ${controller.numberController.value.text} | ',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white.withOpacity(0.9)),
                                      children: [
                                        TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => Get.toNamed(
                                                  NumberLoginPage.route),
                                            text: 'Change',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold))
                                      ]));
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),

              // title:
              // centerTitle: false,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Obx(() {
                return OTPTextField(
                  controller: controller.otpbox.value,
                  length: 5,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 50,
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    print("Entered OTP Code: $pin");
                  },
                );
              }),
            ),
            /*
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: s.width / 2,
                child: TextFormField(
                  autofocus: true,
                  readOnly: false,

                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    // labelText: 'Select Language',
                    // border: OutlineInputBorder(borderSide: BorderSide()),
                    hintText: '* * * * * *',
                    hintStyle: TextStyle(
                        fontSize: 20, color: Get.theme.backgroundColor),
                  ),
                ),
              ),
            ),

             */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return RichText(
                        maxLines: 2,
                        text: TextSpan(
                            text: 'Resend OTP in ',
                            style: TextStyle(
                              fontSize: 13,
                              color: Get.theme.textTheme.headline6!.color,
                            ),
                            children: [
                              TextSpan(
                                  text: '${controller.phoneCode.value} secs ',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: 'via',
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal))
                            ]));
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        // signIn('otp');
                        await signIn(controller.otpCode.value);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.message_outlined),
                          SizedBox(width: 5),
                          Text('SMS'),
                        ],
                      ),
                      // style: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        // signIn('otp');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.whatsapp),
                          SizedBox(width: 5),
                          Text('Whatsapp'.toUpperCase()),
                        ],
                      ),
                      // style: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RichText(
                  text: TextSpan(
                      text: 'Use only the ',
                      style: theme.textTheme.bodyText2,
                      children: [
                    TextSpan(
                        text: 'Latest OTP',
                        style: theme.textTheme.bodyText2!.copyWith(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold)),
                    TextSpan(text: ' sent on '),
                    TextSpan(
                        text: 'SMS',
                        style: theme.textTheme.bodyText2!.copyWith(
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold)),
                  ])),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RichText(
                  text: TextSpan(
                      text: 'Need Help? ',
                      style: theme.textTheme.bodyText2!.copyWith(
                          decoration: TextDecoration.none,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('Contact us');
                          },
                        text: 'Contact Us',
                        style: theme.textTheme.bodyText2!.copyWith(
                            decoration: TextDecoration.none,
                            color: Get.theme.backgroundColor,
                            fontWeight: FontWeight.bold)),
                  ])),
            ),
            SizedBox(height: 25),
          ],
        ),
      );
    });
  }

  void showSignInDialog(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: Get.width / 5, vertical: Get.height / 2.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Verifying OTP', style: Get.theme.textTheme.headline6),
                    SizedBox(height: 20),
                    Container(
                      height: 25,
                      width: 25,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}


class LanguageModel {
  final String caption, name, code;
  LanguageModel(this.caption, this.name, this.code);
}
