import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AddMember extends StatefulWidget {
  const AddMember({Key? key}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Members'),
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
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListView.builder(
                  itemCount: 13,
                  itemBuilder: (context, i) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Contacts',
                          style: Get.theme.textTheme.caption!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
