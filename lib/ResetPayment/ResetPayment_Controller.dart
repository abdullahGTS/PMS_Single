import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Receipt/Receipt_Controller.dart';
import '../models/database_helper.dart';

class ResetPaymentController extends GetxController {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final receiptController = Get.put(ReceiptController());
  final DatabaseHelper dbHelper = DatabaseHelper();
  var selectedPaymentOption = ''.obs;

  static const _channel = MethodChannel('com.example.pms/method');

  @override
  void onInit() {
    super.onInit();
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

  // Method to select a payment option
  void selectPaymentOption(BuildContext context, String option) async {
    selectedPaymentOption.value = option;
    print(option);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPaymentOption', selectedPaymentOption.value);

    print("optionoption${option}");
    if (option == "Bank_Card".tr) {
      var sum = customController.amountVal.value +
          double.parse(customController.TipsValue.value);
      await startTrans(sum);
    }
    if (option == "Cash".tr) {
      customController.paymentType.value = 1;

      // customController.saveTransaction(1);
      printCashReceipt();
    }
    if (option == "Fleet".tr) {
      customController.paymentType.value = 4;

      // customController.saveTransaction(4);
      printFleetReceipt();
    }
    if (option == "Bank_Point".tr) {
      customController.paymentType.value = 5;

      // customController.saveTransaction(5);
      printBankPointsReceipt();
    }
  }

  startTrans(double amount) async {
    try {
      // Send the amount for transaction initiation
      var adjustedAmount = amount * 100; // Convert to minor units
      var ecrRefNo =
          '${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}${customController.transactionSeqNo.value}${customController.trxSeqNoCounter++}';
      print("ecrRef----------->${ecrRefNo}");
      await _channel.invokeMethod(
          'startTrans', {'amount': adjustedAmount, 'ecrRefNo': ecrRefNo});
      // await _channel.invokeMethod('startTrans', {'amount': adjustedAmount});

      // Wait for the transaction result
      _channel.setMethodCallHandler((call) async {
        if (call.method == "onTransactionResult") {
          final Map<String, dynamic> response =
              Map<String, dynamic>.from(call.arguments);

          // Handle transaction result
          if (response.containsKey("error")) {
            print("Transaction Error: ${response['error']}");
          } else {
            print("Transaction Successful: $response");
            if (response['cardNo'] == 'Unknown') {
              customController.stanNumber.value = 0;
              return false;
            } else {
              print('customController.stanNumber.value ${response['stan']}');
              print('customController.stanNumber.value ${response}');
              customController.stanNumber.value = response['stan'];
              customController.voucherNo.value = response['voucherNo'];
              customController.ecrRef.value = response['ecrRef'];
              customController.batchNo.value = response['batchNo'];
              print(
                  'customController.stanNumber.value ${customController.stanNumber.value}');
              customController.paymentType.value = 2;
              // got to receipt
              dbHelper.updateStatusvoid(
                  customController.transactionSeqNo.value, 'complete');
              dbHelper.updatePaymentType(
                  customController.transactionSeqNo.value, 'Bank');
              dbHelper.updateStannumber(customController.transactionSeqNo.value,
                  response['stan'].toString());
              dbHelper.updateIsPortal(
                  customController.transactionSeqNo.value, "false");
              dbHelper.updateECRRef(
                  customController.transactionSeqNo.value, response['ecrRef']);
              dbHelper.updateVoucherNo(customController.transactionSeqNo.value,
                  response['voucherNo']);
              dbHelper.updateBatchNo(
                  customController.transactionSeqNo.value, response['batchNo']);

              if (customController.isconnect.value) {
                customController.sendTransactionToApi();
              }
              receiptController.printReceipt();
            }
          }
        }
      });
    } on PlatformException catch (e) {
      print('Error initiating transaction: ${e.message}');
    }
  }

  printCashReceipt() {
    customController.stanNumber.value = 0;
    // customController.paymentType.value = 1;
    // got to receipt
    print("Transaction Successful Cash");
    dbHelper.updateStatusvoid(
        customController.transactionSeqNo.value, 'complete');
    dbHelper.updatePaymentType(customController.transactionSeqNo.value, 'Cash');
    dbHelper.updateStannumber(customController.transactionSeqNo.value, '0');
    dbHelper.updateIsPortal(customController.transactionSeqNo.value, "false");

    if (customController.isconnect.value) {
      customController.sendTransactionToApi();
    }
    receiptController.printReceipt();
    // receiptController.printReceipt();
  }

  printFleetReceipt() {
    customController.stanNumber.value = 0;
    // customController.paymentType.value = 1;
    // got to receipt
    print("Transaction Successful Fleet");
    dbHelper.updateStatusvoid(
        customController.transactionSeqNo.value, 'complete');
    dbHelper.updatePaymentType(
        customController.transactionSeqNo.value, 'Fleet');
    dbHelper.updateStannumber(customController.transactionSeqNo.value, '0');
    dbHelper.updateIsPortal(customController.transactionSeqNo.value, "false");

    if (customController.isconnect.value) {
      customController.sendTransactionToApi();
    }
    receiptController.printReceipt();
    // receiptController.printReceipt();
  }

  printBankPointsReceipt() {
    customController.stanNumber.value = 0;
    // customController.paymentType.value = 1;
    // got to receipt
    print("Transaction Successful Bank Points");
    dbHelper.updateStatusvoid(
        customController.transactionSeqNo.value, 'complete');
    dbHelper.updatePaymentType(
        customController.transactionSeqNo.value, 'Bank Point');
    dbHelper.updateStannumber(customController.transactionSeqNo.value, '0');
    dbHelper.updateIsPortal(customController.transactionSeqNo.value, "false");

    if (customController.isconnect.value) {
      customController.sendTransactionToApi();
    }
    receiptController.printReceipt();
    // receiptController.printReceipt();
  }
}
