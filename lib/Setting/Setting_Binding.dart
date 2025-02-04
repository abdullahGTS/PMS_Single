import 'package:get/get.dart';

import 'Setting_Controller.dart';



class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(() => SettingController());
  }
}
