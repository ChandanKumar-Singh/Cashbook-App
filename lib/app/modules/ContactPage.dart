import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:contacts_service/contacts_service.dart';

class SeeContactsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () async {
        final PermissionStatus permissionStatus = await _getPermission();
        if (permissionStatus == PermissionStatus.granted) {
          //We can now access our contacts here
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Text('Permissions error'),
                    content: Text('Please enable contacts access '
                        'permission in system settings'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ));
        }
      },
      child: Container(child: Text('See Contacts')),
    );
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }
}

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];
  Future<bool> checkPermission() async {
    final PermissionStatus? permissionStatus = await _getPermission();
    print('permissionStatus :$permissionStatus');
    if (permissionStatus == PermissionStatus.granted) {
      //We can now access our contacts here
      return true;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text('Permissions error'),
                content: Text('Please enable contacts access '
                    'permission in system settings'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
      return false;
    }
  }

  Future<PermissionStatus?> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts];
    } else {
      await [Permission.contacts].request();
      return permission;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<Contact>?> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    var permission = await checkPermission();
    print('permission : $permission');
    if (permission) {
      final List<Contact> contacts =
          await ContactsService.getContacts(photoHighResolution: false);
      // setState(() {
      return contacts;
      // });
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: (Text('Choose Members')),
        ),
        body: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search contacts',
                  border: InputBorder.none),
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.person_add_alt,
                  color: Get.theme.backgroundColor.withOpacity(1),
                ),
              ),
              title: Text(
                'Add Members manually',
                style: Get.theme.textTheme.bodyText1,
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Get.theme.backgroundColor.withOpacity(1),
              ),
            ),
            Divider(),
            Expanded(
              child: FutureBuilder<List<Contact>?>(
                  future: getContacts(),
                  builder: (context, AsyncSnapshot<List<Contact>?> snap) {
                    if (snap.hasError) {
                      return Center(child: Text('Error'));
                    } else {
                      // print(snap.data);
                      if (snap.data != null) {
                        print(snap.data);
                        var _contacts = snap.data!;
                        print(_contacts.length);
                        _contacts.removeWhere((element) =>
                            element.displayName.toString() == null.toString());
                        return ListView.builder(
                          itemCount: _contacts.length,
                          itemBuilder: (BuildContext context, int index) {
                            Contact? contact;

                            print(_contacts.elementAt(index).displayName);
                            contact = _contacts.elementAt(index);

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 18),
                              leading: (contact.avatar != null &&
                                      contact.avatar!.isNotEmpty)
                                  ? CircleAvatar(
                                      backgroundColor: Get.theme.backgroundColor
                                          .withOpacity(0.3),
                                      backgroundImage:
                                          MemoryImage(contact.avatar!),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Get.theme.backgroundColor
                                          .withOpacity(0.3),

                                      child: Text(
                                        contact.initials(),
                                        style: TextStyle(
                                            color: Get.theme.backgroundColor
                                                .withOpacity(1)),
                                      ),
                                      // backgroundColor:
                                      //     Theme.of(context).accentColor,
                                    ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(contact.displayName != null
                                      ? '${contact.displayName}'
                                      : ''),
                                  Text(
                                    contact.androidAccountName ?? '',
                                    style: Get.theme.textTheme.caption,
                                  ),
                                ],
                              ),
                              trailing: TextButton(
                                onPressed: () {},
                                child: Text(
                                  'INVITE',
                                  style: TextStyle(
                                    color: Get.theme.backgroundColor
                                        .withOpacity(01),
                                  ),
                                ),
                              ),
                              //This can be further expanded to showing contacts detail
                              // onPressed().
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }
                  }),
            ),
          ],
        )
        // : Center(child: const CircularProgressIndicator()),
        );
  }
}
