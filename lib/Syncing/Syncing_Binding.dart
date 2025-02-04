import 'package:get/get.dart';

import 'Syncing_Controller.dart';

class SyncingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SyncingController>(() => SyncingController());
  }
}
