import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'dart:convert'; // For encoding and decoding data
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../FusionConnection/tcpSocket.dart';
import '../Models/transactiontable.dart';
import '../models/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final TextEditingController inputIpFuissionController =
      TextEditingController();
  final TextEditingController inputPortFuissionController =
      TextEditingController();
  final TextEditingController inputTimerPublicController =
      TextEditingController();
  final TextEditingController inputIPPOrtalPublicController =
      TextEditingController();
  final TextEditingController inputPoretPortalPublicController =
      TextEditingController();
  final TextEditingController inputEGInvoicePublicController =
      TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
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

  updateValue1() {
    print('presetvalueController.text${inputIpFuissionController.text}');
    var value = inputIpFuissionController.text; // Update observable value
    customController.IpFuission =
        inputIpFuissionController.text; // Update observable value
    print('updateValue1--->${inputIpFuissionController.text}');
  }

  updateValue2() {
    print('presetvalueController.text${inputPortFuissionController.text}');
    var value = inputPortFuissionController.text; // Update observable value
    customController.PortFuission = inputPortFuissionController.text;
    print('updateValue2--->${inputPortFuissionController.text}');
  }

  updateValue3() {
    print('presetvalueController.text${inputTimerPublicController.text}');
    var value = inputTimerPublicController.text; // Update observable value
    customController.PublicTimer = inputTimerPublicController.text;
    print('updateValue3--->${inputTimerPublicController.text}');
  }

  updateValue4() {
    print('presetvalueController.text${inputIPPOrtalPublicController.text}');
    var value = inputIPPOrtalPublicController.text; // Update observable value
    // customController.PublicTimer = inputIPPOrtalPublicController.text;
    print('updateValue4--->${inputIPPOrtalPublicController.text}');
  }

  updateValue5() {
    print('presetvalueController.text${inputPoretPortalPublicController.text}');
    var value =
        inputPoretPortalPublicController.text; // Update observable value
    // customController.PublicTimer = inputIPPOrtalPublicController.text;
    print('updateValue5--->${inputPoretPortalPublicController.text}');
  }

  updateValue6() {
    print('presetvalueController.text${inputEGInvoicePublicController.text}');
    var value = inputEGInvoicePublicController.text; // Update observable value
    // customController.PublicTimer = inputIPPOrtalPublicController.text;
    print('updateValue6--->${inputEGInvoicePublicController.text}');
  }

  void saveSettings() async {
    String input1 = inputIpFuissionController.text;
    String input2 = inputPortFuissionController.text;
    String input3 = inputTimerPublicController.text;
    // final prefs = await SharedPreferences.getInstance();
    // prefs?.setBool('configsetting', true);

    // Save logic (e.g., API call, local storage)
    print('Input 1: $input1');
    print('Input 2: $input2');
    print('Input 3: $input3');
  }
}
