// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import 'package:intl/intl.dart';

import '../FusionConnection/tcpSocket.dart';

class PumpsController extends GetxController {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  // var pumpState = true.obs;
  // var pumpStateNumber = 0.obs;
  var xmlDataPumpListener;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    // customController.checkFueling.listen((data) {
    //   var temp = customController.parseXmlFuelingData(data);
    //   pumpState.value = temp[0];
    //   pumpStateNumber.value = temp[1];
    // });

    // await customController.fetchToken();
    // print(customController.fusionIP.value);
    // print(customController.fusionPort.value);
    // await customController.startConnection();
    Get.closeAllSnackbars();

    // print(
    //     'customController.issupervisormaiar.value===>${customController.issupervisormaiar.value}');
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    // Cancel the subscription when leaving the page
    xmlDataPumpListener?.cancel();
    xmlDataPumpListener = null;

    super.dispose();
  }

  checkFueling(pumpName) {
    print("teeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print("id1${customController.iD}");
    // Increment RequestID
    customController.iD++;
    print("id2${customController.iD}");

    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

    String xmlContentreq = '''
<?xml version="1.0"?>
<ServiceRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestType="GetFPState"
ApplicationSender="${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}" WorkstationID="PMS" RequestID="${customController.iD}">
 <POSdata>
 <POSTimeStamp>$currentTime</POSTimeStamp>
 <DeviceClass Type="FP" DeviceID="$pumpName" />
 </POSdata>
</ServiceRequest>
''';
    print("xmlContentreqcheckFueling${xmlContentreq}");

    // Log the XML for debugging purposes
    // Get.snackbar(
    //   'Check PUMP Status',
    //   'GetFPState Request Sent',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // Send the constructed XML message through socket
    // print(customController.socketConnection);
    // print(customController.socketConnection.runtimeType);
    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
  }
}
