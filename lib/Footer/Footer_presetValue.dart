// ignore_for_file: unrelated_type_equality_checks, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/Home/Home_Controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../PresetValue/PresetValue_Controller.dart';

class FooterPresetValue extends StatelessWidget {
  final presalecontroller =
      Get.find<PresetvalueController>(); // Get the PreSaleValueController
  final homeController = Get.put(HomeController()); // Get the HomeController
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  var andriodid;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 24, 24, 24),
      width: double.infinity,
      padding: const EdgeInsets.all(16.0), // Add padding if needed
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the content in the Row
        children: [
          GestureDetector(
            onTap: () {
              print(presalecontroller.pumpnum);

              Get.offNamed('/Nozzles',
                  arguments: {'pumpName': presalecontroller.pumpName});
            },
            child: _buildCircleIcon(Icons.arrow_back_rounded, Colors.white),
          ),
          const Spacer(), // Spacer to push the logo to the center
          _buildCircleImage('media/new_logo.png'), // New logo in the center
          const Spacer(), // Spacer to push the fuel icon to the right
          GestureDetector(
              onTap: () async {
                // Increment salepint on start image click

                // Save updated salepint to SharedPreferences
                await _saveSalepint(homeController.salepint.value);

                // Check if presalecontroller.value is not 0 or empty
                if (int.parse(presalecontroller.value) >= 10 &&
                    presalecontroller.value != '' &&
                    presalecontroller.dropdownvalue == "Price") {
                  homeController.salepint
                      .value++; // Update the observable from HomeController

                  await presalecontroller.GetNextTrxSeqNo();
                  // Only navigate if the value is valid

                  customController.xmlData.listen((data) async {
                    var document = XmlDocument.parse(data);
                    var serviceResponse =
                        document.getElement('ServiceResponse');
                    if (serviceResponse != null) {
                      var RequestType =
                          serviceResponse.getAttribute('RequestType');
                      var OverallResult =
                          serviceResponse.getAttribute('OverallResult');
                      if (RequestType == 'GetNextTransactionSequenceNo' &&
                          OverallResult == 'Success') {
                        var tempTransactionSeqNo = document
                                .findAllElements('FuelSale')
                                .first
                                .getAttribute('NextTransactionSeqNo') ??
                            '';
                        print('abdullah Here${tempTransactionSeqNo}');
                        customController.transactionSeqNo.value =
                            tempTransactionSeqNo;
                        print(
                            'Michael Here${customController.transactionSeqNo.value}');

                        // andriodid = customController.androidId_id
                        //     .split('.')
                        //     .join()
                        //     .substring(0, 5);
                        // presalecontroller.presetvalueController.text = '';
                        Get.toNamed('/Fueling', arguments: {
                          'trxSeqNum': customController.transactionSeqNo.value,
                        }); // Get.snackbar(
                        //   'Get Seq Number',
                        //   '${tempTransactionSeqNo}',
                        //   snackPosition: SnackPosition.TOP,
                        //   backgroundColor: Colors.green,
                        //   colorText: Colors.white,
                        // );
                      }
                    }
                  });
                  await presalecontroller.Auturizednozzle();
                  print("pumpfooter${customController.pumpNo.value}");
                  // andriodid = customController.androidId_id
                  //     .split('.')
                  //     .join()
                  //     .substring(0, 5);
                  // presalecontroller.presetvalueController.text = '';
                  // Get.toNamed('/Fueling', arguments: {
                  //   'trxSeqNum': customController.transactionSeqNo.value,
                  // });
                  // Get.toNamed('/authorizedpage',
                  //     arguments: {'presetValue': presalecontroller.value});
                  // customController.xmlData.listen((data) async {
                  //   print('xmlData updated in ChoosePaymentController: $data');
                  //   customController.parseXmlData(data);
                  //   // customController.currentXmlData.value = data;
                  //   // print("currentXmlData${customController.currentXmlData.value}");
                  //   // print("abdulla${customController.amountVal.value}");
                  //   // print("a----------------->${customController.MessageType.value}");
                  //   // Navigate to the Fueling page

                  //   // if (andriodid == customController.ApplicationSender.value &&
                  //   //     customController.WorkstationID.value == 'PMS') {
                  //   //   if (customController.MessageType.value ==
                  //   //       "FPStateChange") {}
                  //   // } else {
                  //   //   // Get.snackbar(
                  //   //   //   "Alert",
                  //   //   //   "Nozzle is Already Authorized",
                  //   //   //   backgroundColor: Colors.red,
                  //   //   //   colorText: Colors.white,
                  //   //   // );
                  //   //   Get.offNamed('/Nozzles',
                  //   //       arguments: {'pumpName': presalecontroller.pumpName});
                  //   // }
                  //   // Check the value of MessageType and navigate accordingly
                  // });

                  // Get.toNamed('/authorizedpage',
                  //     arguments: {'presetValue': presalecontroller.value});
                  // Get.toNamed('/Fueling',
                  //     arguments: {'presetValue': presalecontroller.value});
                } else if (int.parse(presalecontroller.value) > 0 &&
                    presalecontroller.dropdownvalue == "Liter" &&
                    presalecontroller.value != '') {
                  homeController.salepint
                      .value++; // Update the observable from HomeController

                  await presalecontroller.GetNextTrxSeqNo();
                  // Only navigate if the value is valid

                  customController.xmlData.listen((data) async {
                    var document = XmlDocument.parse(data);
                    var serviceResponse =
                        document.getElement('ServiceResponse');
                    if (serviceResponse != null) {
                      var RequestType =
                          serviceResponse.getAttribute('RequestType');
                      var OverallResult =
                          serviceResponse.getAttribute('OverallResult');
                      if (RequestType == 'GetNextTransactionSequenceNo' &&
                          OverallResult == 'Success') {
                        var tempTransactionSeqNo = document
                                .findAllElements('FuelSale')
                                .first
                                .getAttribute('NextTransactionSeqNo') ??
                            '';
                        print('abdullah Here${tempTransactionSeqNo}');
                        customController.transactionSeqNo.value =
                            tempTransactionSeqNo;
                        print(
                            'Michael Here${customController.transactionSeqNo.value}');

                        // andriodid = customController.androidId_id
                        //     .split('.')
                        //     .join()
                        //     .substring(0, 5);
                        // presalecontroller.presetvalueController.text = '';
                        Get.toNamed('/Fueling', arguments: {
                          'trxSeqNum': customController.transactionSeqNo.value,
                        }); // Get.snackbar(
                        //   'Get Seq Number',
                        //   '${tempTransactionSeqNo}',
                        //   snackPosition: SnackPosition.TOP,
                        //   backgroundColor: Colors.green,
                        //   colorText: Colors.white,
                        // );
                      }
                    }
                  });
                  await presalecontroller.Auturizednozzle();
                  print("pumpfooter${customController.pumpNo.value}");
                  // andriodid = customController.androidId_id
                  //     .split('.')
                  //     .join()
                  //     .substring(0, 5);
                  // presalecontroller.presetvalueController.text = '';
                  // Get.toNamed('/Fueling', arguments: {
                  //   'trxSeqNum': customController.transactionSeqNo.value,
                  // });
                  // Get.toNamed('/authorizedpage',
                  //     arguments: {'presetValue': presalecontroller.value});
                  // customController.xmlData.listen((data) async {
                  //   print('xmlData updated in ChoosePaymentController: $data');
                  //   customController.parseXmlData(data);
                  //   // customController.currentXmlData.value = data;
                  //   // print("currentXmlData${customController.currentXmlData.value}");
                  //   // print("abdulla${customController.amountVal.value}");
                  //   // print("a----------------->${customController.MessageType.value}");
                  //   // Navigate to the Fueling page

                  //   // if (andriodid == customController.ApplicationSender.value &&
                  //   //     customController.WorkstationID.value == 'PMS') {
                  //   //   if (customController.MessageType.value ==
                  //   //       "FPStateChange") {}
                  //   // } else {
                  //   //   // Get.snackbar(
                  //   //   //   "Alert",
                  //   //   //   "Nozzle is Already Authorized",
                  //   //   //   backgroundColor: Colors.red,
                  //   //   //   colorText: Colors.white,
                  //   //   // );
                  //   //   Get.offNamed('/Nozzles',
                  //   //       arguments: {'pumpName': presalecontroller.pumpName});
                  //   // }
                  //   // Check the value of MessageType and navigate accordingly
                  // });

                  // Get.toNamed('/authorizedpage',
                  //     arguments: {'presetValue': presalecontroller.value});
                  // Get.toNamed('/Fueling',
                  //     arguments: {'presetValue': presalecontroller.value});
                } else {
                  Get.snackbar(
                    "Error".tr,
                    "Pre-sale_value_cannot_be_0_or_empty_or_small_than_10".tr,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: _buildCircleIcon(
                  Icons.payments_rounded, Colors.white) // Fuel on the right
              ),
        ],
      ),
    );
  }

  Widget _buildCircleImage(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Color(0xFF2B2B2B), // Background color for the circular area
        shape: BoxShape.circle,
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Future<void> _saveSalepint(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('salepint', value); // Save salepint value
  }

  Widget _buildCircleIcon(IconData iconData, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(
          10.0), // Add 10 pixels of padding for the circular container
      decoration: const BoxDecoration(
        color: Color(0xFF2B2B2B), // Background color for the circular area
        shape: BoxShape.circle, // Makes the container circular
      ),
      child: Container(
        width: 60, // Set width
        height: 60, // Set height
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Keeps the image circular
        ),
        child: Icon(
          iconData, // The icon to display
          color: iconColor, // Color of the icon
          size: 50.0, // Adjust size as needed
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Home/home_controller.dart';
// import '../allpump/allpump_controller.dart';
// import '../pre sale val/pre_sale_value_controller.dart';

// class FooterPresetval extends StatelessWidget {
//   final presalecontroller = Get.find<PreSaleValueController>();
//   final homeController = Get.find<HomeController>();

//   @override
//   Widget build(BuildContext context) {
//     // Lazy load the controller if it hasn't been instantiated
//     Get.lazyPut<AllPumpController>(() => AllPumpController());

//     return Container(
//       color: const Color.fromARGB(255, 24, 24, 24),
//       width: double.infinity,
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment:
//             MainAxisAlignment.center, // Center the content in the Row
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.pushNamed(context, '/AllPump');
//             },
//             child: _buildCircleImage('media/leftarrow.png'),
//           ),
//           const Spacer(),
//           _buildCircleImage('media/new_logo.png'),
//           const Spacer(),
//           GestureDetector(
//             onTap: () async {
//               await _saveSalepint(homeController.salepint.value);

//               if (presalecontroller.value != 0 &&
//                   presalecontroller.value.isNotEmpty) {
//                 homeController.salepint.value++;
//                 await presalecontroller.Auturizednozzle();
//                 Navigator.pushNamed(context, '/ChoosePayment',
//                     arguments: presalecontroller.value);
//                 presalecontroller.presetvalueController.clear();
//               } else {
//                 _showFullPageDialog(context);
//               }
//             },
//             child: _buildCircleImage('media/start.png'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showFullPageDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             color: const Color(0xFF2B2B2B),
//             padding: const EdgeInsets.all(10),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   buildPumpRow(context, '1', 'media/petro.png'),
//                   const SizedBox(height: 20),
//                   buildPumpRow(context, '2', 'media/petro.png'),
//                   const SizedBox(height: 20),
//                   buildPumpRow(context, '3', 'media/petro.png'),
//                   const SizedBox(height: 20),
//                   buildPumpRow(context, '4', 'media/petro.png'),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildPumpRow(BuildContext context, String pumpName, String imagePath) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         buildPumpCard(context, pumpName, imagePath),
//       ],
//     );
//   }

//   Widget buildPumpCard(
//       BuildContext context, String pumpName, String imagePath) {
//     final allpumpcont = Get.find<AllPumpController>();
//     return GestureDetector(
//       onTap: () async {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('pumpName', pumpName);
//         allpumpcont.showPumpDialog(context, pumpName);
//       },
//       child: SizedBox(
//         width: 300,
//         child: Card(
//           color: const Color.fromARGB(255, 24, 24, 24),
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         imagePath,
//                         width: 50,
//                         height: 50,
//                       ),
//                       const SizedBox(width: 30),
//                       Container(
//                         width: 40,
//                         height: 40,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xED166E36),
//                         ),
//                         child: Center(
//                           child: Text(
//                             pumpName,
//                             style: const TextStyle(
//                               fontSize: 25,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const Row(
//                     children: [
//                       Text("Nozzle: ",
//                           style: TextStyle(color: Colors.white, fontSize: 20)),
//                       SizedBox(width: 20),
//                       Text("2",
//                           style: TextStyle(color: Colors.white, fontSize: 20)),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const Row(
//                     children: [
//                       Text("Gasoline: ",
//                           style: TextStyle(color: Colors.white, fontSize: 20)),
//                       Text("95",
//                           style: TextStyle(color: Colors.white, fontSize: 20)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCircleImage(String assetPath) {
//     return Container(
//       padding: const EdgeInsets.all(10.0),
//       decoration: const BoxDecoration(
//         color: Color(0xFF2B2B2B),
//         shape: BoxShape.circle,
//       ),
//       child: Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(
//             image: AssetImage(assetPath),
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _saveSalepint(int value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('salepint', value);
//   }
// }
