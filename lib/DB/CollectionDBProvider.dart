import 'dart:convert';


import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:my_cashbook/DB/DBConstants.dart";
import "package:my_cashbook/Models/BookModel.dart";
import "package:my_cashbook/Models/CollectionEntryModel/CollectionEntryModel.dart";
import "package:my_cashbook/Models/UserModel.dart";
import "package:shared_preferences/shared_preferences.dart";

class CollectionDBProvider extends ChangeNotifier {
  String tag = "CollectionDBProvider";
  late SharedPreferences prefs;
  DBConstants dbConst = DBConstants();
  UserModel? users;

  Map<String, Map<String, List>> filters = {
    "Date": {"All Time": []},
    "Entry Type": {"All": []},
    "Party": {"Party": []},
    "embers": {"Members": []},
    "ategory": {"Category": []},
    "Payment Mode": {"Payment Mode": []}
  };

  Future<void> addExpanseHistory(
      {required CollectionEntryModel entryModel,
      required CollectionBook book}) async {
    prefs = await SharedPreferences.getInstance();
    users = UserModel.fromJson(jsonDecode(prefs.getString("user")!));
    print("==================$tag user initiated========== ${users!.name}");
    // Get.back();

    await DBConstants()
        .collectionBook(userId: users!.number, bookCollectionName: "books")
        .doc(book.createdAt)
        .collection("expanses")
        .doc(DateTime.now().toString())
        .set(entryModel.toJson())
        .then((value) => print("Entry Added."))
        .then((value) async {
      // if (isFromExpanseType) {
      //   await DBConstants()
      //       .mainExpanseType
      //       .doc(expanseName.name)
      //       .update({"used": true});
      //   print("Expanse also deleted");
      // }
    });
  }

  Stream<List<CollectionEntryModel>> fetchExpanseHistory(
      {required CollectionBook book}) async* {
    prefs = await SharedPreferences.getInstance();
    users = UserModel.fromJson(jsonDecode(prefs.getString("user")!));
    print("==================$tag user initiated========== ${users!.name}");
    List<CollectionEntryModel> list = [];
    Stream<QuerySnapshot> snap = dbConst
        .expanseHistory(
            userId: users!.number,
            bookCollectionName: "books",
            bookName: book.createdAt,
            detailsCollectionName: "expanses")
        .orderBy("createdAt", descending: true)
        .snapshots();

    await for (var doc in snap) {
      list.clear();

      for (var type in doc.docs) {
        var expanse =
            CollectionEntryModel.fromJson(type.data() as Map<String, dynamic>);
        list.add(expanse);
        print("Entry : ${expanse.toJson()}");
        notifyListeners();
      }
      int netBalance = 0;
      int totalIn = 0;
      int totalOut = 0;
      for (var element in list) {
        if (element.entryType == "Cash Out") {
          totalOut += element.amount;
        }
        if (element.entryType == "Cash In") {
          totalIn += element.amount;
        }
        netBalance = totalIn - totalOut;
        print("${netBalance.sign}  Check for negative or not");
      }
      await dbConst
          .collectionBook(userId: users!.number, bookCollectionName: "books")
          .doc(book.createdAt)
          .update({"total": netBalance});

      yield list;
      notifyListeners();
    }

    notifyListeners();
  }
}
