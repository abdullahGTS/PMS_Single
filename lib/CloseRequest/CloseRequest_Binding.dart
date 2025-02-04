import 'package:get/get.dart';

import 'CloseRequest_Controller.dart';

class CloseRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CloseRequestController>(() => CloseRequestController());
  }
}
