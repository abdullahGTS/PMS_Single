import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Footer/Footer_Pumps.dart';
import '../Shared/drawer.dart';
import 'Pumps_Controller.dart';
import 'package:xml/xml.dart';

class PumpsPage extends StatelessWidget {
  PumpsPage({super.key});

  final allpumpcont = Get.find<PumpsController>();
  final customController = Get.find<CustomAppbarController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        appBar: CustomAppBar(),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Column(
                children: [
                  for (int i = 0;
                      i < customController.config['pumps'].length;
                      i += 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // First card in the row
                        buildPumpCard(
                          context,
                          customController.config['pumps'][i]['pump_number']
                              .toString(),
                          customController.config['pumps'][i]['nozzles_count']
                              .toString(),
                        ),
                        // Second card in the row (if available)
                        if (i + 1 < customController.config['pumps'].length)
                          buildPumpCard(
                            context,
                            customController.config['pumps'][i + 1]
                                    ['pump_number']
                                .toString(),
                            customController.config['pumps'][i + 1]
                                    ['nozzles_count']
                                .toString(),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: FooterPumpsView(),
      ),
    );
  }

  // Method to build each pump card
  Widget buildPumpCard(
      BuildContext context, String pumpName, String nozzlesCount) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pumpName', pumpName);

        await allpumpcont.checkFueling(pumpName);

        allpumpcont.xmlDataPumpListener =
            customController.xmlData.listen((data) {
          var document = XmlDocument.parse(data);

          var serviceResponse = document.getElement('ServiceResponse');
          if (serviceResponse != null) {
            var RequestType = serviceResponse.getAttribute('RequestType');
            var overallResult = serviceResponse.getAttribute('OverallResult');
            if (RequestType == 'GetFPState' && overallResult == "Success") {
              var pumpNo = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('DeviceID');
              var status = document.findAllElements('DeviceState').first.text;
              print('pumpNo-----------: $pumpNo');
              print('status-----------: $status');

              if (status == 'FDC_FUELLING' ||
                  status == 'FDC_AUTHORISED' ||
                  status == 'FDC_STARTED') {
                Get.snackbar(
                  ("Alert").tr,
                  ("Sorry_the_pump").tr + " ${pumpNo}" + ("is_in_progress").tr,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                customController.checkFueling.value = "";
              } else {
                customController.pumpNo.value = pumpNo!;
                Get.toNamed("/Nozzles", arguments: {'pumpName': pumpNo});
              }
            }
          }
        });
        // allpumpcont.xmlDataPumpListener =
        //     customController.xmlData.listen((data) {
        //   var document = XmlDocument.parse(data);
        //   var serviceResponse = document.getElement('ServiceResponse');
        //   if (serviceResponse != null) {
        //     var RequestType = serviceResponse.getAttribute('RequestType');
        //     if (RequestType == 'GetFPState') {
        //       print("listening ");
        //       var temp = customController.parseXmlFuelingData(data);
        //       print('temp------->${temp[1]}');
        //       // allpumpcont.pumpState.value = temp[0];
        //       // allpumpcont.pumpStateNumber.value = temp[1];
        //       if (temp[0]) {
        //         customController.pumpNo.value = pumpName;
        //         Get.toNamed("/Nozzles", arguments: {'pumpName': pumpName});
        //       } else {
        //         print("allpumpcont.pumpNumber.value${temp[1]}");
        //         Get.snackbar(
        //           "Alert",
        //           "Sorry, the pump ${temp[1]} is in progress",
        //           backgroundColor: Colors.red,
        //           colorText: Colors.white,
        //         );
        //         customController.checkFueling.value = "";
        //       }
        //     }
        //   }
        // });
      },
      child: SizedBox(
        width: 170, // Set a fixed width for each card
        child: Card(
          color: Color.fromARGB(255, 24, 24, 24),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ("PUMP").tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle, // Circle background
                            color: Color(0xED166E36), // Green circle color
                          ),
                          child: Center(
                            child: Text(
                              pumpName,
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Space between rows
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ("Nozzles").tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  nozzlesCount,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.local_gas_station_rounded,
                                color: Colors.white,
                                size: 25,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // const Row(
                //   children: [
                //     Text("Gasoline: ",
                //         style: TextStyle(color: Colors.white, fontSize: 20)),
                //     Text("95,92",
                //         style: TextStyle(color: Colors.white, fontSize: 20)),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
