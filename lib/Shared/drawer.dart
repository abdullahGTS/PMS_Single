import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import 'package:intl/intl.dart';

import '../Local/Local_Controller.dart';
import '../Receipt/Receipt_Controller.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final Local = Get.put(LocalController());

  // final receiptController = Get.put(ReceiptController());

  @override
  Widget build(BuildContext context) {
    print(
        " customController.managershift.value${customController.managershift.value}");
    return Drawer(
      backgroundColor: const Color(0xFF166E36),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 40,
          ),
          Container(
            padding:
                EdgeInsets.all(16.0), // Add some padding around the content
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  size: 40, // Adjust size as needed
                  color: Colors.white, // Optional: Change the icon color
                ),
                SizedBox(width: 16), // Space between icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Text(
                          customController.managershift.value,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        );
                      }),
                      Text(
                        '@' + 'Supervisor'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8), // Space between text and date
                      Text(
                        'Start_at'.tr +
                            ': ${customController.datetimeshift.value}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Obx(() {
                        return Text(
                          'S/N'.tr + ': ${customController.SerialNumber.value}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.home_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Home'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Get.offNamed("/Home");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.local_gas_station_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Fuels'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Get.offNamed("/verify");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.cloud_download_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Telecollect'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              customController.fetchToken();
              if (customController.isconnect.value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Collecting Config...'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    duration: Duration(
                        seconds:
                            2), // Duration for which the snackbar is visible
                    backgroundColor: Color.fromARGB(
                        255, 0, 0, 0), // Set background color to white
                    behavior: SnackBarBehavior
                        .floating, // Makes the snackbar float above the content
                  ),
                );
                // customController.sendtaxreid();
                // customController.sendShiftsToApi();
                customController.sendTransactionsToApi();
                // customController.sendtoupdateistaxed();
                // await closeController.checkthelastpos();
              } else {
                await customController.readConfigFromFile();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Reading Local Config...'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    duration: Duration(
                        seconds:
                            2), // Duration for which the snackbar is visible
                    backgroundColor: Color.fromARGB(
                        255, 0, 0, 0), // Set background color to white
                    behavior: SnackBarBehavior
                        .floating, // Makes the snackbar float above the content
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.power_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Force_Login'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              await customController.startConnection();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.layers_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Transactions | All'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Get.offNamed("/Transactions");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.library_add_check_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Transactions | Available'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Get.offNamed("/Verifyavailabletrx");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_chart_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Report | Transactions'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Get.offNamed("/Report");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_chart_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Report | Shifts'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Get.offNamed("/ReportShift");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.tune,
              color: Colors.white,
            ),
            title: Text(
              'Pump_Calibration'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Get.toNamed("/Mair");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.payments_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Settlement_trans'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              Get.toNamed('/VerifySetlemment');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.language_rounded,
              color: Colors.white,
            ),
            title: Obx(() => SwitchListTile(
                  activeColor: Color.fromARGB(255, 24, 24, 24),
                  title: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Arabic'.tr,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  value: Local.isArabic.value,
                  onChanged: (value) {
                    Local.isArabic.value = value;
                    Get.updateLocale(value
                        ? const Locale('ar', 'AE')
                        : const Locale('en', 'US'));
                  },
                )),
          ),
          Container(
            margin: EdgeInsets.only(right: 6, left: 6),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),

            // Set your desired background color
            child: ListTile(
              trailing: Icon(
                Icons.logout_rounded,
                color: Colors.white,
              ),
              title: Text(
                'Close_Shift'.tr,
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Get.toNamed('/VerifyCloseShift');
                // await customController.fetchToken();
                // print(
                //     "customController.isconnect.value--------${customController.isconnect.value}");
                // print(
                //     "customController.config.value${customController.config.value['shift_data']['status']}");
                // if (customController.isconnect.value) {
                //   var statusShift =
                //       customController.config.value['shift_data']['status'];
                //   var numShift =
                //       customController.config.value['shift_data']['shift_num'];
                //   var endShift =
                //       customController.config.value['shift_data']['endshift'];
                //   print("endShift${endShift}");
                //   print("statusShift${statusShift}");
                //   print("numShift${numShift}");
                //   if (statusShift == "opened") {
                //     await customController.sendShiftsToApi();

                //     await customController.sendCloseShift();
                //   } else {
                //     await customController.dbHelper
                //         .updateIsPortalShift(int.parse(numShift), "true");
                //     await customController.sendShiftsToApi();
                //     await customController.sendCloseShift();
                //   }
                // } else {
                //   Get.snackbar(
                //     "Error",
                //     "You should be online to close shift",
                //     backgroundColor: Colors.red,
                //     colorText: Colors.white,
                //   );
                // }
              },
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
