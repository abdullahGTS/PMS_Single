// ignore_for_file: deprecated_member_use, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pms/CustomAppbar/CustomAppbar_Controller.dart';
import 'package:pms/PresetValue/PresetValue_Controller.dart';

import '../models/database_helper.dart';
import 'package:intl/intl.dart';

class AuthorizedController extends GetxController
    with SingleGetTickerProviderMixin {
  final customController = Get.find<CustomAppbarController>();
  late AnimationController dropController;
  late Animation<Offset> dropAnimation;
  final DatabaseHelper dbHelper = DatabaseHelper();
  var isLoading = true.obs;
  var TotalTransaction = 0.obs;
  var totalAmount = 0.0.obs; // Observable for the total amount
  var textValue = ''.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    // checkFueling(customController.pumpNo.value);
    textValue.value = Get.arguments['presetValue'] ?? 'Unknown';
    print("textValuetextValue ${textValue.value}");
    print("customControllerpump-------- ${customController.pumpNo.value}");
    checkFueling(customController.pumpNo.value);
    customController.checkFueling.listen((data) {
      var temp = customController.parseXmlFuelingData(data);
      print('tempAuthorizedController------->${temp[0]}');

      if (temp[0] == true) {
        Get.toNamed('/Fueling');
      } else {
        checkFueling(customController.pumpNo.value);
      }
      // if(temp[1]==)
    });
    // Timer.periodic(const Duration(seconds: 5), (timer) async {
    //   checkFueling(customController.pumpNo.value);
    // });
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

  checkFueling(pumpName) {
    print("checkFueling");
    // Increment RequestID
    customController.iD++;

    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

    String xmlContentreq = '''
<?xml version="1.0"?>
<ServiceRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestType="GetFPState"
ApplicationSender="${customController.androidId_id.split('.').join().substring(0, 5)}" WorkstationID="PMS" RequestID="${customController.iD}">
 <POSdata>
 <POSTimeStamp>$currentTime</POSTimeStamp>
 <DeviceClass Type="FP" DeviceID="$pumpName" />
 </POSdata>
</ServiceRequest>
''';

    // Log the XML for debugging purposes

    // Send the constructed XML message through socket
    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
  }
}
