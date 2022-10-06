import 'package:get/get.dart';
import 'package:my_cashbook/app/modules/Dummy/dummyController.dart';

class DummyBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<DummmyController>(() => DummmyController());
  }
}
