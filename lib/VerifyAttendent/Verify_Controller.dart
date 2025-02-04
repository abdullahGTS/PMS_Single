// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';

class VerifyController extends GetxController {
  final IdFieldController = TextEditingController();
  final customController = Get.find<CustomAppbarController>();
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    // await customController.startConnection();
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
