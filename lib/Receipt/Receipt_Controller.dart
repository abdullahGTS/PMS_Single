import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import 'package:image/image.dart' as img;

class ReceiptController extends GetxController {
  final customController = Get.find<CustomAppbarController>();

  String bmPaymentAppScheme = 'BM Payment'; // Example for URL scheme
  String bmPaymentAppPackage = 'com.example.BM_Payment';
  var paymentTypeName = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // Future.delayed(Duration(seconds: 10));
    print("paymentType@@@${customController.paymentType.value}");
    if (customController.paymentType.value == 1) {
      paymentTypeName.value = 'Cash';
    }
    if (customController.paymentType.value == 2) {
      paymentTypeName.value = 'Bank';
    }
    if (customController.paymentType.value == 3) {
      paymentTypeName.value = 'Calibration';
    }
    if (customController.paymentType.value == 4) {
      paymentTypeName.value = 'Fleet';
    }
    if (customController.paymentType.value == 5) {
      paymentTypeName.value = 'Bank Point';
    }
    Get.closeAllSnackbars();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // print(
    //     "customController.paymentType.value${customController.paymentType.value}");
    // if (customController.paymentType.value == 1) {
    //   paymentTypeName.value = 'Cash';
    // }
    // if (customController.paymentType.value == 2) {
    //   paymentTypeName.value = 'Bank';
    // }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void someFunction() async {
    final response = await EbeUnifiedService.invokeMethod("posspayment");
    print(response);
  }
  // Replace with actual package name

  bool isPrinting = false; // Prevent duplicate print jobs

  static const MethodChannel _channel = MethodChannel("com.example.pms/method");

  printReceipt() async {
    try {
      const int receiptWidth =
          30; // Adjust based on your printer's character width

      // Center text utility
      String centerText(String text) {
        int spaces = (receiptWidth - text.length) ~/ 2;
        return ' ' * spaces + text + ' ' * spaces;
      }

      // Left and right alignment utility
      String alignLeftRight(String left, String right) {
        int spaces = receiptWidth - left.length - right.length;
        return left + ' ' * spaces + right;
      }

      final bytes = await rootBundle.load('media/new_logo_recet.jpg');
      final base64String = base64Encode(Uint8List.view(bytes.buffer));

      List<String> receiptContent = [
        '',
        '',
        centerText(customController.config['station_name'] ?? ''),
        centerText(customController.config['station_address'] ?? ''),
        centerText(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())),
        '',
        '-------------------------------',
        alignLeftRight(('Transaction_Seq_No'.tr + ':'),
            customController.transactionSeqNo.value.toString()),
        '',
        alignLeftRight(
            ('Pump_No'.tr + ':'), customController.pumpNo.value.toString()),
        '',
        alignLeftRight(
            ('Nozzle_No'.tr + ':'), customController.nozzleNo.value.toString()),
        '',
        alignLeftRight(
            ('Product_Name'.tr + ':'),
            customController.getProductName(
                    int.parse(customController.productNo.value)) ??
                ""),
        '',
        alignLeftRight(('Payment_Type'.tr + ':'), paymentTypeName.value),
        '',
        (customController.trxAttendant.value.isNotEmpty)
            ? alignLeftRight(('Transaction_By'.tr + ':'),
                customController.trxAttendant.value)
            : alignLeftRight(
                ('Calibration'.tr + ':'), customController.managershift.value),
        '-------------------------------',
        alignLeftRight(('Total_Amount_reciept'.tr + ':'),
            (customController.amountVal.value.toStringAsFixed(2) + ' EGP')),
        '',
        alignLeftRight(('Volume'.tr + ':'),
            (customController.volume.value.toStringAsFixed(2) + ' LTR')),
        '',
        alignLeftRight(('Unit_Price'.tr + ':'),
            (customController.unitPrice.value.toStringAsFixed(2) + ' EGP')),
        '',
        '',
        '',
        alignLeftRight(('Total_Paid'.tr + ':'),
            (customController.amountVal.value.toStringAsFixed(2) + ' EGP')),
        '-------------------------------',
        '',
        'Thank_you_for_your_visit'.tr + '.',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ];

      print("receiptContent->>>>${receiptContent}");

      final result = await _channel.invokeMethod('printReceipt',
          {'receiptContent': receiptContent, 'image': base64String});

      // Initialize printer
    } catch (e) {
      print("An error occurred during printing: $e");
    } finally {
      // customController.amountVal.value = 0.0;
      Get.offAllNamed("/Home");
    }
  }

  // void printResetPaymentReceipt() async {
  //   if (isPrinting) {
  //     print("Print job already in progress. Please wait.");
  //     return;
  //   }

  //   isPrinting = true;

  //   try {
  //     // Initialize printer
  //     await FlutterPaxPrinterUtility.init;

  //     // Center-aligned header
  //     await FlutterPaxPrinterUtility.printStr(" \n", null);
  //     await FlutterPaxPrinterUtility.printStr(" \n", null);
  //     await FlutterPaxPrinterUtility.printStr(" \n", null);

  //     // Print the image/logo
  //     await FlutterPaxPrinterUtility.printImageAsset(
  //         "media/new_logo_recet.jpg");

  //     // Add some spacing before printing text
  //     await FlutterPaxPrinterUtility.printStr("\n\n", null);

  //     // Prepare receipt content with safe default values and add spacing
  //     List<String> receiptContent = [
  //       "Station Name:",
  //       "",
  //       "Location: Egypt, Cairo",
  //       "",
  //       "Date: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
  //       "",
  //       "-------------------------------",
  //       "",
  //       "Transaction Seq No: ${customController.transactionSeqNo.value}",
  //       "",
  //       "Pump No: ${customController.pumpNo.value}",
  //       "",
  //       "Nozzle No: ${customController.nozzleNo.value}",
  //       "",
  //       "Product Name: ${customController.getProductName(int.parse(customController.productNo.value))}",
  //       "",
  //       "Payment Type: ${paymentTypeName.value}",
  //       "",
  //       "Transaction By: H",
  //       "",
  //       "-------------------------------",
  //       "",
  //       "Volume: ${customController.volume.value.toStringAsFixed(2)} L",
  //       "",
  //       "Price: ${customController.unitPrice.value.toStringAsFixed(2)}",
  //       "",
  //       "Amount: ${customController.amountVal.value.toStringAsFixed(2)}",
  //       "",
  //       "Total Paid: ${customController.amountVal.value.toStringAsFixed(2)} EGP",
  //       "",
  //       "-------------------------------",
  //       "",
  //       "Thank you for your visit!",
  //       "",
  //       "", // Additional spacing at the end, if needed
  //       "", // Additional spacing at the end, if needed
  //       "", // Additional spacing at the end, if needed
  //       "", // Additional spacing at the end, if needed
  //       "", // Additional spacing at the end, if needed
  //       "", // Additional spacing at the end, if needed
  //       "", // Additional spacing at the end, if needed
  //       // Additional spacing at the end, if needed
  //     ];

  //     // Print each line, centering specific lines
  //     for (String line in receiptContent) {
  //       if (line == "Station Name:" ||
  //           line.startsWith("Location:") ||
  //           line.startsWith("Date:") ||
  //           line.startsWith("Client Receipt")) {
  //         // Center align for specific lines
  //         await FlutterPaxPrinterUtility.printStr(
  //             line.padLeft((30 + line.length) ~/ 2), null);
  //       } else {
  //         await FlutterPaxPrinterUtility.printStr(line + "\n", null);
  //       }
  //     }

  //     await FlutterPaxPrinterUtility.step(10);
  //     await FlutterPaxPrinterUtility.start();
  //   } catch (e) {
  //     print("An error occurred during printing: $e");
  //   } finally {
  //     isPrinting = false;
  //     Get.offAllNamed("/Home");
  //   }
  // }
}

