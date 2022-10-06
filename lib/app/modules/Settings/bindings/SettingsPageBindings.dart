import 'package:get/get.dart';

import '../controllers/SettingsPageController.dart';

class SettingsPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsPageController>(
      () => SettingsPageController(),
    );
  }
}
