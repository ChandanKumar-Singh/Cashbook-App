import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_cashbook/DB/CollectionDBProvider.dart';
import 'package:my_cashbook/Models/CollectionEntryModel/CollectionEntryModel.dart';
import 'package:my_cashbook/app/modules/CollectionPage/views/FiltersPage.dart';

import '../../../../Models/BookModel.dart';
import '../../home/100%secure.dart';
import '../../home/views/home_view.dart';
import '../controllers/collection_page_controller.dart';

class CollectionPage extends GetView<CollectionPageController> {
  static const String route = '/COLLECTIONPAGE';

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Get.theme.primaryColor.withOpacity(0.9),
      appBar: AppBar(
        elevation: 1,
        title: Text(controller.book.name),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: () {
                Get.to(TrustedSecure());
              },
              child: Icon(Icons.person_add_alt),
            ),
          ),
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: () {
                Get.toNamed('/dummy');
              },
              child: Icon(Icons.picture_as_pdf_outlined),
            ),
          ),
          SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: () {
                Get.to(TrustedSecure());
              },
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // physics: AlwaysScrollableScrollPhysics(),
          children: [
            StreamBuilder(
              stream: CollectionDBProvider()
                  .fetchExpanseHistory(book: controller.book),
              builder:
                  (context, AsyncSnapshot<List<CollectionEntryModel>> snap) {
                if (snap.data != null) {
                  print(snap.data!.length);
                  List<CollectionEntryModel> entries = snap.data!;
                  int netBalance =0;
                  int totalIn =0;
                  int totalOut =0;
                  for (var element in entries) {
                    if(element.entryType=='Cash Out'){
                      totalOut+=element.amount;
                    }
                    if(element.entryType=='Cash In'){
                      totalIn+=element.amount;
                    }
                    netBalance=totalIn-totalOut;
                    print('${netBalance.sign}  Check for negative or not');
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          color: Get.theme.primaryColor,
                          child: TextFormField(
                            enabled: true,
                            autofocus: false,
                            onTap: () {
                              // Get.to(SearchByBookName(),);
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              hintText: 'Search by remark or amount',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 30,
                        child: ListView(
                          // direction: Axis.horizontal,
                          scrollDirection: Axis.horizontal,
                          // spacing: 10,
                          children: [
                            SizedBox(width: 15),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FiltersPage()));
                              },
                              child: Chip(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0),
                                label: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Icon(
                                          Icons.menu_open,
                                          color: Get.theme.backgroundColor
                                              .withOpacity(1),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                            height: 5,
                                            width: 5,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                backgroundColor: Get.theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                    // side: BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                            SizedBox(width: 15),
                            buildFilterChip(
                              title: 'Select Date',
                              onTap: () {},
                              textColor:
                                  Get.theme.backgroundColor.withOpacity(1),
                              chipColor:
                                  Get.theme.backgroundColor.withOpacity(0.1),
                              selected: true,
                              icon: Icons.calendar_month,
                            ),
                            SizedBox(width: 10),
                            buildFilterChip(
                              title: 'Select Date',
                              onTap: () {},
                              textColor:
                                  Get.theme.backgroundColor.withOpacity(1),
                              chipColor:
                                  Get.theme.backgroundColor.withOpacity(0.1),
                              selected: false,
                            ),
                            SizedBox(width: 10),
                            buildFilterChip(
                              title: 'Select Date',
                              onTap: () {},
                              textColor:
                                  Get.theme.backgroundColor.withOpacity(1),
                              chipColor:
                                  Get.theme.backgroundColor.withOpacity(0.1),
                              selected: true,
                            ),
                            SizedBox(width: 10),
                            buildFilterChip(
                              title: 'Select Date',
                              onTap: () {},
                              textColor:
                                  Get.theme.backgroundColor.withOpacity(1),
                              chipColor:
                                  Get.theme.backgroundColor.withOpacity(0.1),
                              selected: true,
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          // padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            color: Get.theme.cardColor,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Net Balance',
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(fontSize: 15),
                                    ),
                                    Text(
                                      netBalance.sign==1?'+$netBalance':'$netBalance',
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Opening Balance',
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(fontSize: 15),
                                    ),
                                    Text(
                                      '0',
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(
                                              fontSize: 15,
                                              color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total In(+)',
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(fontSize: 15),
                                    ),
                                    Text(
                                      '$totalIn',
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(
                                              fontSize: 15,
                                              color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Out(-)',
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(fontSize: 15),
                                    ),
                                    Text(
                                      '$totalOut',
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(
                                              fontSize: 15, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(TrustedSecure());
                                      },
                                      child: Text(
                                        'View Reports'.toUpperCase(),
                                        style: Get.theme.textTheme.headline6!
                                            .copyWith(
                                          fontSize: 15,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Icon(
                                      Icons.arrow_right,
                                      color: Colors.purple,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(child: Divider()),
                            SizedBox(width: 15),
                            Text('Showing ${entries.length} entries'),
                            SizedBox(width: 15),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      ...entries.map((e) {
                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                // border: Border.all(
                                // color: Colors.black12,
                                // ),
                                color: Get.theme.cardColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              e.partyName ?? '',
                                              style: Get
                                                  .theme.textTheme.headline6!
                                                  .copyWith(
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            Text(
                                              '(Customer)',
                                              style:
                                                  Get.theme.textTheme.caption,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          e.amount.toString(),
                                          style: Get.theme.textTheme.headline6!
                                              .copyWith(
                                                  fontSize: 15,
                                                  color:
                                                      e.entryType == 'Cash In'
                                                          ? Colors.green
                                                          : Colors.red),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          // spacing: 10,
                                          // alignment: WrapAlignment.start,
                                          children: [
                                            if (e.category != null)
                                              buildChip(
                                                  title: e.category!,
                                                  onTap: () {},
                                                  textColor: Colors.purple,
                                                  chipColor: Colors.purple
                                                      .withOpacity(0.3)),
                                            SizedBox(width: 10),
                                            if (e.paymentMode != null)
                                              buildChip(
                                                  title: e.paymentMode!,
                                                  onTap: () {},
                                                  textColor:
                                                      Colors.lightBlueAccent,
                                                  chipColor: Colors
                                                      .lightBlueAccent
                                                      .withOpacity(0.3)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Balance: ',
                                              style: Get
                                                  .theme.textTheme.caption!
                                                  .copyWith(
                                                fontSize: 13,
                                              ),
                                            ),
                                            Builder(builder: (context) {
                                              int balance = 0;
                                              for (var element in entries) {
                                                balance += element.amount;
                                              }
                                              return Text(
                                                '-$balance',
                                                style:
                                                    Get.theme.textTheme.caption,
                                              );
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      e.remark ?? '',
                                      style: Get.theme.textTheme.bodyText1!
                                          .copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.attachment_rounded,
                                            color: Get.theme.backgroundColor),
                                        SizedBox(width: 5),
                                        Text(
                                          'Image',
                                          style: Get.theme.textTheme.bodyText2!
                                              .copyWith(
                                                  fontSize: 14,
                                                  decoration:
                                                      TextDecoration.underline),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Divider(),
                                    Text(
                                      DateFormat.jm()
                                          .format(DateTime.parse(e.createdAt!)),
                                      style: Get.theme.textTheme.bodyText2!
                                          .copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        );
                      }),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Get.theme.cardColor,
                              ),
                              color: Get.theme.cardColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.lock, color: Colors.green),
                                  SizedBox(width: 10),
                                  Text('only you can see these entries.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                    ],
                  );
                } else {
                  return Container(
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Could\'nt fetch Entries'),
                    )),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Get.theme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEntry(
                                entryType: 'Cash In',
                                book: controller.book,
                              )));
                    },
                    color: Color(0xFF048C07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Cash In'.toUpperCase(),
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddEntry(
                                entryType: 'Cash Out',
                                book: controller.book,
                              )));
                    },
                    color: Color(0xFFC90000),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.remove, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Cash Out'.toUpperCase(),
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildChip(
      {IconData? icon,
      required String title,
      required VoidCallback onTap,
      required Color textColor,
      required Color chipColor}) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        avatar: icon != null ? Icon(icon) : null,
        label: Text(
          title,
          style: TextStyle(color: textColor, fontSize: 13),
        ),
        backgroundColor: chipColor,
        shape: RoundedRectangleBorder(
            // side: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget buildFilterChip(
      {IconData? icon,
      required String title,
      required VoidCallback onTap,
      required Color textColor,
      required Color chipColor,
      required bool selected}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              icon != null
                  ? Icon(
                      icon,
                      color: selected ? textColor : Colors.black,
                    )
                  : Container(),
              SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(color: textColor, fontSize: 13),
              ),
              SizedBox(width: 3),
              Icon(Icons.arrow_drop_down,
                  color: selected ? textColor : Colors.black),
            ],
          ),
        ),
        decoration: BoxDecoration(
            border: selected ? Border.all(color: textColor) : null,
            color: chipColor,
            borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}

class AddEntry extends StatefulWidget {
  const AddEntry({Key? key, required this.entryType, required this.book})
      : super(key: key);
  final String entryType;
  final CollectionBook book;

  @override
  State<AddEntry> createState() => _AddEntryState();
}

class _AddEntryState extends State<AddEntry> {
  // String date = DateFormat('dd/MM/yyyy').format(DateTime.now());
  DateTime date = DateTime.now();
  String time = DateFormat.jms().format(DateTime.now());

  TextEditingController amountController = TextEditingController();
  TextEditingController partyController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  String paymentMode = 'cash';
  String image = 'f';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Get.theme.primaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back,
                      color: Get.theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
                SizedBox(width: 20),
                Text(
                  'Add ${widget.entryType.capitalize} Entry',
                  style: TextStyle(
                      color: widget.entryType.capitalize == 'Cash In'
                          ? Color(0xFF047904)
                          : Color(0xFFB00202)),
                ),
              ],
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.settings_outlined,
                    color: Get.theme.backgroundColor.withOpacity(1)))
          ],
        ),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var dateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(Duration(days: 365)),
                          lastDate: DateTime.now().add(Duration(days: 365)));
                      setState(() {
                        date = dateTime!;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month,
                            color: Get.theme.textTheme.headline6!.color),
                        SizedBox(width: 10),
                        Text(DateFormat('dd/MM/yyyy').format(date)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_drop_down,
                            color: Get.theme.textTheme.headline6!.color)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var curDate = DateTime.now();
                      var dt = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: curDate.hour, minute: curDate.minute));
                      setState(() {
                        time = DateFormat.jms().format(DateTime(curDate.year,
                            curDate.month, curDate.day, dt!.hour, dt.minute));
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: Get.theme.textTheme.headline6!.color),
                        SizedBox(width: 10),
                        Text(time),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_drop_down,
                            color: Get.theme.textTheme.headline6!.color)
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              TextFormField(
                style: TextStyle(
                    color: widget.entryType == 'Cash In'
                        ? Colors.green
                        : Colors.red),
                keyboardType: TextInputType.number,
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount*',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                readOnly: true,
                controller: partyController,
                decoration: InputDecoration(
                  hintText: 'Party Name(Contact)',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: remarkController,
                decoration: InputDecoration(
                  hintText: 'Remark(Item,Person Name,Quality...)',
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mic,
                          color: Get.theme.backgroundColor.withOpacity(1))),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      height: 40,
                      width: Get.width / 2.5,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                color:
                                    Get.theme.backgroundColor.withOpacity(1)),
                            SizedBox(width: 10),
                            Text('Attach Image',
                                style: TextStyle(
                                    color: Get.theme.backgroundColor
                                        .withOpacity(1))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  if (image.isNotEmpty)
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                                  'dfeohe/dljejfo/dhfh.png'.split('/').last)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  image = '';
                                });
                              },
                              icon: Icon(Icons.clear, color: Colors.red)),
                        ],
                      ),
                    )
                ],
              ),
              SizedBox(height: 30),
              TextFormField(
                readOnly: true,
                controller: categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
              SizedBox(height: 30),
              Text('Payment Mode',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  buildChip(
                      title: 'Cash',
                      onTap: () {},
                      textColor: Get.theme.backgroundColor.withOpacity(1),
                      chipColor: Get.theme.backgroundColor.withOpacity(0.1)),
                  buildChip(
                      title: 'Online',
                      onTap: () {},
                      textColor: Colors.white,
                      chipColor: Get.theme.backgroundColor.withOpacity(1)),
                  SizedBox(width: 10),
                  FlatButton(
                      onPressed: () {},
                      child: Container(
                        width: 90,
                        child: Row(
                          children: [
                            Text('Show More',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Get.theme.backgroundColor
                                        .withOpacity(1))),
                            Icon(Icons.arrow_drop_down,
                                color: Get.theme.backgroundColor.withOpacity(1))
                          ],
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ElevatedButton(
          onPressed: () async {
            print(amountController.text);
            var entryModel = CollectionEntryModel(
                amount: int.parse(amountController.text),
                partyName: Contact(givenName: 'Chandan Kumar Singh').toString(),
                remark: remarkController.text,
                category: categoryController.text,
                image: image,
                entryType: widget.entryType,
                paymentMode: paymentMode,
                updatedAt: DateTime.now().toString(),
                createdAt: DateTime.now().toString());
            await CollectionDBProvider()
                .addExpanseHistory(entryModel: entryModel, book: widget.book)
                .then((value) => Get.back());
          },
          child: Text('SAVE'),
        ),
      ),
    );
  }
}







