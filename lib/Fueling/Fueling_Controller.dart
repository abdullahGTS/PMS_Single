import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pms/CustomAppbar/CustomAppbar_Controller.dart';
import 'package:pms/PresetValue/PresetValue_Controller.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/database_helper.dart';

class FuelingController extends GetxController
    with SingleGetTickerProviderMixin {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  late AnimationController dropController;
  late Animation<Offset> dropAnimation;
  final DatabaseHelper dbHelper = DatabaseHelper();
  var isLoading = true.obs;
  var TotalTransaction = 0.obs;
  var totalAmount = 0.0.obs; // Observable for the total amount
  // var textValue = ''.obs;
  var timer;
  // var _getFuelSaleTrxDetailsByNoListener;
  var _xmlDataListener;

  @override
  void onInit() async {
    super.onInit();

    // textValue.value = Get.arguments['presetValue'] ?? 'Unknown';
    // print("textValuetextValue ${textValue.value}");

    // Initialize the drop animation controller
    dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Define the drop animation (falling effect)
    dropAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 1.5))
            .animate(CurvedAnimation(
      parent: dropController,
      curve: Curves.easeIn,
    ));

    // Repeat the drop animation indefinitely
    dropController.repeat();
    // Get.snackbar(
    //   'Get Seq Number',
    //   '${customController.transactionSeqNo.value}',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    customController.transactionSeqNo.value = Get.arguments['trxSeqNum'] ?? '';
    print(
        'customController.transactionSeqNo.value${customController.transactionSeqNo.value}');
    // textValue.value = Get.arguments['trxSeqNum'] ?? '';
    // print("textValuetextValue ${textValue.value}");
    startPeriodicFetch();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // Get.snackbar(
    //   'Get Seq Number',
    //   '${customController.transactionSeqNo.value}',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
  }

  @override
  void onClose() {
    dropController.dispose();
    // Cancel the subscription when leaving the page
    // _getFuelSaleTrxDetailsByNoListener?.cancel();
    // _getFuelSaleTrxDetailsByNoListener = null;
    _xmlDataListener?.cancel();
    _xmlDataListener = null;

    // Cancel any timers if applicable
    if (timer != null) {
      timer!.cancel();
      timer = null;
      print("Timer cleared in dispose.");
    }
    super.onClose();
  }

  @override
  void dispose() {
    // Cancel the subscription when leaving the page
    // _getFuelSaleTrxDetailsByNoListener?.cancel();
    // _getFuelSaleTrxDetailsByNoListener = null;
    _xmlDataListener?.cancel();
    _xmlDataListener = null;

    // Cancel any timers if applicable
    if (timer != null) {
      timer!.cancel();
      timer = null;
      print("Timer cleared in dispose.");
    }

    super.dispose();
  }

  // Method to stop loading when condition is met
  void stopLoading(amountval) {
    isLoading.value = true;
  }

//   checkFueling(pumpName) {
//     print("checkFueling");
//     print("id1${customController.iD}");
//     // Increment RequestID
//     customController.iD++;
//     print("id2${customController.iD}");

//     // Get the current time formatted for the XML
//     String currentTime =
//         DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

//     String xmlContentreq = '''
// <?xml version="1.0"?>
// <ServiceRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
// xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestType="GetCurrentFuellingStatus"
// ApplicationSender="${customController.androidId_id.split('.').join().substring(0, 5)}" WorkstationID="PMS" RequestID="${customController.iD}">
//  <POSdata>
//  <POSTimeStamp>$currentTime</POSTimeStamp>
//  <DeviceClass Type="FP" DeviceID="$pumpName" />
//  </POSdata>
// </ServiceRequest>
// ''';
//     print("xmlContentreqcheckFueling${xmlContentreq}");

//     // Log the XML for debugging purposes

