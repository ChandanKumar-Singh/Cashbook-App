import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:mobile_number/sim_card.dart';

import 'package:my_cashbook/Models/UserModel.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

import '../../../../DB/HomeDBProvider.dart';
import '../../../../Theme/LanguageProvider/Languages.dart';
import '../../home/views/home_view.dart';

class NumberLoginPageController extends GetxController {
  //TODO: Implement HomeController
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Telephony telephony = Telephony.instance;

  ///get sim cards
  RxString _mobileNumber = ''.obs;
  RxList<SimCard> _simCard = <SimCard>[].obs;

  RxString phoneCode = '91'.obs;
  List<LanguageModel> languages = [
    LanguageModel('English', 'English', 'en'),
    LanguageModel('Hindi', 'हिंदी', 'hi'),
    LanguageModel('Hinglish', 'Hinglish', 'en'),
    LanguageModel('Marathi', 'मराठी', 'mr'),
    LanguageModel('Gujarati', 'ગુજરાતી ', 'gu'),
    LanguageModel('Bengali', 'বাংলা', 'bn'),
  ];
  RxInt selectedlangauage = 0.obs;
  late int previouslySelectedlangauage;
  Rx<LanguageModel> languageModel =
      LanguageModel('English', 'English', 'en').obs;
  Rx<TextEditingController> numberController = TextEditingController().obs;
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<TextEditingController> businessNameController =
      TextEditingController().obs;
  Rx<OtpFieldController> otpbox = OtpFieldController().obs;
  RxString uid = "".obs;
  // Rx<User> user=User.obs;
  RxString authStatus = "".obs;
  RxString otpCode = "".obs;
  RxString verfId = "".obs;
  RxBool loading = false.obs;
  RxBool signing = false.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });
    initMobileNumberState();

    previouslySelectedlangauage = selectedlangauage.value;
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        print(message.address); //+977981******67, sender nubmer
        print(message.body); //Your OTP code is 34567
        print(message.date); //1659690242000, timestamp

        String sms = message.body.toString(); //get the message
        print(
            'Your number is +${phoneCode.value}${numberController.value.text}');

        //verify SMS is sent for OTP with sender number
        otpCode.value = '';
        otpCode.value = sms.replaceAll(RegExp(r'[^0-9]'), '');
        print('otpbox ${otpbox.firstRebuild}');
        otpbox.value.set(otpCode.value.split(""));
        print('otpbox2 ${otpbox.firstRebuild}');

        //split otp code to list of number
        //and populate to otb boxes
      },
      listenInBackground: false,
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _mobileNumber.value = (await MobileNumber.mobileNumber)!;
      _simCard.value = (await MobileNumber.getSimCards)!;
      print(_simCard.value.length);
      if (await MobileNumber.hasPhonePermission) {
        var context = Get.context!;
        Timer(Duration(seconds: 1), () async {
          await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  actions: [
                    ..._simCard.value.map(
                      (e) => ListTile(
                        onTap: () async {
                          phoneCode.value =
                              e.number!.split('').getRange(0, 2).join('');
                          numberController.value.text =
                              e.number!.split('').getRange(2, 12).join('');
                          print(phoneCode.value);
                          print(numberController.value.text);
                          Get.back();
                          await sendOtp(
                              phoneCode.value, numberController.value.text);
                        },
                        leading: CircleAvatar(
                          child: Text(
                            'SIM ${e.slotIndex!}',
                            style: Get.theme.textTheme.caption!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          '+${e.number!}',
                          style: Get.theme.textTheme.headline6!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        // trailing: Spacer(),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('None of the above')),
                    // Spacer(),
                  ],
                );
              });
        });
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {});
  }

  Future<void> sendOtp(String phoneCode, String phoneNumber) async {
    loading.value = true;
    await auth.verifyPhoneNumber(
      phoneNumber: '+$phoneCode$phoneNumber',
      // phoneNumber: '+$phoneCode''9135324545',
      timeout: const Duration(seconds: 120),
      forceResendingToken: 633638,
      verificationCompleted: (PhoneAuthCredential credential) async {
        authStatus.value = "Your account is successfully verified";
        print(credential);
        // auth.signInWithCredential(credential).then((UserCredential result) {
        //   Navigator.pushReplacement(Get.context!,
        //       MaterialPageRoute(builder: (context) => HomeView()));
        // }).catchError((e) {
        //   print(e);
        // });
      },
      verificationFailed: (FirebaseAuthException e) {
        authStatus.value = "Authentication failed";
        loading.value = false;
        signing.value = false;
        Get.snackbar('Auth Fail',
            '${authStatus.value}\n${e.code.split('-').join(' ').toUpperCase()}',
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            colorText: Colors.white);
        print(loading.value);
        print(e.code);
      },
      codeSent: (String verificationId, int? resendToken) async {
        authStatus.value = "OTP has been successfully send";
        verfId.value = verificationId;
        loading.value = false;
        signing.value = true;
        print('Verfication id : $verificationId');

        Get.back();
        Get.toNamed('/OtpSubmitPage');
        Fluttertoast.showToast(
            msg: 'OTP has sent to your phone.',
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green);

        // Update the UI - wait for the user to enter the SMS code
        // String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //     verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        // await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        authStatus.value = "TIMEOUT";
        loading.value = false;
        signing.value = false;
        print(loading.value);
        Get.snackbar('TimeOut', 'Please retry login process. ');
      },
    );
  }

  void initiateUser(
      {required String name,
      required String number,
      required String uid,
      String? businessName}) async {
    DocumentReference ref = firestore.collection('users').doc(number);
    UserModel userModel = UserModel(
        name: name,
        number: number,
        businessName: businessName,
        uid: uid,
        createdAt: DateTime.now().toString());
    print(number);

    var result = await ref
        .set(userModel.toJson())
        .then((value) => Get.toNamed(HomeView.route));
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(userModel.toJson()));
    await DBProvider().initUser();
    // if (result. != null) {
    //
    // }
    print('User Initiated');
    print(result);
  }
}
