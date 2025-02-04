// ignore_for_file: avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Shared/drawer.dart';
import 'package:intl/intl.dart';

import 'VerifySetlemment_Controller.dart';
import 'VerifySetlemment_Input.dart';

class VerifySetlemmentPage extends StatelessWidget {
  VerifySetlemmentPage({super.key});
  final customController = Get.find<CustomAppbarController>();
  final verifySetlemmentController = Get.put(VerifySetlemmentController());

  // final verifyController = Get.find<VerifyController>();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final containerHeight = screenHeight - appBarHeight; // Adjusted height

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2B2B2B),
        appBar: const CustomAppBar(),
        drawer: CustomDrawer(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 14),
              width: MediaQuery.of(context).size.width * 0.93,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Allow flexible height
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20), // Space between AppBar and body

                  // Combined Icon and OTP Input Container
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color.fromARGB(255, 24, 24, 24),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.admin_panel_settings_rounded,
                              color: Colors.white,
                              size: 100,
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(
                            height: 20.0), // Space between title and OTP input

                        // OtpInput widget
                        VerifySetlemmentInput(
                          controllers: _otpControllers,
                          focusNodes: _focusNodes,
                          onSubmit: (otp) {
                            if (otp.isNotEmpty) {
                              print("Submitted OTP: $otp");
                              Get.toNamed('/Home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter your OTP')),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 10.0), // Space between OTP input and keypad

                  // Updated layout for Numeric Keypad
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: const Color.fromARGB(255, 24, 24, 24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNumberButton("1"),
                            _buildNumberButton("2"),
                            _buildNumberButton("3"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNumberButton("4"),
                            _buildNumberButton("5"),
                            _buildNumberButton("6"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNumberButton("7"),
                            _buildNumberButton("8"),
                            _buildNumberButton("9"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildBackButton(), // Custom back button
                            _buildNumberButton("0"),
                            _buildConfirmButton(), // Custom confirm button
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to build number buttons
  Widget _buildNumberButton(String number) {
    return GestureDetector(
      onTap: () {
        _addNumberToOtp(number);
      },
      child: Container(
        width: 50, // Adjust width
        height: 50, // Adjust height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: const TextStyle(fontSize: 24), // Adjust font size
        ),
      ),
    );
  }

  // Method to add number to OTP input
  void _addNumberToOtp(String number) {
    for (int i = 0; i < _otpControllers.length; i++) {
      if (_otpControllers[i].text.isEmpty) {
        _otpControllers[i].text = number;
        _otpControllers[i].selection = TextSelection.fromPosition(
          TextPosition(offset: number.length),
        );
        if (i < _otpControllers.length - 1) {
          FocusScope.of(Get.context!)
              .requestFocus(_focusNodes[i + 1]); // Move to the next field
        }
        break;
      }
    }
  }

  // Method for back button
  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        _removeLastDigit();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.arrow_back, size: 24),
      ),
    );
  }

  // Method to remove the last digit from OTP input
  void _removeLastDigit() {
    for (int i = _otpControllers.length - 1; i >= 0; i--) {
      if (_otpControllers[i].text.isNotEmpty) {
        _otpControllers[i].clear();
        if (i > 0) {
          FocusScope.of(Get.context!).requestFocus(
              _focusNodes[i - 1]); // Move back to the previous field
        }
        break;
      }
    }
  }

  // Method for confirm button
  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: () async {
        final otp = _otpControllers.map((controller) => controller.text).join();
        if (otp.length < 4) {
          Get.snackbar(
            'Error'.tr,
            'Please_enter_your_full_OTP'.tr,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        } else {
          final isOtpValid;
          print("otp${otp}");
          print(
              "customController.pinopenshift.value---------${customController.pinopenshift.value}");

          if (int.parse(otp) == customController.pinopenshift.value) {
            isOtpValid = true;
          } else {
            isOtpValid = false;
          }
          print("isOtpValid--------??${isOtpValid}");

          if (isOtpValid) {
            await customController.fetchToken();
            const _channel = MethodChannel('com.example.pms/method');

            final String response =
                await _channel.invokeMethod<String>('settlementTrans') ??
                    'No response';
            print("settlementTrans${response}");

            if (customController.isconnect.value) {
              print(
                  "customController.isconnect.value????${customController.isconnect.value}");

              const _channel = MethodChannel('com.example.pms/method');

              await _channel.invokeMethod<String>('settlementTrans');
              _channel.setMethodCallHandler((call) async {
                if (call.method == "onTransactionResult") {
                  final Map<String, dynamic> response =
                      Map<String, dynamic>.from(call.arguments);

                  // Handle transaction result
                  if (response.containsKey("error")) {
                    print("Transaction Error: ${response['error']}");
                  } else {
                    print("Transaction Successful: $response");
                    Get.toNamed('/Home');
                  }
                }
              });
            } else {
              print("abdulla--------");

              Get.snackbar(
                "Error".tr,
                "You_should_be_online_to_Setlemment_Transaction".tr,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          } else {
            Get.snackbar(
              'Error'.tr,
              'Invalid_OTP'.tr + ', ' + 'please_try_again'.tr,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          "OK".tr,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
