import 'package:get/get.dart';

import '../controllers/collection_page_controller.dart';

class CollectionPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollectionPageController>(
      () => CollectionPageController(),
    );
  }
}
