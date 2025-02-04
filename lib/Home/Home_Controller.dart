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
// import 'package:device_info_plus/device_info_plus.dart';

class HomeController extends GetxController {
  final customController = Get.find<CustomAppbarController>();
  final TextEditingController _passwordController = TextEditingController();

  final DatabaseHelper dbHelper = DatabaseHelper();

  // Construct the XML for the AuthoriseFuelPoint request with your data
  String currentTime =
      DateFormat("yyyy-MM-dd' 'HH:mm:ss").format(DateTime.now());

  var totalAmount = 0.0.obs; // Observable for the total amount
  // var counterTrans = 0.obs;
  var TotalTransaction = 0.obs;

  var transnum = 0.obs;
  var totalmoney = 0.0.obs;
  var totaltips = 0.0.obs;
  var totalamount = 0.0.obs;

  final salepint = 0.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    print("Current Page: ${Get.currentRoute}");

    loadSalepint();
    // await customController.startConnection();
    await printRowCount();
    // await calculateTotalAmount();
    print(
        'customController.managershift.value${customController.isconnect.value}');

    await fetchTransactionSummary();
    Get.closeAllSnackbars();
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

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state, BuildContext context) {
    if (state == AppLifecycleState.paused) {
      // App going to the background - optionally lock the app
      print('App is paused');
      showExitPasswordDialog(context);
    }
  }

  // Future<String?> GetSerialNumber() async {
  //   String? response;
  //   const _channel = MethodChannel('com.example.pms/method');
  //   try {
  //     response = await _channel.invokeMethod<String>('getSerialNumber');
  //     print("response${response}");
  //   } catch (e) {
  //     // Handle error
  //     print("Error retrieving serial number: $e");
  //     response = 'No response';
  //   }
  //   return response;
  // }

  Future<bool> showExitPasswordDialog(BuildContext context) async {
    bool isExitAllowed = false;
    await showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Password to Exit'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                var pass = customController.SerialNumber.value
                    .substring(customController.SerialNumber.value.length - 6);
                var reversedPass = pass.split('').reversed.join();
                if (_passwordController.text == reversedPass) {
                  // Replace with your actual password logic
                  isExitAllowed = true;
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Incorrect password')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
    _passwordController.clear();
    return isExitAllowed;
  }

  Future<void> loadSalepint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedSalepint =
        prefs.getInt('salepint') ?? 0; // Get saved value or 0 if not found
    salepint.value = savedSalepint; // Update observable salepint value
  }

  // Update salepint and save it in SharedPreferences
  Future<void> updateSalepint(int newSalepint) async {
    salepint.value = newSalepint; // Update the observable
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('salepint', newSalepint); // Save new value
  }

  // Future<double> getTotalAmount() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getDouble('totalAmount') ?? 0.0;
  // }

  printRowCount() async {
    final dbHelper = DatabaseHelper();
    TotalTransaction.value = await dbHelper.getRowCount();
  }

  // calculateTotalAmount() async {
  //   final dbHelper = DatabaseHelper();
  //   totalAmount.value = await dbHelper.getTotalAmount();
  //   print("Total Amount: ${totalAmount.value}"); // Print the total amount
  // }

  fetchTransactionSummary() async {
    final dbHelper = DatabaseHelper();

    var result = await dbHelper.lastShift();

    print("shift_idhome------${result!['id']}");
    final summary = await dbHelper.getTransactionSummary(result!['id']);

    transnum.value = summary['transnum'];
    totalmoney.value = double.parse(summary['totalmoney'].toStringAsFixed(2));
    totaltips.value = double.parse(summary['totaltips'].toStringAsFixed(2));
    totalamount.value = double.parse(summary['totalamount'].toStringAsFixed(2));

    print('Total Transactions-------> ${summary['transnum']}');
    print('Total Money: ${summary['totalmoney']}');
    print('Total Money: ${summary['totaltips']}');
    print('Total totalamount: ${summary['totalamount']}');
  }

//   getTrxBySeqNum() {
//     print("getTrxBySeqNum");
//     print("id1${customController.iD}");
//     // Increment RequestID
//     customController.iD++;
//     print("id2${customController.iD}");

//     // Get the current time formatted for the XML
//     String currentTime =
//         DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
//     String xl = '''
// <?xml version="1.0" encoding="utf-8" ?>
// <ServiceRequest RequestType="GetFuelSaleTrxDetailsByNo" ApplicationSender="${customController.androidId_id.split('.').join().substring(0, 5)}" WorkstationID="PMS" RequestID="${customController.iD}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="FDC_GetFuelSaleTrxDetailsByNo_Request.xsd">
// <POSdata>
// <POSTimeStamp>$currentTime</POSTimeStamp>
// <DeviceClass Type="FP" DeviceID="*" TransactionSeqNo="801">
// </DeviceClass>
// </POSdata>
// </ServiceRequest>''';

//     print("xmlContentreqcheckFueling${xl}");

//     // Log the XML for debugging purposes
//     Get.snackbar(
//       'GetFuelSaleTrxDetailsByNo',
//       '${xl}',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//     );
//     // Send the constructed XML message through socket
//     customController.socketConnection
//         .sendMessage(customController.getXmlHeader(xl));
//   }

  reprint() async {
    const _channel = MethodChannel('com.example.pms/method');
    final String response = await _channel.invokeMethod<String>(
            'reprintTransMsg', {"ecrRef": "256691105", "voucherNo": 178}) ??
        'No response';
    print("response Home ----> ${response}");
  }
}
