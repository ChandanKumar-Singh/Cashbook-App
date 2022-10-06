class ExpanseHistory {
  String partyName;
  String bookName;
  int inOut;
  int? amount;
  String? bookType;
  String? remark;
  String? image;
  String? category;
  String? paymentMode;

  String createdAt;
  String updatedAt;

  ExpanseHistory(
      {required this.partyName,
      required this.bookName,
      this.amount,
      required this.bookType,
      required this.updatedAt,
      required this.inOut,
      this.remark,
      this.image,
      this.category,
      this.paymentMode,
      required this.createdAt});

  factory ExpanseHistory.fromJson(Map<String, dynamic> json) => ExpanseHistory(
      partyName: json['partyName'],
      bookName: json['bookName'],
      remark: json['remark'],
      inOut: json['inOut'],
      image: json['image'],
      category: json['category'],
      paymentMode: json['paymentMode'],
      amount: json['amount'],
      bookType: json['bookType'],
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
      'bookType': bookType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
