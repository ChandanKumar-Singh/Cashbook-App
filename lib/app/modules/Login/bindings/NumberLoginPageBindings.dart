import 'package:get/get.dart';

import '../controllers/NumberLoginPageController.dart';

class NumberLoginPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NumberLoginPageController>(
      () => NumberLoginPageController(),
    );
  }
}
