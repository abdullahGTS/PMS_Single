import 'package:get/get.dart';
import 'Receipt_Controller.dart';

class ReceiptBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptController>(() => ReceiptController());
  }
}
