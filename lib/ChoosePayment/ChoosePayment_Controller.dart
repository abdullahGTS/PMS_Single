import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';

class ChoosePaymentController extends GetxController {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  var selectedPaymentOption = ''.obs;

  static const _channel = MethodChannel('com.example.pms/method');

  @override
  void onInit() {
    super.onInit();
    Get.closeAllSnackbars();
    print(
        'customController.TipsValue.value${customController.TipsValue.value}');
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
    print('selectPaymentOption${option}');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPaymentOption', selectedPaymentOption.value);

    print("optionoption${option}");
    if (customController.issupervisormaiar.value) {
      customController.paymentType.value = 3;

      customController.saveTransaction(3);
      printCashReceipt();
    } else {
      if (option == "Bank_Card".tr) {
        print(
            "customController.amountVal.value.toInt()${customController.amountVal.value.toInt()}");
        print(
            "customController.TipsValue.value.toInt()${customController.TipsValue.value}");
        print(
            "sum${customController.amountVal.value + double.parse(customController.TipsValue.value)}");
        var sum = customController.amountVal.value +
            double.parse(customController.TipsValue.value);
        await startTrans(sum);
      }
      if (option == "Cash".tr) {
        customController.paymentType.value = 1;

        customController.saveTransaction(1);
        printCashReceipt();
      }
      if (option == "Fleet".tr) {
        customController.paymentType.value = 4;

        customController.saveTransaction(4);
        printCashReceipt();
      }
      if (option == "Bank_Point".tr) {
        customController.paymentType.value = 5;

        customController.saveTransaction(5);
        printCashReceipt();
      }
    }
  }

  startTrans(double amount) async {
    try {
      // Send the amount for transaction initiation
      var adjustedAmount = amount * 100; // Convert to minor units
      var ecrRefNo =
          '${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}${customController.transactionSeqNo.value}${customController.trxSeqNoCounter}';
      await _channel.invokeMethod(
          'startTrans', {'amount': adjustedAmount, 'ecrRefNo': ecrRefNo});

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
            customController.paymentType.value = 2;

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
              customController.saveTransaction(2);
              // got to receipt
              Get.toNamed('/Receipt');
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
    Get.toNamed('/Receipt');
  }
}
