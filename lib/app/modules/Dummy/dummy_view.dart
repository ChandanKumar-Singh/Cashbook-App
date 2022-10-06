import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_cashbook/app/modules/Dummy/dummyController.dart';

class DummyPage extends GetView<DummmyController> {
  const DummyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(controller.count.value.toString());
    return Scaffold(
      appBar: AppBar(title: Obx(
              () {
          return Text(controller.count.value.toString());
        }
      ),),
    );
  }
}
