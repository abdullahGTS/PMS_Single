// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/CustomAppbar/CustomAppbar_Controller.dart';

import '../Tips/Tips_Controller.dart';

class FooterViewTips extends StatelessWidget {
  final tipscontroller = Get.find<TipsController>();
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 24, 24, 24),
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Get.snackbar(
                'Fueling Amount',
                "${customController.amountVal.value.toStringAsFixed(2)} EGP",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: _buildCircleIcon(Icons.payments_rounded, Colors.white),
          ), // Cloud on the left
          const Spacer(), // Spacer to push the logo to the center
          _buildCircleImage('media/new_logo.png'), // New logo in the center
          const Spacer(), // Spacer to push the "OK" text button to the right
          GestureDetector(
            onTap: () async {
              String tipInput = tipscontroller.TipInput.text;
              String AllAmountInput = tipscontroller.AllAmountInput.text;
              if (!tipInput.isEmpty) {
                if (tipInput.isEmpty) {
                  customController.TipsValue.value = "0";
                  tipscontroller.TipInput.text = "0";
                  Get.toNamed("/ChoosePayment");
                } else {
                  int tipsValue = int.tryParse(tipInput) ?? 0;

                  if (tipsValue == null) {
                    Get.snackbar(
                      "Error",
                      "Invalid input! Please enter a valid number.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else if (tipsValue < 0) {
                    Get.snackbar(
                      "Error",
                      "Please ensure the Tips amount is greater than 0!",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    customController.TipsValue.value = tipsValue.toString();
                    // tipscontroller.TipInput.text = "0";
                    Get.toNamed("/ChoosePayment");
                  }
                }
              } else {
                if (AllAmountInput.isEmpty) {
                  customController.TipsValue.value = "0";
                  tipscontroller.AllAmountInput.text = "0";
                  Get.toNamed("/ChoosePayment");
                } else {
                  int AllAmountvalue = int.tryParse(AllAmountInput) ?? 0;

                  if (AllAmountvalue == null) {
                    Get.snackbar(
                      "Error",
                      "Invalid input! Please enter a valid number.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else if (AllAmountvalue < 0) {
                    Get.snackbar(
                      "Error",
                      "Please ensure the Tips amount is greater than 0!",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } else {
                    customController.TipsValue.value =
                        (double.parse(customController.AllAmountValue.value) -
                                customController.amountVal.value)
                            .toStringAsFixed(2);
                    // tipscontroller.TipInput.text = "0";
                    Get.toNamed("/ChoosePayment");
                  }
                }
              }

              // String AllAmountInput = tipscontroller.AllAmountInput.text;

              // customController.saveTransaction();

              // customController.amountVal.value = 0.0;
            },
            child: Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color:
                    Color(0xFF2B2B2B), // Background color for the circular area
                shape: BoxShape.circle, // Makes the container circular
              ),
              child: Center(
                child: Text(
                  "Pay".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCircleImage(String assetPath) {
    return Container(
      padding:
          const EdgeInsets.all(10.0), // Add padding for the circular container
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
