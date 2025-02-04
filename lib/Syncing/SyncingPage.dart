// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Syncing_Controller.dart';

class SyncingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the LoadingController here
    final syncingController = Get.find<SyncingController>();

    return Scaffold(
      appBar: null,
      backgroundColor: const Color(0xED1C1C1C),
      // Optional: Customize your background color
      body: Center(
        child: Obx(() {
          if (syncingController.isLoading.value) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'media/secure-data.png',
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
                      (syncingController.status.value).tr,
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    );
                  }),
                  const SizedBox(height: 20),
                  Obx(() {
                    return Text(
                      'S/N'.tr +
                          ': ${syncingController.androidId_idshowing.value}',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  }),
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
