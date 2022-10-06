import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({Key? key}) : super(key: key);

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  List<String> filtersName = [
    'Date',
    'Entry Type',
    'Party',
    'Members',
    'Category',
    'Payment\nMode',
  ];
  int filtesSelection = 0;
  FilterCategories filterCategories = FilterCategories(
    dateSelections: {
      true: Dates(date: [DateTime.now()])
    },
    entrytypes: {
      true: EntryType(entryType: [0, 1])
    },
    parties: {
      true: Party(parties: [Contact(givenName: 'CKS')], noParty: true)
    },
    members: {true: Member(member: Contact(givenName: 'CKS'))},
    categories: {
      true: Categories(categories: ['Food'], noCategory: true)
    },
    paymentModes: {
      true:
          PaymentMode(paymentMode: ['Cash In', 'Cash Out'], noPaymentMode: true)
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              // color: Colors.lightGreen,
              height: Get.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...filtersName.map(
                      (e) => GestureDetector(
                        onTap: () {
                          print('hiiiii');
                          setState(() {
                            filtesSelection = filtersName.indexOf(e);
                          });
                          print(filtesSelection);
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: Get.width * 4 / 11,
                              color: filtesSelection == filtersName.indexOf(e)
                                  ? Get.theme.backgroundColor.withOpacity(0.1)
                                  : Colors.transparent,
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Center(
                                          child: Text(e,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: filtesSelection ==
                                                          filtersName.indexOf(e)
                                                      ? Get
                                                          .theme.backgroundColor
                                                          .withOpacity(1)
                                                      : null)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      child: Container(
                                        width: 5,
                                        height: 60,
                                        color: filtesSelection ==
                                                filtersName.indexOf(e)
                                            ? Get.theme.backgroundColor
                                                .withOpacity(1)
                                            : null,
                                        // child: Column(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(height: Get.height, width: 2, color: Colors.black12),
          Expanded(
            flex: 7,
            child: filtesSelection == 0
                ? DatePage()
                : filtesSelection == 1
                    ? EntryPage()
                    : filtesSelection == 2
                        ? PartyPage()
                        : filtesSelection == 3
                            ? MembersPage()
                            : filtesSelection == 4
                                ? CategoryPage()
                                : filtesSelection == 5
                                    ? PaymentModePage()
                                    : Container(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: Get.height * 0.1,
        // color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: Get.width, height: 1, color: Colors.black12),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10),
                      Text('Clear All'),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text('Apply'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}

class DatePage extends StatefulWidget {
  const DatePage({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  int dateSelection = 0;
  List<String> dates = [
    'All Time',
    'Today',
    'Yesterday',
    'This Month',
    'last Month',
    'Single Day',
    'Date Range',
  ];
  String selectedDate = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = dates.first;
  }

  @override
  Widget build(BuildContext context) {
    // print(dates.length);
    // print('------------------------');
    return Container(
      // color: Colors.green,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...dates.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: RadioListTile(
                  onChanged: (val) {
                    setState(() {
                      dateSelection = dates.indexOf(e);
                      selectedDate = dates[dateSelection];
                    });
                    print('dateSelection');
                    print(selectedDate);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  tileColor: dateSelection == dates.indexOf(e)
                      ? Get.theme.backgroundColor.withOpacity(0.1)
                      : Colors.transparent,
                  value: dateSelection == dates.indexOf(e) ? true : false,
                  groupValue: true,
                  title: Text(e),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntryPage extends StatefulWidget {
  const EntryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  int entrySelection = 0;
  List<String> entryTypes = [
    'All',
    'Cash In',
    'Cash Out',
  ];
  String entryType = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    entryType = entryTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    // print(dates.length);
    // print('------------------------');
    return Container(
      // color: Colors.green,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...entryTypes.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: RadioListTile(
                  onChanged: (val) {
                    setState(() {
                      entrySelection = entryTypes.indexOf(e);
                      entryType = entryTypes[entrySelection];
                    });
                    print('dateSelection');
                    print(entryType);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  tileColor: entrySelection == entryTypes.indexOf(e)
                      ? Get.theme.backgroundColor.withOpacity(0.1)
                      : Colors.transparent,
                  value: entrySelection == entryTypes.indexOf(e) ? true : false,
                  groupValue: true,
                  title: Text(e),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PartyPage extends StatefulWidget {
  const PartyPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PartyPage> createState() => _PartyPageState();
}

class _PartyPageState extends State<PartyPage> {
  int partySelection = 0;
  List<String> entryTypes = [
    'Sumit Sharma',
    'Chandan Kumar Singh',
  ];
  String party = '';
  bool noParty = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    party = entryTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    // print(dates.length);
    // print('------------------------');
    return Container(
      // color: Colors.green,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      contentPadding: EdgeInsets.all(0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text('Entries with'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: CheckboxListTile(
                value: noParty,
                tristate: true,
                onChanged: (val) {
                  setState(() {
                    noParty = !noParty;
                  });
                  print('noParty');
                  print(noParty);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                tileColor: noParty
                    ? Get.theme.backgroundColor.withOpacity(0.1)
                    : Colors.transparent,
                title: Text('No Party'),
              ),
            ),
            Divider(),
            ...entryTypes.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: CheckboxListTile(
                  onChanged: (val) {
                    setState(() {
                      partySelection = entryTypes.indexOf(e);
                      party = entryTypes[partySelection];
                    });
                    print('dateSelection');
                    print(party);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  tileColor: partySelection == entryTypes.indexOf(e)
                      ? Get.theme.backgroundColor.withOpacity(0.1)
                      : Colors.transparent,
                  value: partySelection == entryTypes.indexOf(e) ? true : false,
                  title: Text(e),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MembersPage extends StatefulWidget {
  const MembersPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  int memberSelection = 0;
  List<String> members = [
    'Sumit Sharma',
    'Chandan Kumar Singh',
  ];
  String member = '';
  // bool noParty = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    member = members.first;
  }

  @override
  Widget build(BuildContext context) {
    // print(dates.length);
    // print('------------------------');
    return Container(
      // color: Colors.green,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      contentPadding: EdgeInsets.all(0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text('Entries by'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding:const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            //   child: CheckboxListTile(
            //     value: noParty,
            //     tristate: true,
            //     onChanged: (val) {
            //       setState(() {
            //         noParty = !noParty;
            //       });
            //       print('noParty');
            //       print(noParty);
            //     },
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(5)),
            //     tileColor: noParty
            //         ? Get.theme.backgroundColor.withOpacity(0.1)
            //         : Colors.transparent,
            //     title: Text('No Party'),
            //   ),
            // ),
            // Divider(),
            ...members.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: RadioListTile(
                  onChanged: (val) {
                    setState(() {
                      memberSelection = members.indexOf(e);
                      member = members[memberSelection];
                    });
                    print('dateSelection');
                    print(member);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  tileColor: memberSelection == members.indexOf(e)
                      ? Get.theme.backgroundColor.withOpacity(0.1)
                      : Colors.transparent,
                  value: memberSelection == members.indexOf(e) ? true : false,
                  title: Text(e),
                  groupValue: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int categorySelection = 0;
  List<String> categories = [
    'Food',
    'Groceries',
  ];
  String category = '';
  bool noCategory = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = categories.first;
  }

  @override
  Widget build(BuildContext context) {
    // print(dates.length);
    // print('------------------------');
    return Container(
      // color: Colors.green,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      contentPadding: EdgeInsets.all(0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text('Entries with'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: CheckboxListTile(
                value: noCategory,
                tristate: true,
                onChanged: (val) {
                  setState(() {
                    noCategory = !noCategory;
                  });
                  print('noParty');
                  print(noCategory);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                tileColor: noCategory
                    ? Get.theme.backgroundColor.withOpacity(0.1)
                    : Colors.transparent,
                title: Text('No Category'),
              ),
            ),
            Divider(),
            ...categories.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: CheckboxListTile(
                  onChanged: (val) {
                    setState(() {
                      categorySelection = categories.indexOf(e);
                      category = categories[categorySelection];
                    });
                    print('dateSelection');
                    print(category);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  tileColor: categorySelection == categories.indexOf(e)
                      ? Get.theme.backgroundColor.withOpacity(0.1)
                      : Colors.transparent,
                  value:
                      categorySelection == categories.indexOf(e) ? true : false,
                  title: Text(e),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentModePage extends StatefulWidget {
  const PaymentModePage({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentModePage> createState() => _PaymentModePageState();
}

class _PaymentModePageState extends State<PaymentModePage> {
  int paymentModeSelection = 0;
  List<String> paymentModes = [
    'Cash',
    'Online',
  ];
  String paymentMode = '';
  bool noPaymentMode = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentMode = paymentModes.first;
  }

  @override
  Widget build(BuildContext context) {
    // print(dates.length);
    // print('------------------------');
    return Container(
      // color: Colors.green,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                      contentPadding: EdgeInsets.all(0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text('Entries with'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: CheckboxListTile(
                value: noPaymentMode,
                tristate: true,
                onChanged: (val) {
                  setState(() {
                    noPaymentMode = !noPaymentMode;
                  });
                  print('noParty');
                  print(noPaymentMode);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                tileColor: noPaymentMode
                    ? Get.theme.backgroundColor.withOpacity(0.1)
                    : Colors.transparent,
                title: Text('No Payment Mode'),
              ),
            ),
            Divider(),
            ...paymentModes.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                child: CheckboxListTile(
                  onChanged: (val) {
                    setState(() {
                      paymentModeSelection = paymentModes.indexOf(e);
                      paymentMode = paymentModes[paymentModeSelection];
                    });
                    print('dateSelection');
                    print(paymentMode);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  tileColor: paymentModeSelection == paymentModes.indexOf(e)
                      ? Get.theme.backgroundColor.withOpacity(0.1)
                      : Colors.transparent,
                  value: paymentModeSelection == paymentModes.indexOf(e)
                      ? true
                      : false,
                  title: Text(e),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class Filters {
//   List<FilterCategories> categories;
//   Filters({required this.categories});
// }

class FilterCategories {
  Map<bool, Dates> dateSelections;
  Map<bool, EntryType> entrytypes;
  Map<bool, Party> parties;
  Map<bool, Member> members;
  Map<bool, Categories> categories;
  Map<bool, PaymentMode> paymentModes;

  FilterCategories(
      {required this.dateSelections,
      required this.entrytypes,
      required this.parties,
      required this.members,
      required this.categories,
      required this.paymentModes});
}

class DateSelection {
  List<Dates> dates;
  DateSelection({required this.dates});
}

class Dates {
  List<DateTime> date;
  Dates({required this.date});
}

class EntryType {
  List<int> entryType;
  EntryType({required this.entryType});
}

class Party {
  bool noParty;
  List<Contact> parties;
  Party({required this.noParty, required this.parties});
}

class Member {
  Contact member;
  Member({required this.member});
}

class Categories {
  bool noCategory;
  List<String> categories;
  Categories({required this.categories, required this.noCategory});
}

class PaymentMode {
  bool noPaymentMode;
  List<String> paymentMode;
  PaymentMode({required this.paymentMode, required this.noPaymentMode});
}
