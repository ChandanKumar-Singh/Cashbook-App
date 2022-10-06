import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:my_cashbook/Constants/bookMoreOptions.dart';

import 'package:my_cashbook/Models/BookModel.dart';
import 'package:my_cashbook/Theme/AppInfo.dart';
import 'package:my_cashbook/app/modules/CollectionPage/views/collection_page.dart';
import 'package:my_cashbook/app/modules/Help/HelpPage.dart';
import 'package:my_cashbook/app/modules/Settings/views/SettingsPage.dart';
import 'package:my_cashbook/app/modules/home/SearchByBookName.dart';
import 'package:duration_button/duration_button.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../DB/DBConstants.dart';
import '../../../../DB/HomeDBProvider.dart';
import '../../../../Models/ExpanceType.dart';
import '../../../../Models/UserModel.dart';
import '../../ContactPage.dart';
import '../100%secure.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  static const String route = '/home';
  Future<bool> goBack(BuildContext context) async {
    if (controller.currentBottomIndex.value != 0) {
      controller.currentBottomIndex.value = 0;

      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(HomeController());
    // return Scaffold(appBar: AppBar(title: Text(controller.currentBottomIndex.value.toString()),),);
    return WillPopScope(
      onWillPop: () async {
        var willBack = await goBack(context);
        print(willBack);
        return willBack;
      },
      child: Obx(() {
        return Scaffold(
          body: controller.currentBottomIndex.value == 0
              ? CashBookTab()
              : controller.currentBottomIndex.value == 1
                  ? HelpPage()
                  : SettingsPage(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          // floatingActionButton: controller.currentBottomIndex.value == 0
          //     ? BuildAddNewBookFloatingButton()
          //     : Container(),
          bottomNavigationBar: BuildHomeBottomBar(controller: controller),
        );
      }),
    );
  }
}

class BuildAddNewBookFloatingButton extends StatefulWidget {
  const BuildAddNewBookFloatingButton(
      {Key? key,
      this.bookName,
      required this.addCollectionBook,
      required this.books})
      : super(key: key);
  final String? bookName;
  final void Function({CollectionBook? book, bool? isFromExpanseType})
      addCollectionBook;
  final List<CollectionBook> books;

  @override
  State<BuildAddNewBookFloatingButton> createState() =>
      _BuildAddNewBookFloatingButtonState();
}

class _BuildAddNewBookFloatingButtonState
    extends State<BuildAddNewBookFloatingButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        print('Add New Book');
        await showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddNewBook(
                books: widget.books,
                addCollectionBook: (
                    {CollectionBook? book, bool? isFromExpanseType}) async {
                  widget.addCollectionBook(
                      book: book, isFromExpanseType: isFromExpanseType);
                },
              );
            });
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            text: '',
            children: [
              TextSpan(
                text: '+',
                style: TextStyle(fontSize: 22),
              ),
              TextSpan(
                text: '  Add New Book',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildHomeBottomBar extends StatelessWidget {
  const BuildHomeBottomBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return BottomNavigationBar(
        currentIndex: controller.currentBottomIndex.value,
        onTap: (index) {
          controller.currentBottomIndex.value = index;
          print(controller.currentBottomIndex.value);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Cashbooks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.help_outline), label: 'Help'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
        selectedItemColor: Color(AppInfo.appLightColorSchemeCode),
      );
    });
  }
}

class CashBookTab extends StatefulWidget {
  CashBookTab({Key? key}) : super(key: key);

  @override
  State<CashBookTab> createState() => _CashBookTabState();
}

