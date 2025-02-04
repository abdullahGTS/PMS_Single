import 'package:get/get.dart';
import 'package:pms/VerifyAttendent/Verify_Controller.dart';

class VerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyController>(() => VerifyController());
  }
}
