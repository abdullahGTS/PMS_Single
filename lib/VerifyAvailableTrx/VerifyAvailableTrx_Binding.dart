import 'package:get/get.dart';

import 'VerifyAvailableTrx_Controller.dart';

class VerifyavailabletrxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyavailabletrxController>(
        () => VerifyavailabletrxController());
  }
}
