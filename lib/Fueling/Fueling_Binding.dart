import 'package:get/get.dart';
import 'Fueling_Controller.dart';

class FuelingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FuelingController>(() => FuelingController());
  }
}
