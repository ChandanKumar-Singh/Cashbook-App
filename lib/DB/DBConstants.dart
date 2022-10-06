import 'package:cloud_firestore/cloud_firestore.dart';

class DBConstants {
  CollectionReference expanseType =
      FirebaseFirestore.instance.collection('expanseType');
  CollectionReference mainExpanseType =
      FirebaseFirestore.instance.collection('mainExpanseType');
  CollectionReference collectionBook(
          {required String userId, required String bookCollectionName}) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(bookCollectionName);
  CollectionReference expanseHistory(
          {required String userId,
          required String bookCollectionName,
          required String bookName,
          required String detailsCollectionName}) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(bookCollectionName)
          .doc(bookName)
          .collection(detailsCollectionName);

}
