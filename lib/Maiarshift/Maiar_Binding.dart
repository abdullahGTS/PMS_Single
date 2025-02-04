import 'package:get/get.dart';

import 'Maiar_Controller.dart';

class MaiarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaiarController>(() => MaiarController());
  }
}
