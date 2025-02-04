import 'package:get/get.dart';

import 'ResetPayment_Controller.dart';

class ResetPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPaymentController>(() => ResetPaymentController());
  }
}
