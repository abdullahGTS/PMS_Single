import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../CustomAppbar/CustomAppbar.dart';
import '../Models/transactiontable.dart';
import '../ReportShifts/ReportShift_Controller.dart';
import '../Shared/drawer.dart';

class Reportshift extends StatelessWidget {
  Reportshift({super.key});
  final shiftreprotController = Get.find<ReportshiftController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent navigation back
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Report_shift'.tr,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white, // Change Drawer icon color to white
          ),
        ),
        backgroundColor: const Color(0xFF2B2B2B),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
                width: 200,
                child: Image.asset(
                  'media/new_logo2.png',
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        "Station_Name".tr +
                            " :${shiftreprotController.customController.config['station_name']}",
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
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: shiftreprotController.shifts.value.length,
                    itemBuilder: (context, index) {
                      var shift = shiftreprotController.shifts.value[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 10.0, right: 20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Shift_id".tr + ":",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${shift['shift_num']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Supervisor".tr + ":",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${shift['supervisor']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Start_Shift".tr + ":",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${shift['start_date']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "End_Shift".tr + ":",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      shift['end_date']?.isNotEmpty ?? false
                                          ? "${shift['end_date']}"
                                          : "Not Closed until now ",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total_Amount".tr + ":",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${shift['total_amount']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total_Tips".tr + ":",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${shift['total_tips']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total_Money".tr + ":",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "${shift['total']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Status".tr,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      ("${shift['status']}").tr,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              ElevatedButton(
                onPressed: shiftreprotController.printReceipt,
                child: Text("Print_Receipt".tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
