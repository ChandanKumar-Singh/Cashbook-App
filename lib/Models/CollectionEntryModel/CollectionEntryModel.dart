import 'package:contacts_service/contacts_service.dart';

class CollectionEntryModel {
  String? partyName;
  String? bookName;
  int? inOut;
  int amount;
  String entryType;
  String? remark;
  String? image;
  String? category;
  String? paymentMode;

  String? createdAt;
  String updatedAt;

  CollectionEntryModel({
    this.partyName,
    this.bookName,
    required this.amount,
    required this.entryType,
    required this.updatedAt,
    this.inOut,
    this.remark,
    this.image,
    this.category,
    this.paymentMode,
    this.createdAt,
  });

  factory CollectionEntryModel.fromJson(Map<String, dynamic> json) =>
      CollectionEntryModel(
          partyName: json['partyName'],
          bookName: json['bookName'],
          remark: json['remark'],
          inOut: json['inOut'],
          image: json['image'],
          category: json['category'],
          paymentMode: json['paymentMode'],
          amount: json['amount'],
          entryType: json['bookType'],
          createdAt: json['createdAt'],
          updatedAt: json['updatedAt']);

  Map<String, dynamic> toJson() {
    return {
      'partyName': partyName,
      'bookName': bookName,
      'inOut': inOut,
      'amount': amount,
      'remark': remark,
      'image': image,
      'category': category,
      'paymentMode': paymentMode,
      'bookType': entryType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
