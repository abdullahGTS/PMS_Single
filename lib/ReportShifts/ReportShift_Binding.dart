import 'package:get/get.dart';

import 'ReportShift_Controller.dart';

class ReportshiftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportshiftController>(() => ReportshiftController());
  }
}
