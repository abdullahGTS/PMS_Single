import 'package:get/get.dart';

import 'AvailableTrxDetails_Controller.dart';

class AvailabletrxdetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvailabletrxdetailsController>(
        () => AvailabletrxdetailsController());
  }
}
