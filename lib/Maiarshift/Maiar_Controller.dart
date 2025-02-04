// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/Models/transactiontable.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../models/database_helper.dart';

class MaiarController extends GetxController {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    print("customsuper${customController.issupervisormaiar.value}");
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