class TransactionService {
  static const MethodChannel _channel =
      MethodChannel("com.example.ebe_unified");

  static Future<String> startPaxTransaction({
    required double amount,
    String? currency = "EGP",
    String? merchantId,
    String? terminalId,
  }) async {
    try {
      final result = await _channel.invokeMethod('startPaxTransaction', {
        'amount': amount,
        'currency': currency,
        'merchantId': merchantId,
        'terminalId': terminalId,
      });
      return result.toString();
    } on PlatformException catch (e) {
      print("Pax transaction failed: ${e.message}");
      throw Exception(e.message);
    }
  }

  static Future<String> reprintTransaction({
    required int voucherNumber,
    required String ecrReferenceNumber,
  }) async {
    try {
      final result = await _channel.invokeMethod('reprintTransaction', {
        'voucherNumber': voucherNumber,
        'ecrReferenceNumber': ecrReferenceNumber,
      });
      return result.toString();
    } on PlatformException catch (e) {
      print("Reprint failed: ${e.message}");
      throw Exception(e.message);
    }
  }
}

class EbeUnifiedService {
  static const MethodChannel _channel =
      MethodChannel('com.example.ebe_unified');

  static Future<String?> invokeMethod(String methodName) async {
    try {
      final result = await _channel.invokeMethod<String>(methodName);
      return result;
    } catch (e) {
      print("Error invoking method: $e");
      return null;
    }
  }
}
