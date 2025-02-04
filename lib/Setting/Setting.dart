import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Setting_Controller.dart';

class SettingPage extends StatelessWidget {
  final shiftController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B),
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black, // Customize the AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: shiftController.inputIpFuissionController,
                decoration: const InputDecoration(
                    hintText: 'Enter number of IP Fuission',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    filled: true,
                    fillColor: Colors.black,
                    border: InputBorder.none, // Remove border
                    labelText: 'IP Fuission',
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print("value${value}");
                  shiftController.updateValue1();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: shiftController.inputPortFuissionController,
                decoration: const InputDecoration(
                    hintText: 'Enter number of Port Fuission',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    filled: true,
                    fillColor: Colors.black,
                    border: InputBorder.none, // Remove border
                    labelText: 'Port Fuission',
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print("value${value}");
                  shiftController.updateValue2();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: shiftController.inputTimerPublicController,
                decoration: const InputDecoration(
                    hintText: 'Enter number Of Tellecollect Timer  ',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    filled: true,
                    fillColor: Colors.black,
                    border: InputBorder.none, // Remove border
                    labelText: 'Timer',
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print("value${value}");
                  shiftController.updateValue3();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: shiftController.inputIPPOrtalPublicController,
                decoration: const InputDecoration(
                    hintText: 'Enter Ip for PMS Portal',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    filled: true,
                    fillColor: Colors.black,
                    border: InputBorder.none, // Remove border
                    labelText: 'IP PMS',
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print("value${value}");
                  shiftController.updateValue4();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: shiftController.inputPoretPortalPublicController,
                decoration: const InputDecoration(
                    hintText: 'Enter Port for PMS Portal',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    filled: true,
                    fillColor: Colors.black,
                    border: InputBorder.none, // Remove border
                    labelText: 'Port PMS',
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print("value${value}");
                  shiftController.updateValue5();
                },
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: shiftController.inputEGInvoicePublicController,
                decoration: const InputDecoration(
                    hintText: 'EG-Invoice URL',
                    hintStyle: TextStyle(color: Colors.white54, fontSize: 15),
                    filled: true,
                    fillColor: Colors.black,
                    border: InputBorder.none, // Remove border
                    labelText: 'EG-Invoice URL',
                    labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print("value${value}");
                  shiftController.updateValue6();
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xED166E36), // Set the background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7), // Rounded corners
                  ),
                ),
                onPressed: shiftController.saveSettings,
                child: const Text(
                  'Save Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
