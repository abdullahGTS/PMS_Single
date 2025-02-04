import 'package:get/get.dart';

import 'VerifyCloseShift_Controller.dart';


class VerifycloseshiftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifycloseshiftController>(() => VerifycloseshiftController());
  }
}
