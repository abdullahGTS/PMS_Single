import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Shared/drawer.dart';
import 'Report_Controller.dart';
import 'package:intl/intl.dart';

class Report extends StatelessWidget {
  Report({super.key});
  final reprotController = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report_Transactions'.tr,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white, // Change Drawer icon color to white
          ),
          // Customize the AppBar color
        ),
        backgroundColor: const Color(0xFF2B2B2B),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          // Wrap the body with SingleChildScrollView
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: 200,
                child: Image.asset(
                  'media/new_logo2.png', // Path to your image
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Vertically center the content
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Horizontally center the content
                  children: [
                    Text(
                        "Station_Name".tr +
                            " : ${reprotController.customController.config['station_name']}",
                        style: TextStyle(color: Colors.white)),
                    const Text("Egypt, Cairo",
                        style: TextStyle(color: Colors.white)),
                    Text(
                      "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Obx(
                () {
                  return ListView.builder(
                    shrinkWrap:
                        true, // Ensures the ListView takes only as much space as needed
                    physics:
                        NeverScrollableScrollPhysics(), // Disables internal scrolling of the ListView
                    itemCount: reprotController.groupedTransactions.length,
                    itemBuilder: (context, index) {
                      // Get the current group (pumpNo)
                      final pumpNo = reprotController.groupedTransactions.keys
                          .elementAt(index);
                      final data = reprotController.groupedTransactions[pumpNo];

                      // Check if data is null
                      if (data == null) {
                        return SizedBox
                            .shrink(); // Return an empty widget if data is null
                      }

                      // Get the summarized data for this group
                      final transactionCount = data['transactionCount'] ?? 0;
                      final totalAmount = data['totalAmount'] ?? 0.0;
                      final totalTips = data['totalTips'] ?? 0.0;
                      print('transactionCount->>>>>>>>>>${transactionCount}');
                      print('totalAmount->>>>>>>>>>${totalAmount}');
                      print('totalTips->>>>>>>>>>${totalTips}');

                      return Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                        child: Column(
                          children: [
                            // Displaying pump details
                            Row(
                              children: [
                                Text(
                                  "Pump_No".tr + ":",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "$pumpNo",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Number_of_Transactions".tr + ": ",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "$transactionCount",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Total_Amount".tr + ":",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${totalAmount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Total_Tips".tr + ": ",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${totalTips.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Total_Amount".tr + ": ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${reprotController.totalAmount.value.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Total_Tips".tr + ": ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${reprotController.totalTipsAmount.value.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Totals".tr + ": ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${(reprotController.totalAmount.value + reprotController.totalTipsAmount.value).toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: reprotController
                    .printReceipt, // Call printReceipt on button press
                child: Text("Print_Receipt".tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
