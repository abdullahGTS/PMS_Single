import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Shared/drawer.dart';
import 'AvailableTransactions_Controller.dart';

class Availabletransactions extends StatelessWidget {
  Availabletransactions({super.key});
  final alltransController = Get.find<AvailabletransactionsController>();

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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     await alltransController.GetAllTransaction();
        //   },
        //   child: Icon(Icons.add),
        // ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () {
                    return alltransController.AvailableTrxList.length <= 0
                        ? alltransController.NoAvailableTrx.value != ""
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${alltransController.NoAvailableTrx.value}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                              ))
                            : Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                        : ListView.builder(
                            itemCount:
                                alltransController.AvailableTrxList.length,
                            itemBuilder: (context, index) {
                              final transaction =
                                  alltransController.AvailableTrxList[index];
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
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                                                  "Pump".tr +
                                                                      " ${transaction['PumpNo']}",
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
                                                                      .water_drop_rounded,
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
                                                                  ("${transaction['ProductName']}"
                                                                      .tr),
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
                                                                  "State".tr +
                                                                      " ${transaction['State']}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        ),
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
                                                                  "Nozzle".tr +
                                                                      " ${transaction['NozzleNo']}",
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
                                                                  "TRX".tr +
                                                                      " ${transaction['TransactionSeqNo']}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Row(
                                                          children: [],
                                                        ),
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
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                right: 10.0,
                                                bottom: 10.0),
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  await alltransController
                                                      .TransactionDetails(
                                                          transaction[
                                                              'TransactionSeqNo']);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFF2B2B2B),
                                                ),
                                                child: Text(
                                                  'Details'.tr,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                          )),
                                        ],
                                      ),
                                      //   Row(
                                      //     children: [
                                      //       Expanded(
                                      //         child: transaction['payment_type'] ==
                                      //                 'Bank'
                                      //             ? transaction['statusvoid'] ==
                                      //                     "complete"
                                      //                 ? Padding(
                                      //                     padding: const EdgeInsets
                                      //                         .symmetric(
                                      //                         horizontal: 20,
                                      //                         vertical: 5),
                                      //                     child: ElevatedButton(
                                      //                       style: ElevatedButton
                                      //                           .styleFrom(
                                      //                         backgroundColor:
                                      //                             const Color(
                                      //                                 0xFF2B2B2B),
                                      //                       ),
                                      //                       onPressed: () {
                                      //                         alltransController
                                      //                             .showVoidConfirmationDialog(
                                      //                           context,
                                      //                           transaction[
                                      //                               'Stannumber'],
                                      //                           double.parse(
                                      //                               transaction[
                                      //                                   'amount']),
                                      //                           transaction[
                                      //                               'transactionSeqNo'],
                                      //                         );
                                      //                       },
                                      //                       child: const Text(
                                      //                         "Void",
                                      //                         style: TextStyle(
                                      //                             color: Colors.white),
                                      //                       ),
                                      //                     ),
                                      //                   )
                                      //                 : transaction['statusvoid'] ==
                                      //                         "progress"
                                      //                     ? Padding(
                                      //                         padding: const EdgeInsets
                                      //                             .symmetric(
                                      //                             horizontal: 20,
                                      //                             vertical: 5),
                                      //                         child: ElevatedButton(
                                      //                           style: ElevatedButton
                                      //                               .styleFrom(
                                      //                             backgroundColor:
                                      //                                 const Color(
                                      //                                     0xFF2B2B2B),
                                      //                           ),
                                      //                           onPressed: () {
                                      //                             // Initialize the PreSaleValueController

                                      //                             // Navigate to the /ChoosePaymentaftervoid page and pass presalecontroller.value as an argument
                                      //                             alltransController
                                      //                                 .resetTransaction(
                                      //                                     transaction);
                                      //                             Get.toNamed(
                                      //                                 '/ResetPayment');
                                      //                           },
                                      //                           child: const Text(
                                      //                             "Set Transaction", // Or any other label you'd prefer
                                      //                             style: TextStyle(
                                      //                                 color:
                                      //                                     Colors.white),
                                      //                           ),
                                      //                         ),
                                      //                       )
                                      //                     : SizedBox()
                                      //             : SizedBox(),
                                      //       )
                                      //     ],
                                      //   ),
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
