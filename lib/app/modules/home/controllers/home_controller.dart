import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:my_cashbook/app/modules/Splash_OnBoarding/OnBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../../DB/HomeDBProvider.dart';
import '../../../../Models/BookModel.dart';
import '../../../../Models/ExpanceType.dart';
import '../../../../Models/UserModel.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late UserModel userModel;

  RxList<CollectionBook> collectionBooksList = <CollectionBook>[].obs;
  RxList<ExpanseType> expansesTypeList = <ExpanseType>[].obs;

  Rx<FocusNode> searchFocusNode = FocusNode().obs;
  RxInt currentBottomIndex = 0.obs;
  RxBool appLockEnabled = false.obs;
  RxList<MainExpanseType> mainExpanseTypeList = [
    ...[
      'Groceries Expanses',
      'Lunch Expanses',
      'Breakfast Expanses',
      'Dinner Expanses',
      'Room Rent',
      'Travelling Expanses',
      'Electricity Bill',
      'Home Bill',
      'Study Expanses',
      'Cloths Expanses',
      'Shopping',
      'Fast Food',
      'Fruits',
      'Accessories Expanses',
      'Furniture ',
      'Total Lend ',
      'Petrol Expanses',
      'Tour Expanses',
      'Payable Book'
    ].map(
        (e) => MainExpanseType(name: e, createdAt: DateTime.now().toString())),
    // MainExpanseType(name: 'Debit Book', createdAt: DateTime.now().toString()),
    // MainExpanseType(name: 'Payable Book', createdAt: DateTime.now().toString()),
    // MainExpanseType(
    //     name: 'Food Expanses', createdAt: DateTime.now().toString()),
  ].obs;

  Map<String, String> sortByList = {
    'updatedAt': 'Last Updated',
    'name': 'Name (A to Z)',
    'total': 'Net Balance (High to Low)',
    'total': 'Net Balance (Low to High)',
    'createdAt': 'Last Created'
  };
  RxString previousSortBy = 'updatedAt'.obs;
  RxString sortBy = 'updatedAt'.obs;

  final count = 88.obs;

  @override
  void onInit() {
    super.onInit();
    DBProvider().fetchExpanseTypes().listen((event) {
      expansesTypeList.value = event;
      print('Expances list : $event');
      update();
    });
    // DBProvider().fetchCollectionBooks().listen((event) {
    //   collectionBooksList.value = event;
    //
    //   print('EVENT: $event');
    //   update();
    // });

    checkLogin();
    getUserInfo();
    checkAppLock();
    searchFocusNode.value.unfocus();
  }

  @override
  void onReady() {
    super.onReady();
    print('Home controller Ready');
  }

  @override
  void onClose() {
    super.onClose();
    print('Home controller closed');
  }

  void increment() => count.value++;

  List<MainExpanseType> refreshMainExpanseList(List<MainExpanseType> list) {
    List<MainExpanseType> newMainList = [];
    if (list.isEmpty) {
      mainExpanseTypeList.shuffle();
      newMainList.add(
          mainExpanseTypeList[Random().nextInt(mainExpanseTypeList.length)]);
      newMainList.add(
          mainExpanseTypeList[Random().nextInt(mainExpanseTypeList.length)]);
      newMainList.add(
          mainExpanseTypeList[Random().nextInt(mainExpanseTypeList.length)]);
      newMainList.add(
          mainExpanseTypeList[Random().nextInt(mainExpanseTypeList.length)]);
      newMainList.insert(
          0,
          MainExpanseType(
              name: '${DateFormat('MMMM').format(DateTime.now())} Expanses',
              createdAt: DateTime.now().toString()));
      for (var element in newMainList) {
        print('newMainList: ${element.name}');
      }
    }

    return newMainList;
  }

  ///TODO: CHECK LOGIN
  void checkLogin() async {
    var prefs = await SharedPreferences.getInstance();
    // await prefs.setString('userId', 'ZOBV4MtUohRjQY5W0VWHJrogtFi2');
    userModel = UserModel.fromJson(jsonDecode(prefs.getString('user')!));
    print(prefs.getString('userId'));
    await DBProvider().initUser();

    // mainExpanseTypeList.value.shuffle();
    mainExpanseTypeList.shuffle();
    List<MainExpanseType> newMainList = [];

    await DBProvider()
        .addMainExpanseType(list: refreshMainExpanseList(newMainList));
  }

  void getUserInfo() async {
    CollectionReference ref = firestore.collection('users');
    QuerySnapshot snap = await ref.get();
    print(snap.docs.length);
    var prefs = await SharedPreferences.getInstance();
    // await prefs.setString('userId', '+919135324545');

    var userSnap = snap.docs.firstWhere((e) {
      print(e.data());
      return UserModel.fromJson(e.data() as Map<String, dynamic>).number ==
          UserModel.fromJson(jsonDecode(prefs.getString('user')!)).number;
    });
    userModel = UserModel.fromJson(userSnap.data() as Map<String, dynamic>);
    await prefs.setString('user', jsonEncode(userModel.toJson()));
    print(userModel.name);
  }

  Future<void> toogleAppLock(bool biometric, BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    if (biometric) {
      final LocalAuthentication auth = LocalAuthentication();
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
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
              appLockEnabled.value = !appLockEnabled.value;
              await prefs.setBool('appLock', appLockEnabled.value);
              print('App lock stauts: ${appLockEnabled.value}');
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => page));
            } else {
              // Navigator.pop(context);
              // appLockEnabled.value = false;
              Fluttertoast.showToast(msg: 'Could\'nt authenticate.');
            }
          } on PlatformException catch (e) {
            print(e);
            Fluttertoast.showToast(msg: e.message!);
            // ...
          }
        }
      }
    } else {
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
    }
  }

  void checkAppLock() async {
    var prefs = await SharedPreferences.getInstance();
    var containAppLock = prefs.containsKey('appLock');
    if (containAppLock) {
      appLockEnabled.value = prefs.getBool('appLock')!;
      print('App lock status: ${appLockEnabled.value}');
    }
    print('App lock stauts: ${appLockEnabled.value}');
  }

  Future<void> logOut() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Get.offAllNamed(OnBoarding.route);
    Fluttertoast.showToast(msg: 'Log Out Successfully.');
  }
}
