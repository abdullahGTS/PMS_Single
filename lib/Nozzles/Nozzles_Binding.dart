import 'package:get/get.dart';

import 'Nozzles_Controller.dart';


class NozzlesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NozzelsController>(() => NozzelsController());
  }
}