class _CashBookTabState extends State<CashBookTab>
    with SingleTickerProviderStateMixin {
  HomeController controller = Get.put(HomeController());
  UserModel? users;
  SharedPreferences? prefs;
  List<ExpanseType> expansesTypeList = [];
  List<MainExpanseType> mainExpanseType = [];
  List<CollectionBook> collectionBooksList = [];

  String batteryLevel = 'Battery Level';
  String sortBy = 'updatedAt';
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController scrollController = ScrollController();
  late AnimationController animationController;
  late Animation animation;
  bool desc = false;

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    setState(() {});
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<void> addCollectionBook(
      {CollectionBook? book, bool? isFromExpanseType}) async {
    prefs = await SharedPreferences.getInstance();
    users = UserModel.fromJson(jsonDecode(prefs!.getString('user')!));
    print(
        '==================DBProvider user initiated========== ${users!.name}');
    // Get.back();

    await DBConstants()
        .collectionBook(userId: users!.number, bookCollectionName: 'books')
        .doc(book!.createdAt)
        .set(book.toJson())
        .then((value) => print('Book Added.'))
        .then((value) async {
      if (isFromExpanseType!) {
        await DBConstants()
            .mainExpanseType
            .doc(book.name)
            .update({'used': true});
        print('Expanse also deleted');
      }
    });
    print(collectionBooksList);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    var ani =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animation = Tween<double>(begin: 0, end: 1).animate(ani);
    animation.addListener(() {
      setState(() {});
    });
    scrollController.addListener(() {
      // print(scrollController.offset);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    var theme = Get.theme;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Cashbooks'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: () {
                Get.to(TrustedSecure());
              },
              child: Row(
                children: [
                  Icon(Icons.security_rounded,color: Colors.green),
                  // Image.asset(
                  //   'assets/icons/trusted.png',
                  //   width: s.width * 0.07,
                  // ),
                  SizedBox(width: 5),
                  Text('100%\nSecure'),
                ],
              ),
            ),
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          // addAutomaticKeepAlives: false,
          controller: scrollController,
          children: [
            StreamBuilder(
              stream: DBProvider()
                  .fetchCollectionBooks(sortBy: sortBy, desc: desc)
                  .asBroadcastStream(),
              builder: (context, AsyncSnapshot<List<CollectionBook>> snap) {
                if (snap.data != null) {
                  print(scrollController.position.pixels);
                  var books = snap.data!;
                  return Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 10),
                            child: Obx(() {
                              print(controller.searchFocusNode.value.hasFocus);
                              return Stack(
                                children: [
                                  TextFormField(
                                    enabled: true,
                                    autofocus: false,
                                    readOnly: true,
                                    focusNode: controller.searchFocusNode.value,
                                    onTap: () {
                                      Get.toNamed(SearchByBookName.route,
                                          arguments: books);
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: theme.backgroundColor)),
                                      hintText: 'Search by book name',
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    child: Obx(
                                      () {
                                        return Container(
                                          width: Get.width * 0.3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // Spacer(),
                                              AnimatedBuilder(
                                                  animation:
                                                      animationController,
                                                  builder: (context, _) {
                                                    print(
                                                        'animation value:  ${animationController.value}');
                                                    return Transform.rotate(
                                                      angle: pi *
                                                          animationController
                                                              .value,
                                                      child: Transform.rotate(
                                                        angle: pi / 2,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              desc = !desc;
                                                            });
                                                            desc
                                                                ? animationController
                                                                    .reverse()
                                                                : animationController
                                                                    .forward();
                                                          },
                                                          icon: Icon(
                                                              Icons
                                                                  .compare_arrows_rounded,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                              Stack(
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      print('filter');
                                                      await showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return FilterBook(
                                                              controller:
                                                                  controller,
                                                              sortByValue:
                                                                  sortBy,
                                                              sortBy: (val) {
                                                                setState(() {
                                                                  sortBy = val;
                                                                });
                                                              },
                                                            );
                                                          });
                                                    },
                                                    icon: Icon(
                                                        Icons.sort_rounded,
                                                        color: Colors.black),
                                                  ),
                                                  if (controller.previousSortBy
                                                          .value !=
                                                      'updatedAt')
                                                    Positioned(
                                                      right: 12,
                                                      top: 12,
                                                      child: Container(
                                                        height: 7,
                                                        width: 7,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Get.theme
                                                              .backgroundColor
                                                              .withOpacity(1),
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                          ...snap.data!.map(
                            (e) {
                              var time = DateTime.parse(e.updatedAt)
                                  .difference(DateTime.now());
                              // print('difference: $time');
                              // print('difference: ${time.inDays}');
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Get.toNamed(CollectionPage.route,
                                          arguments: e);
                                      // Get.delete<HomeController>();
                                    },
                                    leading: CircleAvatar(
                                      child: Icon(
                                        Icons.book,
                                        color: Color(
                                            AppInfo.appLightColorSchemeCode),
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.name,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.fade,
                                                  style: Get.theme.textTheme
                                                      .headline6!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                ),
                                                SizedBox(height: 7),
                                                Text(
                                                  'Updated ${decideTimeBefore(time)}',
                                                  style: Get
                                                      .theme.textTheme.caption!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Text(
                                          e.total != null
                                              ? e.total.toString()
                                              : 0.toString(),
                                          style: Get.theme.textTheme.caption!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    trailing: PopupMenuButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7)),
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
                                                            book: e,
                                                            books: books,
                                                          );
                                                        });
                                                  }
                                                  if (ele.title ==
                                                      'Add Member') {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return ContactsPage();
                                                    }));
                                                    // Get.to(ContactsPage());
                                                  }
                                                  if (ele.title == 'Delete') {
                                                    await showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return DeleteBook(
                                                              book: e,
                                                              controller:
                                                                  controller);
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
                                  if (snap.data!.indexOf(e) !=
                                      snap.data!.length - 1)
                                    Divider(),
                                ],
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Add New Group Book',
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: Get
                                                  .theme.textTheme.headline6!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15),
                                            ),
                                            Text(
                                              'Create groups just like WhatsApp',
                                              maxLines: 2,
                                              overflow: TextOverflow.fade,
                                              style: Get
                                                  .theme.textTheme.headline6!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        CircleAvatar(
                                          child: Icon(
                                            Icons.person_add_alt_1_rounded,
                                            color: Color(AppInfo
                                                .appLightColorSchemeCode),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    StreamBuilder(
                                      stream: DBProvider()
                                          .fetchMainExpanseTypes()
                                          .asBroadcastStream(),
                                      builder: (context,
                                          AsyncSnapshot<List<MainExpanseType>>
                                              snap) {
                                        if (snap.data != null) {
                                          List<MainExpanseType> expanse = [];
                                          var list = snap.data!
                                              .where((element) =>
                                                  element.used != true)
                                              .toList(growable: true);
                                          for (var element in list) {
                                            if (books.any((book) =>
                                                book.name == element.name)) {
                                            } else {
                                              expanse.add(element);
                                            }
                                            // for (var book in books) {
                                            //   if (element.name != book.name) {
                                            //     expanse.add(element);
                                            //   }
                                            // }
                                          }
                                          print(expanse.length);

                                          // expanse.toList().removeWhere((ele) {
                                          //   return DBProvider().collectionBooksList.contains(
                                          //       DBProvider().collectionBooksList.firstWhere(
                                          //           (element) => ele.name == element.name));
                                          // // });
                                          return Wrap(
                                            spacing: 5,
                                            children: [
                                              if (expanse.isEmpty)
                                                IconButton(
                                                    onPressed: () async {
                                                      var list = controller
                                                          .refreshMainExpanseList(
                                                              expanse.toList());
                                                      await DBProvider()
                                                          .addMainExpanseType(
                                                              list: list);
                                                    },
                                                    icon: Icon(
                                                      Icons.refresh,
                                                      color: Get
                                                          .theme.backgroundColor
                                                          .withOpacity(1),
                                                    )),
                                              ...expanse.map(
                                                (ele) => buildChip(
                                                    title: ele.name,
                                                    onTap: () async {
                                                      print(ele);
                                                      await showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return AddNewBook(
                                                              books: books,
                                                              bookName:
                                                                  ele.name,
                                                              addCollectionBook: (
                                                                  {CollectionBook?
                                                                      book,
                                                                  bool?
                                                                      isFromExpanseType}) async {
                                                                await addCollectionBook(
                                                                    book: book,
                                                                    isFromExpanseType:
                                                                        isFromExpanseType);
                                                              },
                                                            );
                                                          });
                                                    },
                                                    textColor: Get
                                                        .theme.backgroundColor
                                                        .withOpacity(1),
                                                    chipColor: Get
                                                        .theme.backgroundColor
                                                        .withOpacity(0.1)),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Container(
                                            child: Center(
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Get New Chips'),
                                                IconButton(
                                                    onPressed: () async {
                                                      var list = controller
                                                          .refreshMainExpanseList(
                                                              []);
                                                      await DBProvider()
                                                          .addMainExpanseType(
                                                              list: list);
                                                    },
                                                    icon: Icon(
                                                      Icons.refresh,
                                                      color: Get
                                                          .theme.backgroundColor
                                                          .withOpacity(1),
                                                    )),
                                                Opacity(
                                                  opacity: 0,
                                                  child: DurationButton(
                                                    duration: const Duration(
                                                        milliseconds: 1),
                                                    onPressed: () {},
                                                    backgroundColor: Get
                                                        .theme.backgroundColor,
                                                    splashFactory:
                                                        NoSplash.splashFactory,
                                                    onComplete: () async {
                                                      var list = controller
                                                          .refreshMainExpanseList(
                                                              []);
                                                      await DBProvider()
                                                          .addMainExpanseType(
                                                              list: list);
                                                    },
                                                    child: const Text(
                                                        "Duration Button"),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          );
                                        }
                                      },
                                    ),
                                    Text(
                                      'People maintaining Group Books show reduction in cash less by 33%',
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                      style: Get.theme.textTheme.headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: Get.height * 0.7,
                        right: 20,
                        child: BuildAddNewBookFloatingButton(
                          books: books,
                          addCollectionBook: (
                              {CollectionBook? book,
                              bool? isFromExpanseType}) async {
                            await addCollectionBook(
                                book: book,
                                isFromExpanseType: isFromExpanseType);
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Couldn\'t fetch Cashbok'),
                    )),
                  );
                }
              },
            ),


          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Cashbooks'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: InkWell(
              onTap: () {
                Get.to(TrustedSecure());
              },
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/trusted.png',
                    width: s.width * 0.07,
                  ),
                  Text('100%\nSecure'),
                ],
              ),
            ),
          )
        ],
      ),
      /*
      body: ListView(
        // addAutomaticKeepAlives: false,
        children: [
          StreamBuilder(
            stream: DBProvider()
                .fetchCollectionBooks(sortBy: sortBy, desc: desc)
                .asBroadcastStream(),
            builder: (context, AsyncSnapshot<List<CollectionBook>> snap) {
              if (snap.data != null) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() {
                        print(controller.searchFocusNode.value.hasFocus);
                        return TextFormField(
                          enabled: true,
                          autofocus: false,
                          readOnly: true,
                          focusNode: controller.searchFocusNode.value,
                          onTap: () {
                            Get.toNamed(SearchByBookName.route);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: Obx(() {
                              return Stack(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      print('filter');
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return FilterBook(
                                              controller: controller,
                                              sortByValue: sortBy,
                                              sortBy: (val) {
                                                setState(() {
                                                  sortBy = val;
                                                });
                                              },
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.filter_alt_off_rounded),
                                  ),
                                  if (controller.previousSortBy.value != 'lu')
                                    Positioned(
                                      right: 12,
                                      top: 12,
                                      child: Container(
                                        height: 7,
                                        width: 7,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Get.theme.backgroundColor
                                              .withOpacity(1),
                                        ),
                                      ),
                                    )
                                ],
                              );
                            }),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: theme.backgroundColor)),
                            hintText: 'Search by book name',
                          ),
                        );
                      }),
                    ),
                    ...snap.data!.map(
                      (e) {
                        var time = DateTime.parse(e.createdAt)
                            .difference(DateTime.now());
                        // print('difference: $time');
                        // print('difference: ${time.inDays}');
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Get.toNamed(CollectionPage.route, arguments: e);
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: Get
                                                .theme.textTheme.headline6!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                            'Updated ${decideTimeBefore(time)}',
                                            style: Get.theme.textTheme.caption!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    e.total != null
                                        ? e.total.toString()
                                        : 0.toString(),
                                    style: Get.theme.textTheme.caption!
                                        .copyWith(
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
                                                    return RenameBook(book: e);
                                                  });
                                            }
                                            if (ele.title == 'Add Member') {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return ContactsPage();
                                              }));
                                              // Get.to(ContactsPage());
                                            }
                                            if (ele.title == 'Delete') {
                                              await showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return DeleteBook(
                                                        book: e,
                                                        controller: controller);
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
                            if (snap.data!.indexOf(e) != snap.data!.length - 1)
                              Divider(),
                          ],
                        );
                      },
                    ),
                  ],
                );
              } else {
                return Container(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Couldn\'t fetch Cashbok'),
                  )),
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.black12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Group Book',
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: Get.theme.textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              'Create groups just like WhatsApp',
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: Get.theme.textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.normal, fontSize: 13),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          child: Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Color(AppInfo.appLightColorSchemeCode),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    StreamBuilder(
                      stream: DBProvider()
                          .fetchMainExpanseTypes()
                          .asBroadcastStream(),
                      builder:
                          (context, AsyncSnapshot<List<MainExpanseType>> snap) {
                        if (snap.data != null) {
                          var expanse = snap.data!
                              .where((element) => element.used != true);
                          // expanse.toList().removeWhere((ele) {
                          //   return DBProvider().collectionBooksList.contains(
                          //       DBProvider().collectionBooksList.firstWhere(
                          //           (element) => ele.name == element.name));
                          // // });
                          return Wrap(
                            spacing: 5,
                            children: [
                              if (expanse.isEmpty)
                                IconButton(
                                    onPressed: () async {
                                      var list =
                                          controller.refreshMainExpanseList(
                                              expanse.toList());
                                      await DBProvider()
                                          .addMainExpanseType(list: list);
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Get.theme.backgroundColor
                                          .withOpacity(1),
                                    )),
                              ...expanse.map(
                                (e) => buildChip(
                                    title: e.name,
                                    onTap: () async {
                                      print(e);
                                      await showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return AddNewBook(
                                              bookName: e.name,
                                            );
                                          });
                                    },
                                    textColor: Get.theme.backgroundColor
                                        .withOpacity(1),
                                    chipColor: Get.theme.backgroundColor
                                        .withOpacity(0.1)),
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Get New Chips'),
                                DurationButton(
                                  duration: const Duration(milliseconds: 1),
                                  onPressed: () {},
                                  backgroundColor: Get.theme.backgroundColor,
                                  splashFactory: NoSplash.splashFactory,
                                  onComplete: () async {
                                    var list =
                                        controller.refreshMainExpanseList([]);
                                    await DBProvider()
                                        .addMainExpanseType(list: list);
                                  },
                                  child: const Text("Duration Button"),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      var list =
                                          controller.refreshMainExpanseList([]);
                                      await DBProvider()
                                          .addMainExpanseType(list: list);
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Get.theme.backgroundColor
                                          .withOpacity(1),
                                    )),
                              ],
                            )),
                          );
                        }
                      },
                    ),
                    Text(
                      'People maintaining Group Books show reduction in cash less by 33%',
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: Get.theme.textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.normal, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          /*
              SizedBox(
                height: 300,
                child: Obx(() {
                  return ListView.builder(
                      itemCount: controller.collectionLength.value.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            ListTile(
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
                                            'My 1st Book',
                                            maxLines: 2,
                                            overflow: TextOverflow.fade,
                                            style: Get.theme.textTheme.headline6!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                            'Updated 1 hour ago',
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
                                    '-4750',
                                    style: Get.theme.textTheme.caption!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.more_vert),
                              ),
                            ),
                            SizedBox(height: 10),
                            if(i!=controller.collectionLength.value.length-1)
                              Divider(),
                          ],
                        );
                      });
                }),
              ),

               */
          /*
          RaisedButton(
            child: Text("Set locale to German"),
            onPressed: () {
              print('German');
              Provider.of<LanguageProvider>(context,listen: false).toogleLocale(Locale('hi'));
              // MyApp.of(context)!
              //     .setLocale(Locale.fromSubtags(languageCode: 'de'));
            },
          ),

           */
        ],
      ),
      */
    );
  }
}

