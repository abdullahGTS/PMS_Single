// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps, must_call_super

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NozzelsController extends GetxController {
  @override
  void onInit() {
    Get.closeAllSnackbars();
    getpumpnum();
  }

  String? pumpnum = '';
  getpumpnum() async {
    final prefs = await SharedPreferences.getInstance();
    pumpnum = prefs.getString('pumpName');
    print("pumpnum${pumpnum}");
  }
}
