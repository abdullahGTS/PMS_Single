import 'package:get/get.dart';

import 'PresetValue_Controller.dart';


class PresetvalueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresetvalueController>(() => PresetvalueController());
  }
}
