import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_cashbook/app/modules/home/controllers/home_controller.dart';
import 'package:my_cashbook/app/modules/home/views/home_view.dart';

import '../../../Constants/bookMoreOptions.dart';
import '../../../Models/BookModel.dart';
import '../../../Theme/AppInfo.dart';
import '../CollectionPage/views/collection_page.dart';
import '../ContactPage.dart';

class SearchByBookName extends StatefulWidget {
  SearchByBookName({Key? key}) : super(key: key);
  static const String route = '/SearchByBookName';

  var books = Get.arguments;
  @override
  State<SearchByBookName> createState() => _SearchByBookNameState();
}

class _SearchByBookNameState extends State<SearchByBookName> {
  List<CollectionBook> books = [];
  List<CollectionBook> booksBySearch = [];
  List<Map<IconData?, String>> chipList = [
    {null: 'All'},
    {Icons.book: 'Private'},
    {Icons.group: 'Group'},
  ];
  int selectedChip = 0;
  bool isSearching = false;
  String query = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // books = Get.arguments;
    books = widget.books;
    print(books.length);
  }

  List<CollectionBook> setBook({required String query}) {
    List<CollectionBook> newBooks = [];
    if (query.isEmpty) {
      newBooks = selectedChip == 0
          ? books
          : selectedChip == 1
              ? books
                  .where((element) => element.bookType == 'Private Book')
                  .toList()
              : books
                  .where((element) => element.bookType == 'Group Book')
                  .toList();
    } else if (query.isNotEmpty) {
      newBooks = selectedChip == 0
          ? books
              .where((element) =>
                  element.name.toLowerCase().contains(query.toLowerCase()))
              .toList()
          : selectedChip == 1
              ? books
                  .where((element) =>
                      element.bookType == 'Private Book' &&
                      element.name.toLowerCase().contains(query.toLowerCase()))
                  .toList()
              : books
                  .where((element) =>
                      element.bookType == 'Group Book' &&
                      element.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
    } else {
      newBooks = books
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return newBooks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          enabled: true,
          autofocus: true,
          controller: searchController,
          onChanged: (val) {
            setState(() {
              query = val;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by book name',
            hintStyle: TextStyle(color: Get.theme.primaryColor),
          ),
          style: TextStyle(color: Get.theme.primaryColor),
          cursorColor: Color(AppInfo.appLightColorSchemeCode),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ...chipList.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedChip = chipList.indexOf(e);
                          // isSearching=false;
                        });
                        print('Selected Chip : $selectedChip');
                      },
                      child: Chip(
                          avatar: e.keys.first != null
                              ? Icon(e.keys.first,
                                  color: selectedChip == chipList.indexOf(e)
                                      ? Get.theme.backgroundColor
                                          .withOpacity(0.7)
                                      : Colors.grey.withOpacity(0.7))
                              : null,
                          label: Text(
                            e.values.first,
                            style: TextStyle(
                                color: selectedChip == chipList.indexOf(e)
                                    ? Get.theme.backgroundColor.withOpacity(0.7)
                                    : Colors.grey.withOpacity(0.7)),
                          ),
                          backgroundColor: selectedChip == chipList.indexOf(e)
                              ? Get.theme.backgroundColor.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
                          side: BorderSide(
                              color: selectedChip == chipList.indexOf(e)
                                  ? Get.theme.backgroundColor.withOpacity(0.7)
                                  : Colors.grey.withOpacity(0.7))),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: setBook(query: query).length,
              itemBuilder: (context, i) {
                var time = DateTime.parse(setBook(query: query)[i].updatedAt)
                    .difference(DateTime.now());
                // print('difference: $time');
                // print('difference: ${time.inDays}');

                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Get.toNamed(CollectionPage.route,
                            arguments: setBook(query: query)[i]);
                        // Get.delete<HomeController>();
                      },
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.book,
                          color: Color(AppInfo.appLightColorSchemeCode),
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    setBook(query: query)[i].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                    style: Get.theme.textTheme.headline6!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    'Updated ${decideTimeBefore(time)}',
                                    style: Get.theme.textTheme.caption!
                                        .copyWith(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            setBook(query: query)[i].total != null
                                ? setBook(query: query)[i].total.toString()
                                : 0.toString(),
                            style: Get.theme.textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        itemBuilder: (context) {
                          return [
                            ...bookMoreOptions.map(
                              (ele) => PopupMenuItem(
                                child: InkWell(
                                  onTap: () async {
                                    Get.back();
                                    if (ele.title == 'Rename') {
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return RenameBook(
                                              book: setBook(query: query)[i],
                                              books: books,
                                            );
                                          });
                                    }
                                    if (ele.title == 'Add Member') {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return ContactsPage();
                                      }));
                                      // Get.to(ContactsPage());
                                    }
                                    if (ele.title == 'Delete') {
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return DeleteBook(
                                                book: setBook(query: query)[i],
                                                controller:
                                                    Get.put(HomeController()));
                                          });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(ele.icon),
                                      SizedBox(width: 20),
                                      Text(ele.title),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    if (setBook(query: query)
                            .indexOf(setBook(query: query)[i]) !=
                        setBook(query: query).length - 1)
                      Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
