import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FooterAvailabletrxdetails extends StatelessWidget {
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
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //       content: Text(
              //           'you can not back while fueling is in progress !!')),
              // );
              Get.back();
            },
            child: _buildCircleIcon(Icons.arrow_back_rounded, Colors.white),
            // Fuel on the right
          ),
          const Spacer(), // Spacer to push the logo to the center
          _buildCircleImage('media/new_logo.png'), // New logo in the center
          const Spacer(), // Spacer to push the fuel icon to the right
          GestureDetector(
            onTap: () {
              // Navigate to the verification page
              Get.snackbar(
                'Payment_Alert'.tr,
                "sorry".tr + ", " + "you_have_to_choose_a_payment_method".tr,
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: _buildCircleIcon(Icons.mobile_friendly_rounded,
                Colors.white), // Fuel on the right
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
