class UserModel {
  String name, number,uid,createdAt;
  String? email, businessName, accountType;
  UserModel(
      {required this.name,
      required this.number,
      required this.uid,
      required this.createdAt,
      this.email,
      this.businessName,
      this.accountType});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      name: json['name'],
      number: json['number'],
      email: json['email'],
      uid: json['uid'],
      createdAt: json['createdAt'],
      businessName: json['businessName'],
      accountType: json['account_Type']);
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['number'] = number;
    data['email'] = email;
    data['uid'] = uid;
    data['createdAt'] = createdAt;
    data['businessName'] = businessName;
    data['account_Type'] = accountType;

    return data;
  }
}
