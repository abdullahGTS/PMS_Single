import 'package:get/get.dart';

import 'ChoosePayment_Controller.dart';

class ChoosePaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChoosePaymentController>(() => ChoosePaymentController());
  }
}
