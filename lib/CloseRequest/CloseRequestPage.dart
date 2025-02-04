// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import 'CloseRequest_Controller.dart';

class CloseRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the LoadingController here
    final closeRequestController = Get.find<CloseRequestController>();
    final customcontroller = Get.find<CustomAppbarController>();

    return Scaffold(
      appBar: null,
      backgroundColor: const Color(0xED1C1C1C),
      // Optional: Customize your background color
      body: Center(
        child: Obx(() {
          if (closeRequestController.isLoading.value) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'media/internet-security.png',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(width: 20), // Add space between the images
                      // Drop Image with animation
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Loading spinner
                  const SizedBox(height: 20),
                  Obx(() {
                    return Text(
                      closeRequestController.closeStatus.value,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    );
                  }),
                  Obx(() {
                    return Text(
                      '${closeRequestController.posNum.value}' + ' Remains',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    );
                  }),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () async {
                      closeRequestController.checkthelastpos();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: const Color(0xED166E36)),
                        child: Center(
                          child: Text(
                            "Check_Remains".tr,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // If loading is complete, return an empty container or something else
            return Container();
          }
        }),
      ),
    );
  }
}
