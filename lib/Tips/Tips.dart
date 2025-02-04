// ignore_for_file: file_names, avoid_print, use_key_in_widget_constructors, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use, avoid_unnecessary_containers, use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/Shared/drawer.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Footer/Footer_Tips.dart';
import 'Tips_Controller.dart';

class Tips extends StatelessWidget {
  // Assuming these values are passed from the previous screen
  final tipsController = Get.find<TipsController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xED1C1C1C),
        appBar: const CustomAppBar(),
        drawer: CustomDrawer(),
        resizeToAvoidBottomInset:
            true, // Allows the layout to adjust when the keyboard is open

        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.51,
            decoration: BoxDecoration(
                color: const Color(0xFF2B2B2B),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16.0, bottom: 5, top: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Center the logo
                  Image.asset(
                    'media/new_logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 10), // Space between logo and text
                  // Center the text
                  Text(
                    ("Give_Tips").tr + " ",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const SizedBox(
                      height: 10), // Space between text and input field
                  // Input field with button

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tipsController.TipInput,
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
                          enabled: !tipsController.isInputTips.value,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            tipsController.updateValue();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Space between TextField and button
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Or_Enter_All_Amount".tr,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tipsController.AllAmountInput,
                          decoration: InputDecoration(
                            hintText: 'Enter_Total'.tr,
                            hintStyle: const TextStyle(
                                color: Colors.white54, fontSize: 15),
                            filled: true,
                            fillColor: const Color(0xFF176E38),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          enabled: !tipsController.isInputAmount.value,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            tipsController.updateAllamounvalue();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Space between TextField and button
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: FooterViewTips(),
      ),
    );
  }
}
