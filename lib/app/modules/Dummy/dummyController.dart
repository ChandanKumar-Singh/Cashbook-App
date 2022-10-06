import 'package:get/get.dart';

class DummmyController extends GetxController {
//TODO: Implement HomeController
  RxInt currentBottomIndex = 0.obs;
  RxList<int> collectionLength = [1, 2, 3].obs;
  late String title;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    title = "Get.arguments";
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
