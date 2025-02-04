import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Shared/drawer.dart';
import 'Transactions_Controller.dart';

class Transactions extends StatelessWidget {
  Transactions({super.key});
  final alltransController = Get.find<TransactionsController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        appBar: const CustomAppBar(),
        drawer: CustomDrawer(),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () {
                    return ListView.builder(
                      itemCount: alltransController
                          .customController.filteredTransactions.length,
                      itemBuilder: (context, index) {
                        // Get the current transaction
                        final transaction = alltransController
                            .customController.filteredTransactions[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Color(0xED166E36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            child: Column(
                              children: [
                                Row(children: [
                                  // Expanded(
                                  //     flex: 1,
                                  //     child: Center(
                                  //       child: Icon(
                                  //         Icons.wallet,
                                  //         size: 50,
                                  //         color: Colors.white,
                                  //       ),
                                  //     )),
                                  Expanded(
                                    // flex: 4,
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons
                                                                .local_gas_station,
                                                            color: Colors.white,
                                                            size: 20,
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                            "Pump".tr +
                                                                " ${transaction['pumpNo']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons
                                                                .payments_rounded,
                                                            color: Colors.white,
                                                            size: 20,
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                            "AMT".tr +
                                                                " ${transaction['amount']} " +
                                                                "EGP".tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons.numbers,
                                                            color: Colors.white,
                                                            size: 20,
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                            "TRX".tr +
                                                                " ${transaction['transactionSeqNo']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      transaction['payment_type'] ==
                                                              'Bank'
                                                          ? Expanded(
                                                              flex: 1,
                                                              child: Icon(
                                                                Icons
                                                                    .credit_card_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              ))
                                                          : Expanded(
                                                              flex: 1,
                                                              child: Icon(
                                                                Icons
                                                                    .account_balance_wallet_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                            "Type".tr +
                                                                " " +
                                                                "${transaction['payment_type']}"
                                                                    .tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  ),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? SizedBox(
                                                          height: 10,
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: Icon(
                                                                  Icons
                                                                      .numbers_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                )),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                                flex: 4,
                                                                child: Text(
                                                                  "ecrRefNO".tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? SizedBox(
                                                          height: 10,
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: Icon(
                                                                  Icons
                                                                      .numbers_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                )),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                                flex: 4,
                                                                child: Text(
                                                                  "voucherNo"
                                                                      .tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? SizedBox(
                                                          height: 10,
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? Row(
                                                          children: [
                                                            Expanded(
                                                                flex: 1,
                                                                child: Icon(
                                                                  Icons
                                                                      .numbers_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20,
                                                                )),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                                flex: 4,
                                                                child: Text(
                                                                  "batchNo".tr,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons
                                                                .local_gas_station,
                                                            color: Colors.white,
                                                            size: 20,
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                            "Nozzle".tr +
                                                                " ${transaction['nozzleNo']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons
                                                                .payments_rounded,
                                                            color: Colors.white,
                                                            size: 20,
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                            "Tip".tr +
                                                                " ${transaction['TipsValue']} " +
                                                                "EGP".tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons.numbers,
                                                            color: Colors.white,
                                                            size: 20,
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                          flex: 4,
                                                          child: Text(
                                                            "Stan".tr +
                                                                " ${transaction['Stannumber']}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                          flex: 1,
                                                          child: Icon(
                                                            Icons
                                                                .pending_actions_rounded,
                                                            color: Colors.white,
                                                            size: 20,
                                                          )),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          "Status".tr +
                                                              " " +
                                                              "${transaction['statusvoid']}"
                                                                  .tr,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? SizedBox(
                                                          height: 10,
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                                flex: 4,
                                                                child: Text(
                                                                  "${transaction['ecrRef']}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? SizedBox(
                                                          height: 10,
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                                flex: 4,
                                                                child: Text(
                                                                  "${transaction['voucherNo']}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? SizedBox(
                                                          height: 10,
                                                        )
                                                      : SizedBox(),
                                                  transaction['payment_type'] ==
                                                          'Bank'
                                                      ? Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Expanded(
                                                                flex: 4,
                                                                child: Text(
                                                                  "${transaction['batchNo']}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ]),
                                Row(
                                  children: [
                                    Expanded(
                                      child: transaction['payment_type'] ==
                                              'Bank'
                                          ? transaction['statusvoid'] ==
                                                  "complete"
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 5),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF2B2B2B),
                                                          ),
                                                          onPressed: () {
                                                            alltransController
                                                                .showVoidConfirmationDialog(
                                                              context,
                                                              transaction[
                                                                  'Stannumber'],
                                                              double.parse(
                                                                  transaction[
                                                                      'amount']),
                                                              transaction[
                                                                  'transactionSeqNo'],
                                                              transaction[
                                                                  'ecrRef'],
                                                            );
                                                          },
                                                          child: const Text(
                                                            "Void",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF2B2B2B),
                                                          ),
                                                          onPressed: () {
                                                            alltransController
                                                                .reprint(
                                                                    transaction[
                                                                        'ecrRef'],
                                                                    transaction[
                                                                        'voucherNo']);
                                                            // alltransController
                                                            //     .showVoidConfirmationDialog(
                                                            //   context,
                                                            //   transaction[
                                                            //       'Stannumber'],
                                                            //   double.parse(
                                                            //       transaction[
                                                            //           'amount']),
                                                            //   transaction[
                                                            //       'transactionSeqNo'],
                                                            // );
                                                          },
                                                          child: const Text(
                                                            "Re-print",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : transaction['statusvoid'] ==
                                                      "progress"
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 5),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF2B2B2B),
                                                        ),
                                                        onPressed: () {
                                                          // Initialize the PreSaleValueController

                                                          // Navigate to the /ChoosePaymentaftervoid page and pass presalecontroller.value as an argument
                                                          alltransController
                                                              .resetTransaction(
                                                                  transaction);
                                                          Get.toNamed(
                                                              '/ResetPayment');
                                                        },
                                                        child: Text(
                                                          "Set_Transaction"
                                                              .tr
                                                              .tr, // Or any other label you'd prefer
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox()
                                          : SizedBox(),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}












///////////////////////////////////////////////////////////////////////////////////
//  [
//                                 Row(children: [
//                                   Expanded(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: Text(
//                                         "Pump No: ${transaction['pumpNo']}, "
//                                         "Nozzle No: ${transaction['nozzleNo']}, "
//                                         "Amount: ${transaction['amount']}, "
//                                         "status: ${transaction['statusvoid']}, "
//                                         "transsec: ${transaction['transactionSeqNo']}, "
//                                         "Type: ${transaction['payment_type']}, "
//                                         "Stannumber: ${transaction['Stannumber']},"
//                                         "Tips: ${transaction['TipsValue']}",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: transaction['payment_type'] ==
//                                               'Bank'
//                                           ? transaction['statusvoid'] ==
//                                                   "complete"
//                                               ? Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(
//                                                       horizontal: 20,
//                                                       vertical: 5),
//                                                   child: ElevatedButton(
//                                                     style: ElevatedButton
//                                                         .styleFrom(
//                                                       backgroundColor:
//                                                           const Color(
//                                                               0xFF2B2B2B),
//                                                     ),
//                                                     onPressed: () {
//                                                       alltransController
//                                                           .showVoidConfirmationDialog(
//                                                         context,
//                                                         transaction[
//                                                             'Stannumber'],
//                                                         double.parse(
//                                                             transaction[
//                                                                 'amount']),
//                                                         transaction[
//                                                             'transactionSeqNo'],
//                                                       );
//                                                     },
//                                                     child: const Text(
//                                                       "Void",
//                                                       style: TextStyle(
//                                                           color: Colors.white),
//                                                     ),
//                                                   ),
//                                                 )
//                                               : transaction['statusvoid'] ==
//                                                       "progress"
//                                                   ? Padding(
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 20,
//                                                           vertical: 5),
//                                                       child: ElevatedButton(
//                                                         style: ElevatedButton
//                                                             .styleFrom(
//                                                           backgroundColor:
//                                                               const Color(
//                                                                   0xFF2B2B2B),
//                                                         ),
//                                                         onPressed: () {
//                                                           // Initialize the PreSaleValueController

//                                                           // Navigate to the /ChoosePaymentaftervoid page and pass presalecontroller.value as an argument
//                                                           alltransController
//                                                               .resetTransaction(
//                                                                   transaction);
//                                                           Get.toNamed(
//                                                               '/ResetPayment');
//                                                         },
//                                                         child: const Text(
//                                                           "Set Transaction", // Or any other label you'd prefer
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : SizedBox()
//                                           : SizedBox(),
//                                     )
//                                   ],
//                                 ),
//                               ]
                              ////////