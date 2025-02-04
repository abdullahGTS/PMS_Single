import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../models/database_helper.dart';

class VerifycloseshiftController extends GetxController {
  final customController = Get.find<CustomAppbarController>();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    print("closingprin${customController.pinopenshift.value}");

    // var last_shift = await dbHelper.lastShift();
    // if (last_shift != null) {
    //   print("last_shiftsupervisor${last_shift?['status']}");
    //   if (last_shift?['status'] == 'opened') {
    //     customController.managershift.value = last_shift?['supervisor'] ?? '';
    //     customController.datetimeshift.value = last_shift?['startshift'] ?? '';
    //     Get.toNamed('/Home');
    //   }
    // } else {
    //   print('no last shift in shifts on init');
    // }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
