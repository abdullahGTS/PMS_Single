import 'package:flutter/material.dart';

class ShiftInput extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(String) onSubmit;

  const ShiftInput({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Row(
          children: [
            SizedBox(
              width: 50, // Width of each OTP input box
              height: 50, // Height to make it circular
              child: TextField(
                controller: controllers[index],
                focusNode: focusNodes[index],
                textAlign: TextAlign.center,
                readOnly: true, // Disable keyboard input
                maxLength: 1,
                style: const TextStyle(fontSize: 30), // Set font size to 30

                decoration: InputDecoration(
                  counterText: '', // Hide the counter text
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Make it circular
                    borderSide:
                        const BorderSide(color: Colors.grey), // Border color
                  ),
                  filled: true, // Fill the background
                  fillColor: Colors.grey[200], // Background color
                  contentPadding: EdgeInsets.zero, // Remove inner padding
                ),
                onChanged: (value) {
                  // Move to the next input if a digit is entered
                  if (value.isNotEmpty) {
                    if (index < 3) {
                      FocusScope.of(context)
                          .requestFocus(focusNodes[index + 1]);
                    } else {
                      // Last input, call onSubmit
                      _submitOtp();
                    }
                  } else if (index > 0 && value.isEmpty) {
                    // Move back to the previous input if the current is emptied
                    FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                  }
                },
              ),
            ),

            // Add space between input boxes, except after the last one
            if (index < 3)
              const SizedBox(width: 16), // Adjust width for spacing as needed
          ],
        );
      }),
    );
  }

  void _submitOtp() {
    // Gather the entered OTP
    print("object${controllers}");
    String otp = controllers.map((controller) => controller.text).join();
    onSubmit(otp); // Call the onSubmit callback with the OTP
  }
}
