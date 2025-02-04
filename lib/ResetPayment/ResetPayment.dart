import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Footer/Footer_ChoosePayment.dart';
import 'ResetPayment_Controller.dart';

class ResetPayment extends StatelessWidget {
  ResetPayment({super.key});
  final choosePaymentController = Get.find<ResetPaymentController>();

  @override
  Widget build(BuildContext context) {
    // Initialize the PaymentController

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        appBar: const CustomAppBar(),
        // drawer:CustomDrawer(),
        body: Obx(() {
          // Parse the textValue to double

          // Stop loading and show actual content when condition is met
          return SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.all(0.0), // No padding around the content
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Start from the top
                  children: [
                    const SizedBox(
                        height: 10), // Space between AppBar and content
                    // Total Amount Card
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.96, // Full width
                      height: 100,
                      child: Card(
                        color: const Color(0xFF166E36), // Card color
                        child: Padding(
                          padding: const EdgeInsets.all(
                              10.0), // Padding inside the card
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // Center vertically
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Center horizontally
                            children: [
                              Text(
                                "Total_Amount".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight
                                      .bold, // Adjust font size as needed
                                ),
                              ),
                              const SizedBox(height: 5), // Space between rows
                              Text(
                                "${choosePaymentController.customController.amountVal.value + int.parse(choosePaymentController.customController.TipsValue.value)}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight
                                      .bold, // Adjust font size as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 16), // Space between the card and the options
                    // First Row of Payment Options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPaymentOption(context, choosePaymentController,
                            "Cash".tr, Icons.payments_rounded),
                        _buildPaymentOption(context, choosePaymentController,
                            "Bank_Card".tr, Icons.credit_card),
                      ],
                    ),
                    const SizedBox(height: 16), // Space between rows
                    // Second Row of Payment Options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // _buildPaymentOption(context, choosePaymentController,
                        //     "QR Payment", Icons.credit_card),
                        _buildPaymentOption(context, choosePaymentController,
                            "Fleet".tr, Icons.credit_card),
                        _buildPaymentOption(context, choosePaymentController,
                            "Bank_Point".tr, Icons.credit_card),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          );
        }),
        bottomNavigationBar: FooterChoosePayment(),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context,
      ResetPaymentController paymentController, String title, IconData icon) {
    return Obx(() {
      // Determine the background color based on selection
      Color backgroundColor =
          (paymentController.selectedPaymentOption.value == title)
              ? const Color(0xFF166E36) // Change to green when selected
              : const Color.fromARGB(255, 24, 24, 24);

      return GestureDetector(
        onTap: () {
          // Update the selected payment option when tapped
          paymentController.selectPaymentOption(context, title);
        },
        child: Container(
          height: 100, // Increased height for better spacing
          width: MediaQuery.of(context).size.width *
              0.45, // Set width to 40% of screen width
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: backgroundColor, // Set dynamic background color
          ),
          child: Row(
            // mainAxisAlignment:
            //     MainAxisAlignment.spaceEvenly, // Center vertically
            children: [
              Expanded(
                flex: 2,
                child: Icon(
                  icon,
                  color: Colors.white, // Set icon color
                  size: 40, // Adjust icon size as needed
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white, // White text color
                  ),
                ),
              ),
              // Icon(
              //   icon,
              //   color: Colors.white, // Set icon color
              //   size: 40, // Adjust icon size as needed
              // ),
              // const SizedBox(height: 10), // Space between icon and text
              // Text(
              //   title,
              //   style: const TextStyle(
              //     fontSize: 25,
              //     color: Colors.white, // White text color
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }
}
