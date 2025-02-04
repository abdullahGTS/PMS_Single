// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CloseRequest/CloseRequest_Controller.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';

class FooterView extends StatelessWidget {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final closeController = Get.put(CloseRequestController());

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
            onTap: () async {
              // print(
              //     "(customController.isconnect.value${customController.isconnect.value}");
              // Get.offAllNamed('/Home');
              // print(
              //     "(customController.isconnect.value${customController.isconnect.value}");

              customController.fetchToken();
              if (customController.isconnect.value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ('Collecting Config...').tr,
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
                await closeController.checkthelastpos();
              } else {
                await customController.readConfigFromFile();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      ('Reading Local Config...').tr,
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
              // Navigate to the verification page'
            },
            child: _buildCircleIcon(Icons.cloud_download_rounded,
                Colors.white), // Cloud on the left
            // Fuel on the right
          ),
          const Spacer(), // Spacer to push the logo to the center
          _buildCircleImage('media/new_logo.png'), // New logo in the center
          const Spacer(), // Spacer to push the fuel icon to the right
          GestureDetector(
            onTap: () {
              // Navigate to the verification page'
              customController.issupervisormaiar.value = false;
              Get.toNamed("/verify");
            },
            child: _buildCircleIcon(Icons.local_gas_station_rounded,
                Colors.white), // Fuel on the right
          ),
        ],
      ),
    );
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

  Widget _buildCircleImage(String assetPath) {
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
          image: DecorationImage(
            image: AssetImage(assetPath), // Path to the image
            fit: BoxFit
                .contain, // Ensures the entire image fits within the circle
          ),
        ),
      ),
    );
  }
}
