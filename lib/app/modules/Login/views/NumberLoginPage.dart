import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../Theme/LanguageProvider/LanguageProvider.dart';
import '../controllers/NumberLoginPageController.dart';
import 'OtpSubmitPage.dart';

class NumberLoginPage extends GetView<NumberLoginPageController> {
  static const String route = '/NumberLoginPage';
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    print(DateTime.now().toString());

    return Obx(() {
      print(controller.phoneCode.value);
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                backgroundColor: theme.backgroundColor.withOpacity(0.7),
                toolbarHeight: 100,
                elevation: 1,
                title: Row(
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
                          Icons.login,
                          color: theme.iconTheme.color,
                        ),
                      )),
                    ),
                    SizedBox(width: 13),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          // style: theme.textTheme.headline6,
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Login to auto backup your data securely',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ],
                ),
                // title:
                // centerTitle: false,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child:
                    Consumer<LanguageProvider>(builder: (context, lang, child) {
                  return TextFormField(
                    onTap: () async {
                      double bottomCorner = 15;
                      await showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(bottomCorner),
                                  topRight: Radius.circular(bottomCorner))),
                          context: context,
                          builder: (context) => ShowLangaugeBottomSheet());
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      // labelText: 'Select Language',
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      hintText: lang.previouslySelectedlangauage.name,
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Obx(() {
                        print(controller.phoneCode.value);
                        return TextFormField(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              favorite: <String>['in'],
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                controller.phoneCode.value = country.phoneCode;
                                print('Select country: ${country.phoneCode}');
                              },
                              countryListTheme: CountryListThemeData(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ),
                                inputDecoration: InputDecoration(
                                  labelText: 'Search',
                                  hintText: 'Start typing to search',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8)
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                            // labelText: 'Select Language',
                            hintText: '+${controller.phoneCode.value}',
                            border:
                                OutlineInputBorder(borderSide: BorderSide()),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        );
                      }),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        // readOnly: true,
                        // initialValue: 'English',
                        // maxLength: 10,
                        controller: controller.numberController.value,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          labelStyle: theme.textTheme.bodyText2,
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                  onPressed: !controller.loading.value
                      ? () async {
                          if (controller.phoneCode.value.isNotEmpty &&
                              controller
                                  .numberController.value.text.isNotEmpty) {
                            controller.sendOtp(controller.phoneCode.value,
                                controller.numberController.value.text);
                          } else {
                            Get.snackbar(
                                'Data Error', 'Please enter all information');
                          }
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.loading.value)
                        Container(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator()),
                      SizedBox(width: 10),
                      Text('SEND OTP'),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: RichText(
                    text: TextSpan(
                        text: 'By creating an account, you agree to our ',
                        style: theme.textTheme.caption,
                        children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => print('Term of Services'),
                          text: 'Term of Services',
                          style: theme.textTheme.caption!
                              .copyWith(decoration: TextDecoration.underline)),
                      TextSpan(text: ' & '),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => print('Privacy Policy'),
                          text: 'Privacy Policy',
                          style: theme.textTheme.caption!
                              .copyWith(decoration: TextDecoration.underline)),
                    ])),
              ),
            ],
          ),
        ),
      );
    });
  }
}
