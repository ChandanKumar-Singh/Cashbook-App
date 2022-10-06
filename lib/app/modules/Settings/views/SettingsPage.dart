import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_cashbook/Theme/AppInfo.dart';
import 'package:my_cashbook/app/modules/Settings/controllers/SettingsPageController.dart';
import 'package:my_cashbook/app/modules/home/controllers/home_controller.dart';
import 'package:provider/provider.dart';

import '../../../../Theme/LanguageProvider/LanguageProvider.dart';
import '../../../../Theme/ThemeProvider/ThemeProvider.dart';

class SettingsPage extends GetView<HomeController> {
  SettingsPage({Key? key}) : super(key: key);
  static const String route = '/SettingsPage';
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.shadowColor.withOpacity(0.1),
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          ///deleting account
          if (!deleting)
            ListTile(
              tileColor: Color(0xFFBD0101),
              trailing: RaisedButton(
                  color: Colors.white,
                  onPressed: () {},
                  child: Text(
                    'Cancel Request',
                    style: Get.theme.textTheme.caption!.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8C0202)),
                  )),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Account deletion is in process',
                      style: Get.theme.textTheme.headline6!
                          .copyWith(fontSize: 15, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Delete Time: 26 Sep 2022, 9:34 pm',
                      style: Get.theme.textTheme.bodyText1!
                          .copyWith(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

          ListTile(
            tileColor: Get.theme.primaryColor,
            leading: CircleAvatar(
              child: Text(
                'C',
                style:
                    TextStyle(color: Get.theme.backgroundColor.withOpacity(1)),
              ),
            ),
            trailing: Icon(Icons.edit),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.userModel.name,
                    style: Get.theme.textTheme.headline6,
                  ),
                  SizedBox(height: 10),
                  Text(
                    controller.userModel.number,
                    style: Get.theme.textTheme.bodyText1,
                  ),
                  SizedBox(height: 20),
                  controller.userModel.email.toString().toUpperCase() ==
                          null.toString().toUpperCase()
                      ? FlatButton(
                          onPressed: () {},
                          child: Text(
                            'ADD EMAIL',
                            style: TextStyle(
                                color: Get.theme.backgroundColor.withOpacity(1),
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Text(
                          '${controller.userModel.email}',
                          style: Get.theme.textTheme.bodyText1,
                        ),
                ],
              ),
            ),
          ),

          ///Account information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Account Information',
              style: Get.theme.textTheme.bodyText2,
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.account_circle_outlined,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  trailing: Text('Select', style: Get.theme.textTheme.caption),
                  title: Row(
                    children: [
                      Text('Account Type'),
                      SizedBox(width: 7),
                      Text(
                        '🔴',
                        style: Get.theme.textTheme.bodyText2!
                            .copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.business_sharp,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.keyboard_arrow_right_rounded)),
                  title: Row(
                    children: [
                      Text('Business Details'),
                      SizedBox(width: 7),
                      Text(
                        '🔴',
                        style: Get.theme.textTheme.bodyText2!
                            .copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.credit_card,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Row(
                    children: [
                      Text('Business Card'),
                      SizedBox(width: 7),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 8),
                          child: Text(
                            'New',
                            style: Get.theme.textTheme.bodyText2!
                                .copyWith(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Settings',
              style: Get.theme.textTheme.bodyText2,
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.lock_outline_rounded,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  trailing: Obx(() {
                    return Switch(
                        value: controller.appLockEnabled.value,
                        onChanged: (val) {
                          controller.toogleAppLock(true, context);
                        });
                  }),
                  title: Text('App Lock'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.notification_add_outlined,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  trailing: Switch(
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (val) {
                        Provider.of<ThemeManager>(context, listen: false)
                            .toogleTheme(val);
                      }),
                  title: Text('Notification Widget'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.notifications_none,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  trailing: Switch(
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (val) {
                        Provider.of<ThemeManager>(context, listen: false)
                            .toogleTheme(val);
                      }),
                  title: Text('Group Book Notification'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
                ListTile(
                  onTap: () async {
                    double bottomCorner = 15;
                    await showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(bottomCorner),
                                topRight: Radius.circular(bottomCorner))),
                        context: context,
                        builder: (context) => ShowLangaugeBottomSheet());
                  },
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.language,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  trailing: Consumer<LanguageProvider>(builder: (context, lang, child) {
                      return Text(
                        lang.previouslySelectedlangauage
                              .name,
                          style: Get.theme.textTheme.caption);
                    }
                  ),
                  title: Text('Change Language'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.model_training_rounded,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  trailing: Switch(
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (val) {
                        Provider.of<ThemeManager>(context, listen: false)
                            .toogleTheme(val);
                      }),
                  title: Text('Dark Mode'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.calculate_outlined,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  trailing: Switch(
                      value: Theme.of(context).brightness == Brightness.dark,
                      onChanged: (val) {
                        Provider.of<ThemeManager>(context, listen: false)
                            .toogleTheme(val);
                      }),
                  title: Text('Account Field Calculator'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.cloud_upload_outlined,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Data Backup'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
              ],
            ),
          ),

          ///others
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Account Information',
              style: Get.theme.textTheme.bodyText2,
            ),
          ),
          Container(
            color: Get.theme.primaryColor,
            child: Column(
              children: [
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.share,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  title: Text('Invite a Friend'),
                ),
                Container(
                    width: Get.width,
                    height: 1,
                    color:
                        Get.theme.textTheme.bodyText2!.color!.withOpacity(0.1)),
                ListTile(
                  tileColor: Get.theme.primaryColor,
                  leading: Icon(
                    Icons.laptop_outlined,
                    color: Get.theme.backgroundColor.withOpacity(1),
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.keyboard_arrow_right_rounded)),
                  title: Text('CashBook For Desktop/PC'),
                ),
              ],
            ),
          ),

          ///Hot actions
          SizedBox(height: 10),
          ListTile(
            onTap: () async {
              await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout?'),
                  content: Text(
                    'Are you sure you want to logout? You can login with the same number again to see your data.',
                    style: Get.theme.textTheme.caption,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: RaisedButton(
                              // style:ButtonStyle(shape:MaterialStateProperty.all(MaterialStateOutlinedBorder()) ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    color: Get.theme.backgroundColor
                                        .withOpacity(1)),
                              ),

                              onPressed: () async {
                                await controller.logOut();
                              },

                              child: Text(
                                'Yes, Logout'.toUpperCase(),
                                style: TextStyle(
                                    color: Get.theme.backgroundColor
                                        .withOpacity(1)),
                              ),
                              color: Get.theme.primaryColor,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 10,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text('No'.toUpperCase()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            tileColor: Get.theme.primaryColor,
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            tileColor: Get.theme.primaryColor,
            leading: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            title: Text(
              'Delete Account',
              style: TextStyle(color: Colors.red),
            ),
          ),

          ///footers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              'Our Promise',
              style: Get.theme.textTheme.bodyText2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(Icons.security,
                            size: 13, color: Colors.green.withOpacity(1)),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withOpacity(0.2)),
                    ),
                    Text(
                      '   100 % Safe & Free',
                      style: Get.theme.textTheme.bodyText2,
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Row(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(Icons.cloud_done,
                            size: 13,
                            color: Color(AppInfo.appLightColorSchemeCode)
                                .withOpacity(1)),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(AppInfo.appLightColorSchemeCode)
                              .withOpacity(0.2)),
                    ),
                    Text(
                      '   Auto Data Backup',
                      style: Get.theme.textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Row(
              children: [
                Text(
                  'App Version 1.0.0',
                  style: Get.theme.textTheme.bodyText2,
                ),
                SizedBox(width: 20),
                FlatButton(
                    onPressed: () {},
                    child: Text(
                      'Privacy',
                      style: Get.theme.textTheme.bodyText2!.copyWith(
                          color: Color(AppInfo.appLightColorSchemeCode)),
                    )),
                FlatButton(
                    onPressed: () {},
                    child: Text(
                      'T&C',
                      style: Get.theme.textTheme.bodyText2!.copyWith(
                          color: Color(AppInfo.appLightColorSchemeCode)),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
