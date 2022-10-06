import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_cashbook/app/modules/Login/controllers/NumberLoginPageController.dart';

class UserInfoInitialization extends GetView<NumberLoginPageController> {
  const UserInfoInitialization({Key? key}) : super(key: key);
  static const String route = '/UserInfoInitialization';

  @override
  Widget build(BuildContext context) {
    print(controller.verfId.value);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Initialization'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                readOnly: false,
                controller: controller.userNameController.value,
                decoration: InputDecoration(
                  labelText: 'Enter Your Name',

                  border: OutlineInputBorder(borderSide: BorderSide()),
                  // hintText: 'Enter Your Name',
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Obx(() {
                print(controller.phoneCode.value);
                return TextFormField(
                  readOnly: false,
                  controller: controller.businessNameController.value,
                  decoration: InputDecoration(
                    labelText: 'Business Name (Optional)',
                    // hintText: 'Business Name (Optional)',
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                onPressed: !controller.loading.value
                    ? () async {
                        if (controller
                            .userNameController.value.text.isNotEmpty) {
                          controller.initiateUser(
                            name: controller.userNameController.value.text,
                            number:
                                '+${controller.phoneCode.value}${controller.numberController.value.text}',
                            businessName:
                                controller.businessNameController.value.text,
                            uid: controller.uid.value,
                          );
                        } else {
                          Get.snackbar(
                              'Initialization Error', 'Please enter your name');
                        }
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.loading.value)
                      Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator()),
                    SizedBox(width: 10),
                    Text('Get Started'),
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
