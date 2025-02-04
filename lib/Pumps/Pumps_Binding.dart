import 'package:get/get.dart';
import 'package:pms/Pumps/Pumps_Controller.dart';

class PumpsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PumpsController>(() => PumpsController());
  }
}