//     // Send the constructed XML message through socket
//     customController.socketConnection
//         .sendMessage(customController.getXmlHeader(xmlContentreq));
//   }

  getTrxBySeqNum() {
    print("getTrxBySeqNum");
    print("id1${customController.iD}");
    // Increment RequestID
    customController.iD++;
    print("id2${customController.iD}");

    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
    String xl = '''<?xml version="1.0" encoding="utf-8" ?>
<ServiceRequest RequestType="GetFuelSaleTrxDetailsByNo" ApplicationSender="${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}"
WorkstationID="PMS" RequestID="${customController.iD}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="FDC_GetFuelSaleTrxDetailsByNo_Request.xsd">
<POSdata>
<POSTimeStamp>$currentTime</POSTimeStamp>
<DeviceClass Type="FP" DeviceID="*" TransactionSeqNo="${customController.transactionSeqNo.value}">
</DeviceClass>
</POSdata>
</ServiceRequest>''';

    print("GetFuelSaleTrxDetailsByNoxmlContentreqcheckFueling${xl}");

    // Log the XML for debugging purposes
    // Get.snackbar(
    //   'GetFuelSaleTrxDetailsByNo',
    //   '${xl}',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // Send the constructed XML message through socket
    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xl));
  }

  getTrxDetails(data) async {
    // Get.snackbar(
    //   'GetFuelSaleTrxDetailsByNo In Details',
    //   '${customController.getFuelSaleTrxDetailsByNo.value}',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // _getFuelSaleTrxDetailsByNoListener =
    //     customController.getFuelSaleTrxDetailsByNo.listen((data) async {
    // Get.toNamed('/Tips');
    var document = XmlDocument.parse(data);
    var serviceResponse = document.getElement('ServiceResponse');
    if (serviceResponse != null) {
      var RequestType = serviceResponse.getAttribute('RequestType');
      var OverallResult = serviceResponse.getAttribute('OverallResult');
      if (RequestType == 'GetFuelSaleTrxDetailsByNo' &&
          OverallResult == 'Success') {
        print("OverallResult--------${document}");

        // socketConnection.sendMessage(getXmlHeader(incrementXml()));
        customController.statevalue.value =
            document.findAllElements('State').first.text;
        print("statevalue${customController.statevalue}");

        customController.AuthorisationApplicationSender.value = document
            .findAllElements('AuthorisationApplicationSender')
            .first
            .text;
        print(
            "AuthorisationApplicationSender${customController.AuthorisationApplicationSender}");

        customController.counterTrans++;
        customController
            .updateCounterTrans(customController.counterTrans.value);
        // Send counterTrans to HomeController
        customController.fdCTimeStamp.value =
            document.findAllElements('FDCTimeStamp').first.text;

        customController.type.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('Type') ??
            '';

        customController.deviceID.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('DeviceID') ??
            '';

        customController.pumpNo.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('PumpNo') ??
            '';

        customController.nozzleNo.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('NozzleNo') ??
            '';
        var tempTrxSeqNum = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('TransactionSeqNo') ??
            '';
        customController.fusionSaleId.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('FusionSaleId') ??
            '';
        print("fdCTimeStamp${customController.fdCTimeStamp.value}");

        print("type${customController.type.value}");
        print("deviceID${customController.deviceID.value}");
        print("pumpNo${customController.pumpNo.value}");
        print("nozzleNo${customController.nozzleNo.value}");
        print("transactionSeqNo${customController.transactionSeqNo.value}");

        // fusionSaleId.value = document
        //         .findAllElements('DeviceClass')
        //         .first
        //         .getAttribute('FusionSaleId') ??
        //     '';
        customController.releaseToken.value =
            document.findAllElements('ReleaseToken').first.text;
        // completionReason.value =
        //     document.findAllElements('CompletionReason').first.text;
        customController.fuelMode.value =
            document.findAllElements('FuelMode').first.getAttribute('ModeNo') ??
                '';
        customController.productUM.value =
            document.findAllElements('ProductUM').first.text ?? '';

        customController.productNo.value =
            document.findAllElements('ProductNo').first.text;
        customController.amountVal.value =
            double.tryParse(document.findAllElements('Amount').first.text) ??
                0.0;
        customController.volume.value =
            double.tryParse(document.findAllElements('Volume').first.text) ??
                0.0;
        customController.unitPrice.value =
            double.tryParse(document.findAllElements('UnitPrice').first.text) ??
                0.0;
        customController.volumeProduct1.value = double.tryParse(
                document.findAllElements('VolumeProduct1').first.text) ??
            0.0;
        customController.volumeProduct2.value = double.tryParse(
                document.findAllElements('VolumeProduct2').first.text) ??
            0.0;
        customController.productNo1.value =
            int.tryParse(document.findAllElements('ProductNo1').first.text) ??
                0;
        // productUM.value = document.findAllElements('ProductUM').first.text;
        customController.productName.value = customController
                .getProductName(int.parse(customController.productNo.value)) ??
            'No Product';
        // productName.value = document.findAllElements('ProductName').first.text;
        customController.blendRatio.value =
            int.tryParse(document.findAllElements('BlendRatio').first.text) ??
                0;
        // Get.toNamed('/Tips');
        if (customController.statevalue.value == "Payable" &&
            customController.AuthorisationApplicationSender.value ==
                customController.SerialNumber.value.substring(
                    customController.SerialNumber.value.length - 5) &&
            customController.transactionSeqNo.value == tempTrxSeqNum) {
          customController.transactionSeqNo.value = tempTrxSeqNum;
          print("thanks fueling");
          // if (timer != null) {
          //   timer!.cancel();
          //   print("Timer stopped.");
          // }
          this.dispose();

          // textValue.value = '';
        }
        if (customController.issupervisormaiar.value) {
          customController.TipsValue.value = "0";
          Get.toNamed('/ChoosePayment');
        } else {
          if (Get.currentRoute == "/Fueling") {
            Get.toNamed('/Tips');
          }
        }
        // Get.toNamed('/Tips');
      }
    }
    // });
  }

  getTrxDetailsFromFuelSale(data) async {
    // customController.getFuelSaleTrxDetailsByNo.listen((data) async {
    // Get.toNamed('/Tips');
    var document = XmlDocument.parse(data);
    var fdcMessage = document.getElement('FDCMessage');
    if (fdcMessage != null) {
      var messageType = fdcMessage.getAttribute('MessageType');
      if (messageType == 'FuelSaleTrx') {
        // socketConnection.sendMessage(getXmlHeader(incrementXml()));
        customController.statevalue.value =
            document.findAllElements('State').first.text;
        print("statevalue${customController.statevalue}");

        customController.AuthorisationApplicationSender.value = document
            .findAllElements('AuthorisationApplicationSender')
            .first
            .text;
        print(
            "AuthorisationApplicationSender${customController.AuthorisationApplicationSender}");

        customController.counterTrans++;
        customController
            .updateCounterTrans(customController.counterTrans.value);
        // Send counterTrans to HomeController
        customController.fdCTimeStamp.value =
            document.findAllElements('FDCTimeStamp').first.text;

        customController.type.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('Type') ??
            '';

        customController.deviceID.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('DeviceID') ??
            '';

        customController.pumpNo.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('PumpNo') ??
            '';

        customController.nozzleNo.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('NozzleNo') ??
            '';
        customController.transactionSeqNo.value = document
                .findAllElements('DeviceClass')
                .first
                .getAttribute('TransactionSeqNo') ??
            '';
        customController.fusionSaleId.value = '';

        print("fdCTimeStamp${customController.fdCTimeStamp.value}");

        print("type${customController.type.value}");
        print("deviceID${customController.deviceID.value}");
        print("pumpNo${customController.pumpNo.value}");
        print("nozzleNo${customController.nozzleNo.value}");
        print("transactionSeqNo${customController.transactionSeqNo.value}");

        // fusionSaleId.value = document
        //         .findAllElements('DeviceClass')
        //         .first
        //         .getAttribute('FusionSaleId') ??
        //     '';
        customController.releaseToken.value =
            document.findAllElements('ReleaseToken').first.text;
        // completionReason.value =
        //     document.findAllElements('CompletionReason').first.text;
        customController.fuelMode.value =
            document.findAllElements('FuelMode').first.getAttribute('ModeNo') ??
                '';
        customController.productUM.value = '';

        customController.productNo.value =
            document.findAllElements('ProductNo').first.text;
        customController.amountVal.value =
            double.tryParse(document.findAllElements('Amount').first.text) ??
                0.0;
        customController.volume.value =
            double.tryParse(document.findAllElements('Volume').first.text) ??
                0.0;
        customController.unitPrice.value =
            double.tryParse(document.findAllElements('UnitPrice').first.text) ??
                0.0;
        customController.volumeProduct1.value = double.tryParse(
                document.findAllElements('VolumeProduct1').first.text) ??
            0.0;
        customController.volumeProduct2.value = double.tryParse(
                document.findAllElements('VolumeProduct2').first.text) ??
            0.0;
        customController.productNo1.value =
            int.tryParse(document.findAllElements('ProductNo1').first.text) ??
                0;
        // productUM.value = document.findAllElements('ProductUM').first.text;
        customController.productName.value = customController
                .getProductName(int.parse(customController.productNo.value)) ??
            'No Product';
        // productName.value = document.findAllElements('ProductName').first.text;
        customController.blendRatio.value =
            int.tryParse(document.findAllElements('BlendRatio').first.text) ??
                0;
        // Get.toNamed('/Tips');
        if (customController.statevalue.value == "Payable" &&
            customController.AuthorisationApplicationSender.value ==
                customController.SerialNumber.value.substring(
                    customController.SerialNumber.value.length - 5)) {
          print("thanks fueling");
          // if (timer != null) {
          //   timer!.cancel();
          //   print("Timer stopped.");
          // }
          this.dispose();
          if (Get.currentRoute == "/Fueling") {
            Get.toNamed('/Tips');
          }
          // Get.toNamed('/Tips');
          // textValue.value = '';
        }
        // Get.toNamed('/Tips');
      }
    }
    // });
  }

  fuellingListener() async {
    _xmlDataListener = customController.xmlData.listen((data) async {
      // GetCurrentFuellingStatus
      var document = XmlDocument.parse(data);
      var serviceResponse = document.getElement('ServiceResponse');
      var fdcMessage = document.getElement('FDCMessage');
      if (serviceResponse != null) {
        var RequestType = serviceResponse.getAttribute('RequestType');
        var OverallResult = serviceResponse.getAttribute('OverallResult');
        if (RequestType == 'GetFuelSaleTrxDetailsByNo' &&
            OverallResult == 'Success') {
          var errorCode = document.findAllElements('ErrorCode').first.text;
          // Get.snackbar(
          //   'errorCode In Details',
          //   '${errorCode}',
          //   snackPosition: SnackPosition.TOP,
          //   backgroundColor: Colors.black,
          //   colorText: Colors.white,
          // );
          if (errorCode == "ERRCD_OK") {
            // customController.getFuelSaleTrxDetailsByNo.value = data;
            await getTrxDetails(data);
            if (timer != null) {
              timer!.cancel();
              print("Timer stopped.");
            }
          }
        }
      }
      // } else if (fdcMessage != null) {
      //   var messageType = fdcMessage.getAttribute('MessageType');
      //   if (messageType == 'FuelSaleTrx') {
      //     // await Future.delayed(Duration(seconds: 10));
      //     // await getTrxBySeqNum();
      //     await getTrxDetailsFromFuelSale(data);
      //     await Future.delayed(Duration(seconds: 10));
      //   } else if (messageType == 'FDC_Ready') {
      //     customController.socketConnection.sendMessage(
      //         customController.getXmlHeader(customController.incrementXml()));
      //   }
      //   //  else if (RequestType == 'GetFuelSaleTrxDetailsByNo' &&
      //   //     OverallResult == 'Success') {
      //   //   customController.getFuelSaleTrxDetailsByNo.value = data;
      //   //   await getTrxDetails();
      //   //   if (timer != null) {
      //   //     timer!.cancel();
      //   //     print("Timer stopped.");
      //   //   }
      //   // }
      // }
    });
    print(
        'customController.checkTransSecNum.value${customController.checkTransSecNum.value}');
  }

  void startPeriodicFetch() async {
    await getTrxBySeqNum(); // await checkFueling(customController.pumpNo.value);
    // await Future.delayed(Duration(seconds: 5));
    await fuellingListener();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      print("Running periodic fuellingListener...");

      await getTrxBySeqNum();
      // await checkFueling(customController.pumpNo.value);
      // await Future.delayed(Duration(seconds: 5));
      await fuellingListener();
    });
  }

  // fuellingListener() async {
  //   _xmlDataListener = customController.xmlData.listen((data) async {
  //     // GetCurrentFuellingStatus
  //     var document = XmlDocument.parse(data);
  //     var serviceResponse = document.getElement('ServiceResponse');
  //     var fdcMessage = document.getElement('FDCMessage');
  //     if (serviceResponse != null) {
  //       var RequestType = serviceResponse.getAttribute('RequestType');
  //       var OverallResult = serviceResponse.getAttribute('OverallResult');
  //       if (RequestType == 'GetCurrentFuellingStatus' &&
  //           OverallResult == 'Success') {
  //         var tempSeqNo = int.parse(document
  //                 .findAllElements('DeviceClass')
  //                 .first
  //                 .getAttribute('TransactionSeqNo') ??
  //             '');
  //         if (tempSeqNo != 0) {
  //           customController.checkTransSecNum.value = int.parse(document
  //                   .findAllElements('DeviceClass')
  //                   .first
  //                   .getAttribute('TransactionSeqNo') ??
  //               '');
  //           // await Future.delayed(Duration(seconds: 10));
  //           // await getTrxBySeqNum();
  //           // _getFuelSaleTrxDetailsByNoListener?.cancel();
  //           // _getFuelSaleTrxDetailsByNoListener = null;
  //           // _xmlDataListener?.cancel();
  //           // _xmlDataListener = null;
  //           // timer?.cancel();
  //           // timer = null;

  //           // await Future.delayed(Duration(seconds: 10));
  //           // await getTrxDetails();
  //         }
  //         await getTrxBySeqNum();
  //         await Future.delayed(Duration(seconds: 10));
  //       } else if (RequestType == 'GetFuelSaleTrxDetailsByNo' &&
  //           OverallResult == 'Success') {
  //         var errorCode = document.findAllElements('ErrorCode').first.text;
  //         // Get.snackbar(
  //         //   'errorCode In Details',
  //         //   '${errorCode}',
  //         //   snackPosition: SnackPosition.TOP,
  //         //   backgroundColor: Colors.black,
  //         //   colorText: Colors.white,
  //         // );
  //         if (errorCode == "ERRCD_OK") {
  //           customController.getFuelSaleTrxDetailsByNo.value = data;
  //           await getTrxDetails();
  //           if (timer != null) {
  //             timer!.cancel();
  //             print("Timer stopped.");
  //           }
  //         }
  //       }
  //     }
  //     // } else if (fdcMessage != null) {
  //     //   var messageType = fdcMessage.getAttribute('MessageType');
  //     //   if (messageType == 'FuelSaleTrx') {
  //     //     // await Future.delayed(Duration(seconds: 10));
  //     //     // await getTrxBySeqNum();
  //     //     await getTrxDetailsFromFuelSale(data);
  //     //     await Future.delayed(Duration(seconds: 10));
  //     //   } else if (messageType == 'FDC_Ready') {
  //     //     customController.socketConnection.sendMessage(
  //     //         customController.getXmlHeader(customController.incrementXml()));
  //     //   }
  //     //   //  else if (RequestType == 'GetFuelSaleTrxDetailsByNo' &&
  //     //   //     OverallResult == 'Success') {
  //     //   //   customController.getFuelSaleTrxDetailsByNo.value = data;
  //     //   //   await getTrxDetails();
  //     //   //   if (timer != null) {
  //     //   //     timer!.cancel();
  //     //   //     print("Timer stopped.");
  //     //   //   }
  //     //   // }
  //     // }
  //   });
  //   print(
  //       'customController.checkTransSecNum.value${customController.checkTransSecNum.value}');
  // }

  // void startPeriodicFetch() async {
  //   await checkFueling(customController.pumpNo.value);
  //   await Future.delayed(Duration(seconds: 5));
  //   await fuellingListener();

  //   timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
  //     print("Running periodic fuellingListener...");

  //     await checkFueling(customController.pumpNo.value);
  //     // await Future.delayed(Duration(seconds: 5));
  //     await fuellingListener();
  //   });
  // }
}
