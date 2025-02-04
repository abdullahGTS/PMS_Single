import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import 'package:intl/intl.dart';

class AvailabletransactionsController extends GetxController {
  final customController = Get.find<CustomAppbarController>();
  var AvailableTrxList = [].obs;
  var NoAvailableTrx = "".obs;
  var AvailableTrxTempList = [];
  var AvailableTrxListener;

  @override
  void onInit() async {
    super.onInit();
    // await customController.fetchTransactions();
    // displayAvailableTrx();
    // await GetAllTransaction();
    GetAllTransaction();
  }

  @override
  void onReady() {
    super.onReady();
    // GetAllTransaction();
  }

  @override
  void onClose() {
    super.onClose();
  }

  GetAllTransaction() async {
    print("teeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print("id1${customController.iD}");
    // Increment RequestID
    customController.iD++;
    print("id2${customController.iD}");

    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

    String xmlContentreq = '''
<?xml version="1.0" encoding="utf-8" ?>
<ServiceRequest RequestType="GetAvailableFuelSaleTrxs" ApplicationSender="${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}"
WorkstationID="PMS" RequestID="${customController.iD}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="FDC_GetAvailableFuelSaleTrxs_Request.xsd">
<POSdata>
<POSTimeStamp>$currentTime</POSTimeStamp>
<DeviceClass Type="FP" DeviceID="*">
</DeviceClass>
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

    AvailableTrxListener = customController.xmlData.listen((data) async {
      var document = XmlDocument.parse(data);
      var serviceResponse = document.getElement('ServiceResponse');
      if (serviceResponse != null) {
        var RequestType = serviceResponse.getAttribute('RequestType');
        var OverallResult = serviceResponse.getAttribute('OverallResult');
        if (RequestType == 'GetAvailableFuelSaleTrxs' &&
            OverallResult == 'Success') {
          var allClasses = document.findAllElements('DeviceClass');
          print('DeviceClass----->${allClasses}');
          allClasses.forEach((element) {
            // var Type = element.getAttribute('Type');
            var deviceID = element.getAttribute('DeviceID');
            var PumpNo = element.getAttribute('PumpNo');
            var TransactionSeqNo = element.getAttribute('TransactionSeqNo');
            // var FusionSaleId = element.getAttribute('FusionSaleId');
            // var ReleaseToken = element.getAttribute('ReleaseToken');
            var errorCode = element.findAllElements('ErrorCode').first.text;
            if (errorCode == 'ERRCD_OK') {
              AvailableTrxTempList.add({
                // 'Type': Type,
                'NozzleNo': deviceID,
                'PumpNo': PumpNo,
                'TransactionSeqNo': TransactionSeqNo,
                // 'FusionSaleId': FusionSaleId,
                // 'ReleaseToken': ReleaseToken,
                'State': "Payable",
                'ProductName': customController
                    .getProductNameByNozzleNum(int.parse(deviceID!)),
              });
            } else {
              NoAvailableTrx.value = "No Available Transactions";
            }
          });
        }
      }
    });
    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
    await Future.delayed(Duration(seconds: 1));
    AvailableTrxList.value = AvailableTrxTempList;
    // Get.snackbar(
    //   'AvailableTrxList',
    //   '${AvailableTrxList.value}',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // if (AvailableTrxListener != null) {
    //   AvailableTrxListener!.cancel();
    //   print("AvailableTrxListener stopped.");
    // }
  }

  TransactionDetails(TrxSeqNo) {
    print('TrxSeqNo---->${TrxSeqNo}');

    Get.toNamed('/Availabletrxdetails', arguments: {'TrxSeqNo': TrxSeqNo});
  }
}
