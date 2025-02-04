import 'package:get/get.dart';

import 'CustomAppbar_Controller.dart';


class CustomappbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomAppbarController>(() => CustomAppbarController());
  }
}
