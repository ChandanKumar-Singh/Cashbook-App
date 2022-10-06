import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_cashbook/app/modules/home/controllers/home_controller.dart';

class HelpPage extends GetView<HomeController> {
  HelpPage({Key? key}) : super(key: key);
  static const String route = '/HelpPage';
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.shadowColor.withOpacity(0.1),
      appBar: AppBar(
        title: Text('Help & Support'),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),

          ///Basics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Basics',
              style: Get.theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    // color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Account Type?'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),

          ///Backup
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Backup',
              style: Get.theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    // color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Account Type?'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),

          ///Entry Field
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Entry Field',
              style: Get.theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    // color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Account Type?'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),

          ///Opening Balance
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Opening Balance',
              style: Get.theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    // color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Account Type?'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),

          ///Filters
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Filters',
              style: Get.theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    // color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Account Type?'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),

          ///Reports
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Reports',
              style: Get.theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    // color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Account Type?'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),

          ///Search
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Search',
              style: Get.theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    // color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Account Type?'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),

          ///Group Books
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Group Books',
              style: Get.theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    // color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Account Type?'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),

          ///Desktop/PC
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Desktop/PC',
              style: Get.theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  trailing: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    // color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Account Type?'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
