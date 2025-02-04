import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Footer/Footer_AvailableTrxDetails.dart';
import 'AvailableTrxDetails_Controller.dart';

class Availabletrxdetails extends StatelessWidget {
  Availabletrxdetails({super.key});
  final availabletrxdetailsController =
      Get.find<AvailabletrxdetailsController>();

  @override
  Widget build(BuildContext context) {
    // Initialize the PaymentController

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        // appBar: const CustomAppBar(),
        body: Obx(() {
          // Stop loading and show actual content when condition is met
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                  top: 20.0), // No padding around the content
              child: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Start from the top
                  children: [
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        "Transaction_Details".tr,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    const SizedBox(
                        height: 15), // Space between AppBar and content
                    // Total Amount Card
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.96, // Full width

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
                              Row(
                                children: [
                                  Expanded(
                                    // flex: 1,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Icon(
                                                Icons.calendar_month_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            )),
                                        Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Start_Date".tr,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    // flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${availabletrxdetailsController.customController.startTimeStamp.value}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.local_gas_station,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              "Pump".tr +
                                                  " ${availabletrxdetailsController.customController.pumpNo.value}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.local_gas_station,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              "Nozzle".tr +
                                                  " ${availabletrxdetailsController.customController.nozzleNo.value}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.water_drop_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              "${availabletrxdetailsController.customController.productName.value}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.numbers_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              "TRX".tr +
                                                  " ${availabletrxdetailsController.customController.transactionSeqNo.value}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.payments_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              "T/A".tr +
                                                  " ${availabletrxdetailsController.customController.amountVal.value} EGP",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.water_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              "T/V".tr +
                                                  " ${availabletrxdetailsController.customController.volume.value} LTR",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.payments_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              "U/P".tr +
                                                  " ${availabletrxdetailsController.customController.unitPrice.value} EGP",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.phone_android_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            flex: 4,
                                            child: Text(
                                              "POS".tr +
                                                  " ${availabletrxdetailsController.customController.AuthorisationApplicationSender.value == '' ? 'Unknown' : availabletrxdetailsController.customController.AuthorisationApplicationSender.value}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    // flex: 1,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Icon(
                                                Icons.calendar_month_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            )),
                                        Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "End_Date".tr,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    // flex: 2,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          "${availabletrxdetailsController.customController.endTimeStamp.value}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Space between the card and the options
                    Center(
                      child: Text(
                        "Choose_Payment".tr,
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: availabletrxdetailsController
                                  .TrxDetalisTipInput,
                              decoration: InputDecoration(
                                hintText: 'Enter_Tips_Only'.tr,
                                hintStyle: const TextStyle(
                                    color: Colors.white54, fontSize: 15),
                                filled: true,
                                fillColor: const Color(0xFF176E38),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                availabletrxdetailsController.updateValue();
                              },
                            ),
                          ),

                          // Space between TextField and button
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPaymentOption(
                            context,
                            availabletrxdetailsController,
                            "Cash".tr,
                            Icons.payments_outlined),
                        _buildPaymentOption(
                            context,
                            availabletrxdetailsController,
                            "Bank".tr,
                            Icons.credit_card),
                      ],
                    ),
                    const SizedBox(height: 16), // Space between rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPaymentOption(
                            context,
                            availabletrxdetailsController,
                            "Fleet".tr,
                            Icons.credit_card),
                        _buildPaymentOption(
                            context,
                            availabletrxdetailsController,
                            "Bank_Point".tr,
                            Icons.credit_card),
                      ],
                    ),
                    const SizedBox(height: 16), // Space between rows
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     _buildPaymentOption(
                    //         context,
                    //         availabletrxdetailsController,
                    //         "Cash",
                    //         Icons.payments_outlined),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          );
        }),
        bottomNavigationBar: FooterAvailabletrxdetails(),
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context,
      AvailabletrxdetailsController paymentController,
      String title,
      IconData icon) {
    return Obx(() {
      // Determine the background color based on selection
      Color backgroundColor =
          (availabletrxdetailsController.selectedPaymentOption.value == title)
              ? const Color(0xFF166E36) // Change to green when selected
              : const Color.fromARGB(255, 24, 24, 24);

      return GestureDetector(
        onTap: () {
          // Update the selected payment option when tapped
          availabletrxdetailsController.selectPaymentOption(context, title);
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
            children: [
              Expanded(
                flex: 2,
                child: Icon(
                  icon,
                  color: Colors.white, // Set icon color
                  size: 30, // Adjust icon size as needed
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
            ],
          ),
        ),
      );
    });
  }
}