class FilterBook extends StatefulWidget {
  const FilterBook(
      {Key? key,
      required this.controller,
      required this.sortBy,
      required this.sortByValue})
      : super(key: key);
  final HomeController controller;
  final void Function(String sortBy) sortBy;
  final String sortByValue;

  @override
  State<FilterBook> createState() => _FilterBookState();
}

class _FilterBookState extends State<FilterBook>
    with SingleTickerProviderStateMixin {
  String type = 'Private Book';
  String sortByValue = 'Private Book';
  late AnimationController animationController;
  late HomeController controller;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    controller = widget.controller;
    sortByValue = controller.previousSortBy.value;
    controller.sortBy.value = controller.previousSortBy.value;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Get.theme;
    return BottomSheet(
      enableDrag: true,
      animationController: animationController,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.clear, color: Colors.black)),
                    SizedBox(width: 10),
                    Text('Sort Books By', style: Get.theme.textTheme.headline6),
                  ],
                ),
              ),
              Divider(thickness: 1),
              ...controller.sortByList.entries.map(
                (e) => Obx(() {
                  print(controller.sortBy.value);
                  return RadioListTile<String>(
                    value: e.key,
                    groupValue: controller.sortBy.value,
                    title: Text(e.value),
                    onChanged: (String? value) {
                      controller.sortBy.value = value!;
                      print(
                          'controller.sortBy.value  ${controller.sortBy.value} ');
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Obx(() {
                  return RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: controller.sortBy.value !=
                            controller.previousSortBy.value
                        ? () {
                            controller.previousSortBy.value =
                                controller.sortBy.value;
                            widget.sortBy(controller.previousSortBy.value);
                            Navigator.of(context).pop();
                            print('save');
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Apply', style: TextStyle(fontSize: 25)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
      onClosing: () {},
    );
  }
}

class AddNewBook extends StatefulWidget {
  const AddNewBook(
      {Key? key,
      this.bookName,
      required this.addCollectionBook,
      required this.books})
      : super(key: key);
  final List<CollectionBook> books;
  final String? bookName;
  final void Function({CollectionBook? book, bool? isFromExpanseType})
      addCollectionBook;

  @override
  State<AddNewBook> createState() => _AddNewBookState();
}

class _AddNewBookState extends State<AddNewBook>
    with SingleTickerProviderStateMixin {
  String type = 'Private Book';
  late AnimationController animationController;
  TextEditingController bookNameController = TextEditingController();
  bool isFromExpanseType = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    if (widget.bookName != null) {
      bookNameController.text = widget.bookName!;
      isFromExpanseType = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Get.theme;
    return BottomSheet(
      enableDrag: true,
      animationController: animationController,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: Get.height * 0.8,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.clear, color: Colors.black)),
                      SizedBox(width: 10),
                      Text('Add New Book',
                          style: Get.theme.textTheme.headline6),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: bookNameController,
                    enabled: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: theme.backgroundColor)),
                      hintText: 'Enter Book Name',
                    ),
                  ),
                ),
                Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.start,
                  children: [
                    ...['Private Book', 'Group Book'].map(
                      (e) => buildChip(
                        icon: Icons.book,
                        title: e,
                        onTap: () {
                          setState(() {
                            type = e;
                          });
                        },
                        textColor: type == e
                            ? Get.theme.backgroundColor.withOpacity(1)
                            : Colors.grey,
                        chipColor: type == e
                            ? Get.theme.backgroundColor.withOpacity(0.1)
                            : Colors.grey[100]!,
                        selected: type == e,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Note - Only you will have access to private book.',
                          style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () async {
                      var book = CollectionBook(
                        name: bookNameController.text,
                        bookType: type,
                        createdAt: DateTime.now().toString(),
                        updatedAt: DateTime.now().toString(),
                      );
                      if (widget.books.any((element) =>
                          element.name == bookNameController.text)) {
                        Fluttertoast.showToast(msg: 'Book name already exist.');
                      } else {
                        Navigator.of(context).pop();

                        widget.addCollectionBook(
                            book: book, isFromExpanseType: isFromExpanseType);
                        print('save');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Save', style: TextStyle(fontSize: 25)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onClosing: () {},
    );
    ;
  }

  InkWell buildChip(
      {IconData? icon,
      required String title,
      required VoidCallback onTap,
      required Color textColor,
      required Color chipColor,
      required bool selected}) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        avatar: icon != null
            ? Icon(
                icon,
                color: selected
                    ? Get.theme.backgroundColor.withOpacity(1)
                    : Colors.grey,
              )
            : null,
        label: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: chipColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black12),
            borderRadius: BorderRadius.circular(50)),
      ),
    );
  }
}

