import 'package:get/get.dart';
import 'package:my_cashbook/DB/HomeDBProvider.dart';
import 'package:my_cashbook/Models/BookModel.dart';

import '../../../../Models/CollectionEntryModel/CollectionEntryModel.dart';

class CollectionPageController extends GetxController {
  //TODO: Implement HomeController
  RxInt currentBottomIndex =0.obs;
  RxList<int> collectionLength = [1,2,3].obs;
  late CollectionBook book;
  List<CollectionEntryModel> expanseHistoryList = [];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    book = Get.arguments;
    DBProvider().fetchExpanseTypes().listen((event) { print(event);});
  }

  @override
  void onReady() {
    super.onReady();

  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
