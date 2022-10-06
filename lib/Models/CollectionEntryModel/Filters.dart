// class Filters {
//   Date? date;
//   EntryType? entryType;
//   Party? party;
//   Members? members;
//   Category? category;
//   PaymentMode? paymentMode;
//
//   Filters(
//       {this.date,
//         this.entryType,
//         this.party,
//         this.members,
//         this.category,
//         this.paymentMode});
//
//   Filters.fromJson(Map<String, dynamic> json) {
//     date = json['Date'] != null ?  Date.fromJson(json['Date']) : null;
//     entryType = json['Entry Type'] != null
//         ?  EntryType.fromJson(json['Entry Type'])
//         : null;
//     party = json['Party'] != null ?  Party.fromJson(json['Party']) : null;
//     members =
//     json['Members'] != null ?  Members.fromJson(json['Members']) : null;
//     category = json['Category'] != null
//         ?  Category.fromJson(json['Category'])
//         : null;
//     paymentMode = json['Payment Mode'] != null
//         ?  PaymentMode.fromJson(json['Payment Mode'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     if (this.date != null) {
//       data['Date'] = this.date!.toJson();
//     }
//     if (this.entryType != null) {
//       data['Entry Type'] = this.entryType!.toJson();
//     }
//     if (this.party != null) {
//       data['Party'] = this.party!.toJson();
//     }
//     if (this.members != null) {
//       data['Members'] = this.members!.toJson();
//     }
//     if (this.category != null) {
//       data['Category'] = this.category!.toJson();
//     }
//     if (this.paymentMode != null) {
//       data['Payment Mode'] = this.paymentMode!.toJson();
//     }
//     return data;
//   }
// }
//
// class Date {
//   List<Null>? allTime;
//
//   Date({this.allTime});
//
//   Date.fromJson(Map<String, dynamic> json) {
//     if (json['All Time'] != null) {
//       allTime = <Null>[];
//       json['All Time'].forEach((v) {
//         allTime!.add( Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     if (this.allTime != null) {
//       data['All Time'] = this.allTime!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class EntryType {
//   List<Null>? entryType;
//
//   EntryType({this.entryType});
//
//   EntryType.fromJson(Map<String, dynamic> json) {
//     if (json['Entry Type'] != null) {
//       entryType = <Null>[];
//       json['Entry Type'].forEach((v) {
//         entryType!.add( Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     if (this.entryType != null) {
//       data['Entry Type'] = this.entryType!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Party {
//   List<Null>? party;
//
//   Party({this.party});
//
//   Party.fromJson(Map<String, dynamic> json) {
//     if (json['Party'] != null) {
//       party = <Null>[];
//       json['Party'].forEach((v) {
//         party!.add( Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     if (this.party != null) {
//       data['Party'] = this.party!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Members {
//   List<Null>? members;
//
//   Members({this.members});
//
//   Members.fromJson(Map<String, dynamic> json) {
//     if (json['Members'] != null) {
//       members = <Null>[];
//       json['Members'].forEach((v) {
//         members!.add( Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     if (this.members != null) {
//       data['Members'] = this.members!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Category {
//   List<Null>? category;
//
//   Category({this.category});
//
//   Category.fromJson(Map<String, dynamic> json) {
//     if (json['Category'] != null) {
//       category = <Null>[];
//       json['Category'].forEach((v) {
//         category!.add( Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     if (this.category != null) {
//       data['Category'] = this.category!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class PaymentMode {
//   List<Null>? paymentMode;
//
//   PaymentMode({this.paymentMode});
//
//   PaymentMode.fromJson(Map<String, dynamic> json) {
//     if (json['Payment Mode'] != null) {
//       paymentMode = <Null>[];
//       json['Payment Mode'].forEach((v) {
//         paymentMode!.add( Null.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     if (this.paymentMode != null) {
//       data['Payment Mode'] = this.paymentMode!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }