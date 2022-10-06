class ExpanseType {
  String name;
  bool used;
  String createdAt;
  ExpanseType(
      {required this.name, required this.used, required this.createdAt});

  factory ExpanseType.fromJson(Map<String, dynamic> json) => ExpanseType(
      name: json['name'], used: json['used'], createdAt: json['createdAt']);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'used': used,
      'createdAt': createdAt,
    };
  }
}

class MainExpanseType {
  String name;
  bool? used;
  String createdAt;
  MainExpanseType(
      {required this.name,  this.used, required this.createdAt});

  factory MainExpanseType.fromJson(Map<String, dynamic> json) =>
      MainExpanseType(
          name: json['name'], used: json['used'], createdAt: json['createdAt']);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'used': used,
      'createdAt': createdAt,
    };
  }
}
