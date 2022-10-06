import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_cashbook/app/modules/Login/views/NumberLoginPage.dart';
import 'package:provider/provider.dart';

import '../../../Theme/LanguageProvider/LanguageProvider.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);
  static const String route = '/OnBoarding';

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final CarouselController _lang = CarouselController();

  int _current = 0;
  @override
  void initState() {
    super.initState();
    // Timer.periodic(Duration(milliseconds: 500), (timer) {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = [
      'Keep track of \ndaily transactions',
      'Generate daily,monthly \nPDF & Excel reports',
      'Greate groups just \nlike Whatsapp'
    ].asMap().entries.map((e) {
      return Container(
        height: Get.height * 0.8,
        child: Column(
          children: [
            Container(
              height: Get.height * 0.65,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Column(
                    children: [
                      SizedBox(height: 150),
                      Container(
                        height: Get.height * 0.65 - 150,
                        child: Image.asset(
                          'assets/onBoarding/pic${e.key + 1}.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              height: Get.height * 0.15,
              width: Get.width,
              color: Colors.white,
              child: Center(
                  child: Text(
                '${e}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              )),
            ),
          ],
        ),
      );
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: Get.height * 0.8,
                color: Colors.blue,
                width: Get.width,
                child: CarouselSlider(
                  items: imageSliders,
                  carouselController: _lang,
                  options: CarouselOptions(
                      autoPlay: true,
                      // enlargeCenterPage: true,
                      // pageSnapping: false,
                      // padEnds: false,
                      aspectRatio: 0.5,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Positioned(
                top: kToolbarHeight,
                right: 20,
                child:
                    Consumer<LanguageProvider>(builder: (context, lang, child) {
                  return RaisedButton(
                    color: Get.theme.backgroundColor.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                          color: Get.theme.backgroundColor.withOpacity(1)),
                    ),
                    onPressed: () async {
                      double bottomCorner = 15;
                      await showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(bottomCorner),
                                  topRight: Radius.circular(bottomCorner))),
                          context: context,
                          builder: (context) => ShowLangaugeBottomSheet());
                    },
                    child: Row(
                      children: [
                        Text(lang.previouslySelectedlangauage.name),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
          Container(
            height: Get.height * 0.2,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1, 2, 3].asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _lang.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Get.offAllNamed(NumberLoginPage.route);
                    },
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13.0),
                      child: Text(
                        'Continue',
                        style: TextStyle(fontSize: 20),
                      ),
                    )),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
