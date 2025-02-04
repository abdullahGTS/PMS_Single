import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Models/transactiontable.dart';
import '../models/database_helper.dart';

class SyncingController extends GetxController {
  var isLoading = true.obs;
  var status = "Syncing...".obs;
  String androidId_id = '';
  String tokenofapi = '';
  String csrftokenofapi = '';
  bool flagconnection = false;
  String fileConfigPath = ''; // Global variable for file path
  SharedPreferences? prefs;
  Timer? timer;
  final customController = Get.find<CustomAppbarController>();
  final dbHelper = DatabaseHelper();
  var androidId_idshowing = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    // fetchToken();
    GetSerialNumber();
    startPeriodicFetch();
    await startWIFIBackgroundService();
    await startBackgroundService();
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // String? androidId = androidInfo.id;
    // androidId_idshowing.value = androidId;

    // Repeat the drop animation indefinitely
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
      print("Timer stopped.");
    }

    super.onClose();
  }

  // Method to stop loading when condition is met
  void stopLoading(amountval) {
    isLoading.value = true;
  }

  Future<void> fetchToken() async {
    final baseUrl = 'https://41.33.226.46/adminpanal/pos/get/token/api/';
    print("Starting fetchToken...------------->");

    try {
      // Get the Android ID
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // String? androidId = androidInfo.id;
      // androidId_id = androidId;

      // if (androidId == null) {
      //   print('Failed to get Android ID');
      //   return;
      // }

      print("Android ID: $androidId_id");

      // Add the Android ID as a query parameter
      final url = Uri.parse('$baseUrl?android_id=$androidId_id');
      print("Request URL: $url");

      try {
        // Add a timeout to the HTTP request
        final response =
            await http.get(url).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          if (response.headers.containsKey('set-cookie')) {
            print('Response data: ${response.body}');
            // Extract CSRF token from the cookie
            final cookies = response.headers['set-cookie']!;
            final csrfToken =
                RegExp(r'csrftoken=([^;]+)').firstMatch(cookies)?.group(1);

            tokenofapi = json.decode(response.body)['token'];
            csrftokenofapi = csrfToken ?? '';
            print("Token: $tokenofapi");
            print("CSRF Token: $csrftokenofapi");
            status.value = 'Connecting...';
            await sendAndroidIdToApi(csrftokenofapi);
          } else {
            print("No cookies received.");
          }
        } else {
          print('Failed to load data. Status code: ${response.statusCode}');
        }
      } on TimeoutException {
        print("Request timed out.");
      } catch (e) {
        print("Error during HTTP request: $e");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> sendAndroidIdToApi(String csrfToken) async {
    print('Token: $tokenofapi');
    final baseUrl = 'https://41.33.226.46/adminpanal/pos/config/api/';

    try {
      final url = Uri.parse(baseUrl);

      // Send POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken, // Include CSRF token
          'Cookie': 'csrftoken=$csrfToken', // Attach CSRF cookie
        },
        body: jsonEncode({'pos_token': tokenofapi}),
      );

      if (response.statusCode == 200) {
        print('Android ID sent successfully: ${response.body}');
        final parsedData = json.decode(response.body);

        print("parsedData${parsedData}");
        status.value = 'Loading...';
        // Save the config to a file
        await saveConfigToFile(parsedData);

        if (parsedData.containsKey('shift_data') &&
            parsedData['shift_data'].isNotEmpty) {
          print("parsedData['shift_data']${parsedData['shift_data']}");
          var shift = Shifts(
              startshift: parsedData['shift_data']['startshift'],
              endshift: parsedData['shift_data']['endshift'],
              supervisor: parsedData['shift_data']['supervisor'],
              totalamount: parsedData['shift_data']['totalamount'],
              totalmoney: parsedData['shift_data']['totalmoney'],
              totaltips: parsedData['shift_data']['totaltips'],
              transnum: parsedData['shift_data']['transnum'],
              status: parsedData['shift_data']['status'],
              Isportal: parsedData['shift_data']['Isportal'],
              supervisor_id: parsedData['shift_data']['supervisor_id'],
              shift_num: parsedData['shift_data']['shift_num']);
          print("shift${shift}");

          var shift_id = await dbHelper.insertShift(shift.toMap());
          print("shiftsucess${shift}");

          // print('supervisor_id${supervisor_id}');
          if (shift_id != -1) {
            final prefs = await SharedPreferences.getInstance();
            prefs.setInt('shift_id', shift_id);
            print("shift_id${shift_id}");
          }
          Get.offAllNamed('/Home');
        } else {
          customController.isconnect.value = true;
          Get.toNamed('/Shift');
        }
        // Get.toNamed('/');
        // Optional: Update timestamps or perform further actions
      } else {
        print("error");
      }
    } catch (e) {
      print("error${e}");
    }
  }

  Future<void> saveConfigToFile(dynamic configValue) async {
    try {
      // Get the application's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/configfile.json');
      fileConfigPath = file.path;

      // Convert the data to JSON and write it to the file
      final jsonString = jsonEncode(configValue);
      await file.writeAsString(jsonString);

      print("Config saved successfully to ${file.path}");
      prefs = await SharedPreferences.getInstance();
      prefs?.setBool('getConfig', true);
      status.value = 'Redirecting...';
      Get.offAllNamed('/');
    } catch (e) {
      print("Failed to save config to file: $e");
    }
  }

  void startPeriodicFetch() async {
    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      print("Running periodic fetchToken...");

      fetchToken();
    });
  }

  Future<String?> GetSerialNumber() async {
    String? response;
    try {
      const _channel = MethodChannel('com.example.pms/method');
      response = await _channel.invokeMethod<String>('getSerialNumber');

      androidId_id = response ?? '';
      androidId_idshowing.value = response ?? '';

      print("response${response}");
    } catch (e) {
      // Handle error
      print("Error retrieving serial number: $e");
      response = 'No response';
    }
    return response;
  }

  startWIFIBackgroundService() async {
    const _channel = MethodChannel('com.example.pms/method');
    var response = await _channel.invokeMethod('enableWifi');
    // Wait for the transaction result
    print('startWIFIBackgroundService---> ${response}');
  }

  startBackgroundService() async {
    const _channel = MethodChannel('com.example.pms/method');
    await _channel.invokeMethod('startService');
  }
}
