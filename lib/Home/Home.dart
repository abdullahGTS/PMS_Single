import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pms/Home/Home_Controller.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Footer/Footer.dart';
import '../Shared/clock.dart';
import '../Shared/drawer.dart';

class HomePage extends StatelessWidget {
  final homecontrol = Get.find<HomeController>();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive padding for different screen sizes
    final horizontalPadding = screenWidth * 0.05; // 5% of the screen width
    final verticalPadding = screenHeight * 0.02; // 2% of the screen height
    return WillPopScope(
      onWillPop: () async {
        // Show the password dialog and return true only if the password is correct
        return await homecontrol.showExitPasswordDialog(context);
      },
      child: Scaffold(
        appBar: const CustomAppBar(),
        backgroundColor: const Color(0xFF2B2B2B),
        drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: verticalPadding),
                  ClockContainer(),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // First Card - Total Transactions
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 24, 24, 24),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Use Expanded to prevent overflow in this Row
                                    Expanded(
                                      child: Text(
                                        ("Transaction").tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Use Expanded to prevent overflow in this Row

                                    Obx(
                                      () => Text(
                                        homecontrol.transnum.value.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      (" ") + (" TRX").tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 24, 24, 24),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Use Expanded to prevent overflow in this Row
                                    Expanded(
                                      child: Text(
                                        ("Amount").tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Use Expanded to prevent overflow in this Row

                                    Obx(() => Text(
                                          homecontrol.totalamount.value
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        )),
                                    Text(
                                      (" ") + (" EGP").tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Second Card - Total Recharges
                        // Expanded(
                        //   child: Container(
                        //     padding: EdgeInsets.all(screenWidth * 0.03),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xED166E36),
                        //       borderRadius: BorderRadius.circular(7),
                        //     ),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Row(
                        //           children: [
                        //             // Use Expanded to prevent overflow in this Row
                        //             Expanded(
                        //               child: Text(
                        //                 "Total     Recharges",
                        //                 style: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 19,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: screenHeight * 0.015),
                        //         Text(
                        //           "000",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: screenWidth * 0.08,
                        //           ),
                        //         ),
                        //         SizedBox(height: screenHeight * 0.015),
                        //         Text(
                        //           "AMT. 000 EGP",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: screenWidth * 0.045,
                        //           ),
                        //         ),
                        //         SizedBox(height: screenHeight * 0.015),
                        //         const Text(
                        //           "Total Transaction",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 15,
                        //           ),
                        //         ),
                        //
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 24, 24, 24),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Use Expanded to prevent overflow in this Row
                                    Expanded(
                                      child: Text(
                                        ("Tips").tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Use Expanded to prevent overflow in this Row

                                    Obx(
                                      () => Text(
                                        homecontrol.totaltips.value.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      (" ") + (" EGP").tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            decoration: BoxDecoration(
                              color: const Color(0xED166E36),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Use Expanded to prevent overflow in this Row
                                    Expanded(
                                      child: Text(
                                        ("Total").tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Use Expanded to prevent overflow in this Row

                                    Obx(
                                      () => Text(
                                        homecontrol.totalmoney.value.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      (" ") + (" EGP").tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () async {
                        //     homecontrol.reprint();
                        //   },
                        //   child: Container(
                        //     width: 60, // Adjust the width
                        //     height: 60, // Adjust the height
                        //     decoration: const BoxDecoration(
                        //       shape: BoxShape
                        //           .circle, // Makes the container circular
                        //       image: DecorationImage(
                        //         image: AssetImage(
                        //             'media/new_logo.png'), // Path to the logo
                        //         fit: BoxFit
                        //             .contain, // Ensures the entire image fits within the circle
                        //       ),
                        //     ),
                        //   ),
                        // )
                        // First Card - Total Transactions

                        // Second Card - Total Recharges
                        // Expanded(
                        //   child: Container(
                        //     padding: EdgeInsets.all(screenWidth * 0.03),
                        //     decoration: BoxDecoration(
                        //       color: const Color(0xED166E36),
                        //       borderRadius: BorderRadius.circular(7),
                        //     ),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Row(
                        //           children: [
                        //             // Use Expanded to prevent overflow in this Row
                        //             Expanded(
                        //               child: Text(
                        //                 "Total     Recharges",
                        //                 style: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 19,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(height: screenHeight * 0.015),
                        //         Text(
                        //           "000",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: screenWidth * 0.08,
                        //           ),
                        //         ),
                        //         SizedBox(height: screenHeight * 0.015),
                        //         Text(
                        //           "AMT. 000 EGP",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: screenWidth * 0.045,
                        //           ),
                        //         ),
                        //         SizedBox(height: screenHeight * 0.015),
                        //         const Text(
                        //           "Total Transaction",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 15,
                        //           ),
                        //         ),
                        //
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: FooterView(),
      ),

      // Add your other widgets here...
    );
  }
}
