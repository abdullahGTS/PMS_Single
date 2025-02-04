import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../models/database_helper.dart';
import 'package:collection/collection.dart'; // For groupBy
// import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportController extends GetxController {
  var transactions = <String>[].obs;
  var searchQuery = ''.obs;
  static const _channel = MethodChannel('com.example.pms/method');
  final DatabaseHelper dbHelper = DatabaseHelper();
  var groupedTransactions = <String, Map<String, dynamic>>{}.obs;

  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  var totalAmount = 0.0.obs; // Observable for the total amount
  var totalTipsAmount = 0.0.obs; // Observable for the total amount
  var totalTipsplusAmount = 0.0.obs; // Observable for the total amount
  bool isPrinting = false; // Prevent duplicate print jobs

  @override
  void onInit() async {
    super.onInit();
    groupTransactions();
    calculateTipsplusTotalAmount();
    calculateTotalAmount();
    calculateTotalTipsAmount();
    Get.closeAllSnackbars();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> groupTransactions() async {
    try {
      print("Fetching data for grouping...");
      final prefs = await SharedPreferences.getInstance();

      // Fetch grouped data from DatabaseHelper
      List<Map<String, dynamic>> data =
          await dbHelper.groupTransactionsByPump(prefs.getInt('shift_id') ?? 0);

      if (data.isNotEmpty) {
        print("Data fetched successfully. Processing grouped data...");
        print("data----->${data}");

        // Process grouped data and assign it to the observable
        Map<String, Map<String, dynamic>> processedData = {};

        for (var item in data) {
          String pumpNo = item['pumpNo']; // Extract pumpNo

          // Add the data into the processedData map
          processedData[pumpNo] = item;
        }

        // Assign the processed data to the observable
        groupedTransactions.assignAll(processedData);

        print("Grouped transactions: $groupedTransactions");
      } else {
        print("No data available to group.");
      }
    } catch (e) {
      print("Error while grouping transactions by pumpNo: $e");
    }
  }

  void printReceipt() async {
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

      String alignLeftRightpump(String left, String right, {int indent = 0}) {
        int spaces = receiptWidth - left.length - right.length - indent;
        spaces = spaces > 0 ? spaces : 1; // Ensure at least one space
        return ' ' * indent + left + ' ' * spaces + right;
      }

      String alignRight(String label, dynamic value, {int indent = 0}) {
        final valueStr = value.toString();
        final padding = (receiptWidth - label.length - valueStr.length - indent)
            .clamp(0, receiptWidth - label.length);
        return ' ' * indent + label + ' ' * padding + valueStr;
      }

      // Load logo and encode to base64
      final bytes = await rootBundle.load('media/new_logo_recet.jpg');
      final base64String = base64Encode(Uint8List.view(bytes.buffer));

      var pump_content = '';

      // Add dynamic transaction details

      groupedTransactions.forEach((pumpNo, data) {
        if (data != null) {
          final transactionCount = data['transactionCount'] ?? 0;
          final totalAmount = data['totalAmount'] ?? 0.0;
          final totalTips = data['totalTips'] ?? 0.0;

          pump_content += '''
${alignLeftRightpump("Pump No:", pumpNo.toString())}
${alignLeftRightpump("Number of Transactions:", transactionCount.toString(), indent: 2)}
${alignLeftRightpump("Total Amount:", totalAmount.toStringAsFixed(2), indent: 2)}
${alignLeftRightpump("Total Tips:", totalTips.toStringAsFixed(2), indent: 2)}

''';
        }
      });
      print("pump_content${pump_content}");

      // receiptContent.add(pump_content);
      var receipt_totals = '''
${alignLeftRight("Total Amount:", totalAmount.value.toStringAsFixed(2))}
${alignLeftRight("Total Tips:", totalTipsAmount.value.toStringAsFixed(2))}
${alignLeftRight("Totals:", totalTipsplusAmount.value.toStringAsFixed(2))}
''';
      print("receipt_totals${receipt_totals}");
      // receiptContent.add(receipt_totals);

      List<String> receiptContent = [
        '',
        centerText(customController.config['station_name'] ?? ''),
        centerText(customController.config['station_address'] ?? ''),
        centerText(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())),
        '',
        pump_content,
        receipt_totals,
        '',
        'Thank you for your visit.',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ];

      print("receiptContent---->${receiptContent}");

      // print("Receipt Content: $receiptContent");

      // Invoke native printing method with receiptContent as a single string
      final result = await _channel.invokeMethod('printReceipt', {
        'receiptContent': receiptContent,
        'image': base64String,
      });
    } catch (e) {
      print("An error occurred during printing: $e");
    } finally {
      // customController.amountVal.value = 0.0;
      Get.offAllNamed("/Home");
    }
  }

  // void printReceipt() async {
  //   if (isPrinting) {
  //     print("Print job already in progress. Please wait.");
  //     return;
  //   }

  //   isPrinting = true;

  //   try {
  //     // Initialize printer
  //     await FlutterPaxPrinterUtility.init;

  //     // Print the image/logo
  //     await FlutterPaxPrinterUtility.printImageAsset(
  //         "media/new_logo_recet.jpg");
  //     await FlutterPaxPrinterUtility.printStr("\n\n", null);

  //     // Prepare static receipt content
  //     List<String> receiptContent = [
  //       "Station Name:${customController.config['station_name']}",
  //       "",
  //       "Location: Egypt, Cairo",
  //       "",
  //       "Date: ${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
  //       "",
  //       "-------------------------------",
  //     ];

  //     // Define a fixed width for alignment
  //     const int lineWidth = 30;

  //     // Function to align text to the right
  //     String alignRight(String label, dynamic value, {int indent = 0}) {
  //       final valueStr = value.toString();
  //       final padding = (lineWidth - label.length - valueStr.length - indent)
  //           .clamp(0, lineWidth - label.length);
  //       return ' ' * indent + label + ' ' * padding + valueStr;
  //     }

  //     // Dynamic transaction details
  //     groupedTransactions.forEach((pumpNo, data) {
  //       if (data != null) {
  //         final transactionCount = data['transactionCount'] ?? 0;
  //         final totalAmount = data['totalAmount'] ?? 0.0;
  //         final totalTips = data['totalTips'] ?? 0.0;

  //         receiptContent.addAll([
  //           alignRight("Pump No:", pumpNo),
  //           alignRight("Number of Transactions:", transactionCount, indent: 4),
  //           alignRight("Total Amount:", totalAmount.toStringAsFixed(2),
  //               indent: 4),
  //           alignRight("Total Tips:", totalTips.toStringAsFixed(2), indent: 4),
  //           "-------------------------------",
  //         ]);
  //       }
  //     });

  //     // Add thank you message
  //     receiptContent.addAll([
  //       "",
  //       alignRight("Total Amount:", totalAmount.value..toStringAsFixed(2)),
  //       alignRight("Total Tips: ", totalTipsAmount.value..toStringAsFixed(2)),
  //       alignRight("Totals: ", totalTipsplusAmount.value..toStringAsFixed(2)),
  //       "",
  //       "",
  //       "",
  //       "",
  //       "",
  //       "",
  //     ]);

  //     // Print each line
  //     for (String line in receiptContent) {
  //       await FlutterPaxPrinterUtility.printStr(line + "\n", null);
  //     }

  //     // Complete the print job
  //     await FlutterPaxPrinterUtility.step(10);
  //     await FlutterPaxPrinterUtility.start();
  //   } catch (e) {
  //     print("An error occurred during printing: $e");
  //   } finally {
  //     isPrinting = false;
  //     customController.amountVal.value = 0.0;
  //     Get.offNamed("/Home");
  //     await customController.fetchToken();
  //   }
  // }

  calculateTotalAmount() async {
    final dbHelper = DatabaseHelper();
    final prefs = await SharedPreferences.getInstance();

    totalAmount.value =
        await dbHelper.getTotalAmount(prefs.getInt('shift_id') ?? 0);
    print(
        "Total Amount:---------------- ${totalAmount.value}"); // Print the total amount
  }

  calculateTotalTipsAmount() async {
    final prefs = await SharedPreferences.getInstance();

    final dbHelper = DatabaseHelper();
    totalTipsAmount.value =
        await dbHelper.getTotalTipsAmount(prefs.getInt('shift_id') ?? 0);
    print(
        "Total Amount--------->> ${totalTipsAmount.value}"); // Print the total amount
  }

  calculateTipsplusTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();

    final dbHelper = DatabaseHelper();
    totalTipsplusAmount.value =
        await dbHelper.getTotalTipsAndAmount(prefs.getInt('shift_id') ?? 0);
    print(
        "Total calculateTipsplusTotalAmount----------> ${totalAmount.value}"); // Print the total amount
  }
}
