import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../models/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsController extends GetxController {
  var transactions = <String>[].obs;
  // final RxList<dynamic> filteredTransactions = <dynamic>[].obs;
  var searchQuery = ''.obs;
  static const _channel = MethodChannel('com.example.pms/method');
  final DatabaseHelper dbHelper = DatabaseHelper();
  final customController = Get.find<CustomAppbarController>();

  @override
  void onInit() async {
    super.onInit();
    // await customController.fetchTransactions();
    final prefs = await SharedPreferences.getInstance();

    await customController
        .fetchTransactionsByshift(prefs.getInt('shift_id') ?? 0);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> voidTrans(BuildContext context, String amount,
      String transactionSeqNo, String stannumber, String ecrRef) async {
    try {
      await _channel.invokeMethod<String>('voidTrans', {'ecrRefNo': ecrRef});

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

            print('Response from native code (voidTrans): $response');
            await dbHelper.updateStatusvoid(transactionSeqNo, 'progress');
            await dbHelper.updateStannumber(transactionSeqNo, '0');
            // await dbHelper.updateECRRef(transactionSeqNo, response['ecrRef']);
            await dbHelper.updateVoucherNo(
                transactionSeqNo, response['voucherNo']);
            await dbHelper.updateBatchNo(transactionSeqNo, response['batchNo']);
            customController.fetchTransactions();
          }
        }
      });

      // await dbHelper.updateStatusvoid(transactionSeqNo, 'progress');
      // await dbHelper.updateStannumber(transactionSeqNo, '0');
      // customController.fetchTransactions();

      // Navigate to ChoosePayment page using Get.to

      // Get.toNamed('/ChoosePayment', arguments: amount);
    } on PlatformException catch (e) {
      print('Error invoking voidTrans: ${e.message}');
    }
  }

  void showVoidConfirmationDialog(BuildContext context, String stannumber,
      double amount, String transactionSeqNo, String ecrRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Void Transaction'),
          content: Text(
            stannumber.isEmpty
                ? 'Stannumber not found.'
                : 'Are you sure you want to void this transaction with Stannumber: $stannumber and ecrRefNo: ${ecrRef} ?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without doing anything
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (stannumber.isNotEmpty) {
                  // Proceed with voiding the transaction if Stannumber is found
                  voidTrans(context, amount.toString(), transactionSeqNo,
                      stannumber, ecrRef);
                } else {
                  // Handle case where Stannumber is not found, if needed
                  print('Stannumber is missing, cannot proceed with void.');
                }
              },
            ),
          ],
        );
      },
    );
  }

  resetTransaction(var transaction) {
    print('Abdullah transaction ${transaction}');
    customController.pumpNo.value = transaction['pumpNo'];
    customController.fdCTimeStamp.value = transaction['fdCTimeStamp'];
    customController.nozzleNo.value = transaction['nozzleNo'];
    customController.transactionSeqNo.value = transaction['transactionSeqNo'];
    customController.amountVal.value = double.parse(transaction['amount']);
    customController.volume.value = double.parse(transaction['volume']);
    customController.unitPrice.value = double.parse(transaction['unitPrice']);
    customController.volumeProduct1.value =
        double.parse(transaction['volumeProduct1']);
    customController.volumeProduct2.value =
        double.parse(transaction['volumeProduct2']);
    customController.productNo1.value = int.parse(transaction['productNo1']);
    customController.productNo.value = transaction['productNo'];
    customController.productName.value = transaction['productName'];
    customController.TipsValue.value = transaction['TipsValue'];
    customController.paymentType.value = 2;
    customController.stanNumber.value = int.parse(transaction['Stannumber']);
  }

  reprint(ecrRef, voucherNo) async {
    const _channel = MethodChannel('com.example.pms/method');
    final String response = await _channel.invokeMethod<String>(
            'reprintTransMsg',
            {"ecrRef": "${ecrRef}", "voucherNo": voucherNo}) ??
        'No response';
    print("response Home ----> ${response}");
  }
}
