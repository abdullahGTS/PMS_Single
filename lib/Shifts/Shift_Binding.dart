import 'package:get/get.dart';

import 'Shift_Controller.dart';

class ShiftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShiftController>(() => ShiftController());
  }
}
