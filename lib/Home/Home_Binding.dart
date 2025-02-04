import 'package:get/get.dart';
import 'package:pms/Home/Home_Controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
