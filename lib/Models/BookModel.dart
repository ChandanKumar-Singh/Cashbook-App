class CollectionBook {
  String name;
  int? total;
  String bookType;
  String createdAt;
  String updatedAt;

  CollectionBook(
      {required this.name,
      this.total,
      required this.bookType,
      required this.updatedAt,
      required this.createdAt});

  factory CollectionBook.fromJson(Map<String, dynamic> json) => CollectionBook(
      name: json['name'],
      total: json['total'],
      bookType: json['bookType'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt']);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'total': total,
      'bookType': bookType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
