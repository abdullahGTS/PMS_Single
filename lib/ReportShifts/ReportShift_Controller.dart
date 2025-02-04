import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Models/transactiontable.dart';
import '../models/database_helper.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';

class ReportshiftController extends GetxController {
  final DatabaseHelper dbHelper = DatabaseHelper();
  var shifts = [].obs; // Observable for raw shifts data
  bool isPrinting = false; // Prevent duplicate print jobs
  static const _channel = MethodChannel('com.example.pms/method');
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  @override
  void onInit() async {
    super.onInit();
    // Fetch shifts data from the database
    var result = await dbHelper.getLastWeekShifts();

    // Filter and prepare shifts for API
    shifts.value = result
        .map((shift) => {
              'shift_num': shift['id'],
              'start_date': shift['startshift'],
              'end_date': shift['endshift'],
              'total_amount': shift['totalamount'],
              'total_tips': shift['totaltips'],
              'total': shift['totalmoney'],
              'total_transactions': shift['transnum'],
              'supervisor': shift['supervisor'],
              'status': shift['status'],
            })
        .toList();

    print("shifts.value${shifts.value}");
    Get.closeAllSnackbars();
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

      final bytes = await rootBundle.load('media/new_logo_recet.jpg');
      final base64String = base64Encode(Uint8List.view(bytes.buffer));
      String alignRight(String label, dynamic value, {int indent = 0}) {
        final valueStr = value.toString();
        final padding = (receiptWidth - label.length - valueStr.length - indent)
            .clamp(0, receiptWidth - label.length);
        return ' ' * indent + label + ' ' * padding + valueStr;
      }

      var shiftdata = '';
      shifts.value.forEach((shift) {
        shiftdata += '''
${alignLeftRight("Shift ID:", shift['shift_num'].toString())}
${alignLeftRight("Supervisor:", shift['supervisor'].toString())}
${alignLeftRight("Start Shift:", shift['start_date'])}
${alignLeftRight("End Shift:", shift['end_date'])}
${alignLeftRight("Total Amount:", shift['total_amount'].toString())}
${alignLeftRight("Total Tips:", shift['total_tips'].toString())}
${alignLeftRight("Total Money:", shift['total'].toString())}
${alignLeftRight("Status Shift:", shift['status'])}
--------------------------------''';
      });

      List<String> receiptContent = [
        '',
        '',
        centerText(customController.config['station_name'] ?? ''),
        centerText(customController.config['station_address'] ?? ''),
        centerText(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())),
        '',
        shiftdata,
        '',
        'Thank you for your visit.',
        '',
        '',
        '',
        '',
        '',
        '',
      ];
      print(
          'receiptContent.length->${utf8.encode(receiptContent.toString()).length}');
      final result = await _channel.invokeMethod('printReceipt', {
        'receiptContent': receiptContent,
        'image': base64String,
      });
    } catch (e) {
      print("An error occurred during printing: $e");
    } finally {
      customController.amountVal.value = 0.0;
      Get.offAllNamed("/Home");
    }
  }
}
