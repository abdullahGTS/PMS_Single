// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Authorized_Controller.dart';

class Authorizedpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the LoadingController here
    final loadingController = Get.find<AuthorizedController>();

    return Scaffold(
      appBar: null,
      backgroundColor: const Color(0xED1C1C1C),
      // Optional: Customize your background color
      body: Center(
        child: Obx(() {
          if (loadingController.isLoading.value) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'media/nozzleload.png',
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
                  const Text(
                    'Authorized ...',
                    style: TextStyle(fontSize: 30, color: Colors.white),
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
