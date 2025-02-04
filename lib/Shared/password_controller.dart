import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PasswordController extends GetxController with WidgetsBindingObserver {
  final TextEditingController _passwordInputController =
      TextEditingController();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _promptForPassword();
    }
  }

  Future<void> _promptForPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('password');

    if (savedPassword != null && savedPassword.isNotEmpty) {
      _showPasswordDialog(savedPassword);
    }
  }

  void _showPasswordDialog(String savedPassword) {
    Get.dialog(
      AlertDialog(
        title: const Text('Enter Password'),
        content: TextField(
          controller: _passwordInputController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_passwordInputController.text == savedPassword) {
                Get.back(); // Close the dialog
              } else {
                Get.snackbar(
                  'Error',
                  'Incorrect password, try again.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog without action
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
