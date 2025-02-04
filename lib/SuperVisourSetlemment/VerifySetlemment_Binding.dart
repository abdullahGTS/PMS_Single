import 'package:get/get.dart';

import 'VerifySetlemment_Controller.dart';

class VerifySetlemmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifySetlemmentController>(() => VerifySetlemmentController());
  }
}
