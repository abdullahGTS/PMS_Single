import 'package:get/get.dart';

import 'AvailableTransactions_Controller.dart';

class AvailabletransactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvailabletransactionsController>(
        () => AvailabletransactionsController());
  }
}