class RenameBook extends StatefulWidget {
  const RenameBook({Key? key, this.book, required this.books})
      : super(key: key);
  final CollectionBook? book;
  final List<CollectionBook> books;

  @override
  State<RenameBook> createState() => _RenameBookState();
}

class _RenameBookState extends State<RenameBook>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  TextEditingController bookNameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    if (widget.book!.name != null) {
      bookNameController.text = widget.book!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Get.theme;
    return BottomSheet(
      enableDrag: true,
      animationController: animationController,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: Get.height * 0.8,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.clear, color: Colors.black)),
                      SizedBox(width: 10),
                      Text('Rename CashBook',
                          style: Get.theme.textTheme.headline6),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: bookNameController,
                    enabled: true,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: theme.backgroundColor)),
                      hintText: 'Enter Book Name',
                    ),
                    onChanged: (val) {
                      setState(() {
                        // bookNameController.text=val;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: widget.books.any((element) =>
                            element.name == bookNameController.text)
                        ? null
                        : () async {
                            var book = CollectionBook(
                              name: bookNameController.text,
                              bookType: widget.book!.bookType,
                              createdAt: widget.book!.createdAt,
                              updatedAt: DateTime.now().toString(),
                            );
                            // if(widget.books.any((element) => element.name==bookNameController.text)){
                            //   Fluttertoast.showToast(msg: 'Book name already exist.');
                            // }else{
                            Navigator.of(context).pop();

                            await DBProvider().renameCollectionBook(book: book);
                            print('save');
                            // }
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Save', style: TextStyle(fontSize: 25)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onClosing: () {},
    );
  }
}

