import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Models/transactiontable.dart';
import '../models/database_helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CloseRequestController extends GetxController {
  var isLoading = true.obs;
  var closeStatus = "Close Pending...".obs;
  var posNum = "#".obs;
  String androidId_id = '';
  String tokenofapi = '';
  String csrftokenofapi = '';
  bool flagconnection = false;
  String fileConfigPath = ''; // Global variable for file path
  SharedPreferences? prefs;
  Timer? timer;
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final dbHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    // fetchToken();
    print("init->>>>>>");
    startPeriodicFetch();

    // Repeat the drop animation indefinitely
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
      print("Timer stopped.");
    }

    super.onClose();
  }

  // Method to stop loading when condition is met
  void stopLoading(amountval) {
    isLoading.value = true;
  }

  Future<void> checkthelastpos() async {
    prefs = await SharedPreferences.getInstance();

    var last_shift = await dbHelper.lastShift();
    print("last_shiftcheckthelastpos${last_shift}");

    final baseUrl =
        'https://41.33.226.46/merchantpanal/pos/shift/check/status/api/';

    try {
      final url = Uri.parse('$baseUrl?shift_num=${last_shift?['shift_num']}');

      // Send POST request
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      print("response.statusCode${response.statusCode}");

      if (response.statusCode == 200) {
        print('response  successfully:---------> ${response.body}');

        var responseData = jsonDecode(response.body);

        closeStatus.value = 'Close Processing...';
        posNum.value = responseData['poses'].toString();

        String endTime =
            DateFormat("yyyy-MM-dd' 'HH:mm:ss").format(DateTime.now());
        if (Get.currentRoute == '/Home' || Get.currentRoute == '/CloseShift') {
          if (responseData['status'] == true) {
            if (last_shift?['status'] == "opened") {
              customController.dbHelper.updatestatusshift(
                  int.parse(last_shift?['shift_num']) ?? 0, "closed", endTime);
            } else {
              print('already last shift is closed');
            }

            prefs!.setInt('shift_id', 0);
            Get.offAllNamed('/Shift');
          } else if (responseData['status'] == false) {
            if (last_shift?['status'] == "opened") {
              customController.dbHelper.updatestatusshift(
                  int.parse(last_shift?['shift_num']) ?? 0, "closed", endTime);
              customController.sendCloseShift();
              print(
                  "responseData['poses']--------?${responseData['poses'].toString()}");
            }
          } else {
            if (responseData['status'] == 'shift_error') {
              prefs!.setInt('shift_id', 0);
              Get.offAllNamed('/Shift');
            } else if (responseData['status'] == 'close_error') {
              Get.toNamed('/Home');
            } else {
              prefs!.setInt('shift_id', 0);
              Get.offAllNamed('/Shift');
            }
          }
        }
      } else {
        print("error");
      }
    } catch (e) {
      print("error${e}");
    }
  }

  void startPeriodicFetch() async {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      print("Running periodic fetchToken...");
      await checkthelastpos();
    });
  }
}
