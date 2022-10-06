import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_cashbook/DB/DBConstants.dart';
import 'package:my_cashbook/Models/BookDetails/ExpanseHistory.dart';
import 'package:my_cashbook/Models/BookModel.dart';
import 'package:my_cashbook/Models/ExpanceType.dart';
import 'package:my_cashbook/Models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBProvider extends ChangeNotifier {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  DBConstants dbConst = DBConstants();
  UserModel? users;
  late SharedPreferences prefs;
  List<ExpanseType> expansesTypeList = [];
  List<MainExpanseType> mainExpanseType = [];
  List<CollectionBook> collectionBooksList = [];
  List<ExpanseHistory> expanseHistoryList = [];
  String batteryLevel = 'Battery Level';

  Future<void> getBatteryLevel() async {
    String bl;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      bl = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      bl = "Failed to get battery level: '${e.message}'.";
    }

    batteryLevel = bl;
    notifyListeners();
  }

  Future<void> initUser() async {
    prefs = await SharedPreferences.getInstance();
    users = UserModel.fromJson(jsonDecode(prefs.getString('user')!));
    print(
        '==================DBProvider user initiated========== ${users!.name}');
  }

  ///TODO:add ,rename and fetch books

  Future<void> renameCollectionBook({required CollectionBook book}) async {
    prefs = await SharedPreferences.getInstance();
    users = UserModel.fromJson(jsonDecode(prefs.getString('user')!));
    print(
        '==================DBProvider user initiated========== ${users!.name}');
    // Get.back();

    await DBConstants()
        .collectionBook(userId: users!.number, bookCollectionName: 'books')
        .doc(book.createdAt)
        .set(book.toJson())
        .then((value) => print('Book Added.'))
        .then((value) async {});
    print(collectionBooksList);
  }

  Stream<List<CollectionBook>> fetchCollectionBooks(
      {required String sortBy, required bool desc}) async* {
    prefs = await SharedPreferences.getInstance();
    users = UserModel.fromJson(jsonDecode(prefs.getString('user')!));
    print(
        '==================DBProvider user initiated========== ${users!.name}');
    List<CollectionBook> list = [];
    Stream<QuerySnapshot> snap = dbConst
        .collectionBook(userId: users!.number, bookCollectionName: 'books')
        .orderBy(sortBy, descending: desc)
        .snapshots();
    await for (var doc in snap) {
      collectionBooksList.clear();
      print(doc.docs.length);

      try {
        for (var type in doc.docs) {
          // try{
          var book =
              CollectionBook.fromJson(type.data() as Map<String, dynamic>);
          list.add(book);
          print('book : ${book.toJson()}');

          // }catch(e){
          //   print('dfj');
          // }
          notifyListeners();
        }
      } catch (e) {
        print(e);
      }

      collectionBooksList = list;
      yield collectionBooksList;
      notifyListeners();
    }

    notifyListeners();
    /*
    prefs = await SharedPreferences.getInstance();
    users = UserModel.fromJson(jsonDecode(prefs.getString('user')!));
    print(
        '==================DBProvider user initiated========== ${users!.name}');
    List<CollectionBook> list = [];
    Stream<QuerySnapshot> snap = dbConst
        .collectionBook(userId: users!.number, bookCollectionName: 'books')
        .orderBy('createdAt', descending: true)
        .snapshots();
    await for (var doc in snap) {
      try {
        collectionBooksList.clear();

        for (var type in doc.docs) {
          var book =
              CollectionBook.fromJson(type.data() as Map<String, dynamic>);
          list.add(book);
          print('book : ${book.toJson()}');
          // print(list.length);
          notifyListeners();
          // print(list.length);
          // print(list.length);
        }
      } catch (e) {
        // print(e);
      }
      // break;
      print('hhhhhhhhhiiiiiiiiiiiiiiiiiii');
      collectionBooksList = list;
      print(collectionBooksList.length);
      yield collectionBooksList;
     */
  }

  //add and fetch expanses
  Future<void> addNewExpanseType(ExpanseType expanse) async {
    await DBConstants()
        .expanseType
        .doc(expanse.name)
        .set(expanse.toJson())
        .then((value) => print('New Expanse Added.'));
  }

  Future<void> addMainExpanseType({required List<MainExpanseType> list}) async {
    list.forEach((element) {
      print(element.name);
    });
    await DBConstants()
        .mainExpanseType
        .get()
        .then((value) async => value.docs.forEach((element) async {
              await element.reference.delete();
            }))
        .then((value) => print('All Cleared'));

    await DBConstants()
        .mainExpanseType
        .doc(list[0].name)
        .set(list[0].toJson())
        .then((value) async => await DBConstants()
            .mainExpanseType
            .doc(list[1].name)
            .set(list[1].toJson()))
        .then((value) async => await DBConstants()
            .mainExpanseType
            .doc(list[2].name)
            .set(list[2].toJson()))
        .then((value) async => await DBConstants()
            .mainExpanseType
            .doc(list[3].name)
            .set(list[3].toJson()))
        .then((value) => print('All Main Expanse Added.'));
  }

  Stream<List<ExpanseType>> fetchExpanseTypes() async* {
    List<ExpanseType> list = [];
    Stream<QuerySnapshot> snap = dbConst.expanseType.snapshots();
    // print(snap.docChanges);
    // print(snap.docs.length);
    // print(ExpanseType.fromJson(snap.docs.first.data() as Map<String, dynamic>));
    await for (var doc in snap) {
      expansesTypeList.clear();

      for (var type in doc.docs) {
        var expanseType =
            ExpanseType.fromJson(type.data() as Map<String, dynamic>);
        list.add(expanseType);
      }
      expansesTypeList = list;
      yield expansesTypeList;
      notifyListeners();
    }

    notifyListeners();
  }

  Stream<List<MainExpanseType>> fetchMainExpanseTypes() async* {
    try {
      // var colBook = DBProvider().fetchMainExpanseTypes();
      List<MainExpanseType> list = [];
      Stream<QuerySnapshot> snap = dbConst.mainExpanseType.snapshots();

      await for (var doc in snap) {
        mainExpanseType.clear();

        for (var type in doc.docs.reversed) {
          // await for (var item in colBook) {
          //   item.forEach((element) {
          var expanseType =
              MainExpanseType.fromJson(type.data() as Map<String, dynamic>);
          // if (expanseType.name != element.name) {
          list.add(expanseType);
          // }
          // });
          // }

          // if(colBook.contains(list.any((element) => ele)))

        }
        // //***
        //   var expanseType =
        //       MainExpanseType.fromJson(type.data() as Map<String, dynamic>);
        await DBConstants().mainExpanseType.get().then((value) async {
          var expType = MainExpanseType.fromJson(
              value.docs.first.data() as Map<String, dynamic>);
          list.forEach((element) async {
            if (expType.name == element.name) {
              print(value.docs.first.reference);
              // await value.docs.first.reference.delete();
            }
          });
          // if (expType.name == expanseType.name) {

          // }
        }).then((value) => print('All Cleared'));
        //***
        mainExpanseType = list;
        yield mainExpanseType;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> deleteItem(
      {CollectionReference? collectionReference,
      String? id,
      DocumentReference? documentReference}) async {
    print('trying to delete');
    try {
      if (collectionReference != null && id != null) {
        print('trying to collection delete');
        var items = await collectionReference.get();

        var item = items.docs.firstWhere((element) => element.id == id);
        await item.reference.delete();
        Fluttertoast.showToast(msg: 'Deleted');
        print('collection deleted');
      }
      if (documentReference != null) {
        print('trying to document delete');

        await documentReference.delete();
        print('Document deleted');
      }
    } on FirebaseException catch (e) {
      print(e);
      print('Not deleted ${e.message}');
    }
  }

  ///TODO: BookDetails DB

}
