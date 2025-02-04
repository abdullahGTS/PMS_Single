// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FooterPumpsView extends StatelessWidget {
  var pumps = "";
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
              // Navigate to the verification page
              // Navigator.pushNamed(context, '/verify');
              Get.toNamed("/verify");
            },
            child: _buildCircleIcon(
                Icons.arrow_back_rounded, Colors.white), // Fuel on the right
          ),
          const Spacer(), // Spacer to push the logo to the center
          _buildCircleImage('media/new_logo.png'), // New logo in the center
          const Spacer(), // Spacer to push the fuel icon to the right
          GestureDetector(
            onTap: () async {
              Get.snackbar(
                ('Pumps_Alert').tr,
                ("click_on_pump_to_know_its_status").tr,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: _buildCircleIcon(
                Icons.payments_rounded, Colors.white), // Fuel on the right
          ),
        ],
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