class DeleteBook extends StatefulWidget {
  const DeleteBook({Key? key, required this.book, required this.controller})
      : super(key: key);
  final CollectionBook book;
  final HomeController controller;

  @override
  State<DeleteBook> createState() => _DeleteBookState();
}

class _DeleteBookState extends State<DeleteBook>
    with SingleTickerProviderStateMixin {
  late CollectionBook book;
  late AnimationController animationController;
  late HomeController controller;
  TextEditingController bookNameController = TextEditingController();

  double height = 0;
  var val = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance.window.viewInsets,
      WidgetsBinding.instance.window.devicePixelRatio);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    book = widget.book;
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Get.theme;
    print(height);
    return BottomSheet(
      enableDrag: true,
      animationController: animationController,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: Get.height * 0.7,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.clear, color: Colors.black)),
                      SizedBox(width: 10),
                      Text('Delete CashBook',
                          style: Get.theme.textTheme.headline6),
                    ],
                  ),
                ),
                Divider(thickness: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(7)),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_rounded,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                'Are you sure? You will lose all entries of this book permanently'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: 'Please type ',
                              style: theme.textTheme.bodyText2,
                              children: [
                            TextSpan(
                                text: book.name,
                                style: theme.textTheme.bodyText1!.copyWith(
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w600)),
                            TextSpan(
                                text: ' to confirm',
                                style: theme.textTheme.bodyText2!
                                    .copyWith(decoration: TextDecoration.none)),
                          ])),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: TextFormField(
                    controller: bookNameController,
                    enabled: true,
                    autofocus: true,
                    onChanged: (val) {
                      setState(() {
                        height = Get.height * 0.7;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: theme.backgroundColor)),
                      hintText: 'Book Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10),
                  child: RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: book.name == bookNameController.text
                        ? () async {
                            Navigator.of(context).pop();
                            await DBProvider().deleteItem(
                                id: book.createdAt,
                                collectionReference: DBConstants()
                                    .collectionBook(
                                        userId: controller.userModel.number,
                                        bookCollectionName: 'books'));

                            print('Deleted');
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Delete',
                              style: TextStyle(
                                fontSize: 25,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onClosing: () {},
    );
  }
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
      avatar: icon != null ? Icon(icon) : null,
      label: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: chipColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(50)),
    ),
  );
}

String decideTimeBefore(Duration duration) {
  var t = '';

  if (duration.inDays != 0) {
    t = '${duration.inDays.abs()} days ago';
  } else if (duration.inHours != 0) {
    t = '${duration.inHours.abs()} hours ago';
  } else if (duration.inMinutes != 0) {
    t = '${duration.inMinutes.abs()} minutes ago';
  } else if (duration.inSeconds != 0) {
    t = '${duration.inSeconds.abs()} seconds ago';
  } else {
    t = 'just now';
  }
  return t;
}
