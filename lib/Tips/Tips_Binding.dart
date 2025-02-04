import 'package:get/get.dart';

import 'Tips_Controller.dart';

class TipsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TipsController>(() => TipsController());
  }
}
