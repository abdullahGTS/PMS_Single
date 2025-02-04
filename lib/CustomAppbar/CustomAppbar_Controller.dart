import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pms/Home/Home_Controller.dart';
import 'package:xml/xml.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import '../Models/transactiontable.dart';
import '../models/database_helper.dart';
import '../FusionConnection/tcpSocket.dart'; // For handling List<int> data
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppbarController extends GetxController {
  // final homeController = Get.put(HomeController());
  final RxList<dynamic> filteredTransactions = <dynamic>[].obs;

  late TcpSocketConnection socketConnection;
  late int iD;
  int trxSeqNoCounter = 0;
  String message = "";
  final DatabaseHelper dbHelper = DatabaseHelper();
  // Define the XML content for the first request
  late String xmlContent;
  late String xmlContent2;
  late String xmlContent3;
  late String xmlContentreq;
  late List<int> xmlContentBytes;
  late int headerLength;
  late List<int> headerLengthBytes;
  late int headerAlgorithm;
  late List<int> headerAlgorithmBytes;
  RxMap<String, dynamic> config = <String, dynamic>{}.obs;
  late List<int> header;
  late String total = '00.00';
  late String liters = '00.00';
  late String price = '00.00';

  String tokenofapi = '';
  String csrftokenofapi = '';
  String androidId_id = '';
  bool flagconnection = false;

  var timeoftellecollect = ''.obs;
  var isconnect = false.obs;

  String fileConfigPath = ''; // Global variable for file path

  var xmlData = ''.obs; // Observable string for XML data
  var getFuelSaleTrxDetailsByNo = ''.obs; // Observable string for XML data
  // ignore: non_constant_identifier_names
  var MessageType = ''.obs;
  var pumpNo = ''.obs;
  var fdCTimeStamp = ''.obs;
  var nozzleNo = ''.obs;
  var transactionSeqNo = ''.obs;
  var amountVal = 0.0.obs;
  var volume = 0.0.obs;
  var unitPrice = 0.0.obs;
  var volumeProduct1 = 0.0.obs;
  var volumeProduct2 = 0.0.obs;
  var productNo1 = 0.obs;
  var blendRatio = 0.obs;
  var startTimeStamp = "".obs;
  var endTimeStamp = "".obs;
  var type = "".obs;
  var deviceID = "".obs;
  var fusionSaleId = "".obs;
  var statevalue = "".obs;
  var releaseToken = "".obs;
  var completionReason = "".obs;
  var fuelMode = "".obs;
  var AuthorisationApplicationSender = "".obs;
  var productNo = "".obs;
  var productUM = "liters".obs;
  var productName = "".obs;
  var TipsValue = "".obs;
  var AllAmountValue = "".obs;
  var paymentType = 1.obs;
  var currentXmlData = ''.obs;
  var counterTrans = 0.obs;
  var stanNumber = 0.obs;
  var voucherNo = 0.obs;
  var ecrRef = "".obs;
  var batchNo = 0.obs;
  var totalAmount = 0.0.obs; // Observable for the total amount
  var totalTipsAmount = 0.0.obs; // Observable for the total amount
  var totalTipsplusAmount = 0.0.obs; // Observable for the total amount
  var TotalTransaction = 0.obs;
  var managershift = "".obs;
  var trxAttendant = "".obs;
  var datetimeshift = "".obs;
  var shift_id = 0.obs;
  var supervisor_id = 0.obs;
  var pinopenshift = 0.obs;
  final lastShift = Rx<Map<String, dynamic>?>(null); // For GetX observable
  var timer;
  var fusionTimer;
  var IpFuission;
  var PortFuission;
  var PublicTimer;
  var issupervisormaiar = false.obs;
  var fusionIP = "".obs;
  var fusionPort = "".obs;
  var SerialNumber = ''.obs;
  var ApplicationSender = ''.obs;
  var WorkstationID = ''.obs;
  var checkFueling = ''.obs;
  var checkTransSecNum = 0.obs;

  var pumpState = true.obs;
  var pumpStateNumber = 0.obs;

  @override
  void onInit() async {
    super.onInit();

    await GetSerialNumber();
    xmlContent = '''
      <?xml version="1.0" encoding="utf-8"?>
      <ServiceRequest
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:xsd="http://www.w3.org/2001/XMLSchema"
          RequestType="LogOn"
          ApplicationSender="${SerialNumber.value.substring(SerialNumber.value.length - 5)}"
          WorkstationID="PMS"
          RequestID="0">
        <POSdata>
          <POSTimeStamp>${DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now())}</POSTimeStamp>
          <InterfaceVersion>1.00</InterfaceVersion>
        </POSdata>
      </ServiceRequest>
    ''';
    iD = 1;

    xmlContent2 = '''
      <?xml version="1.0" encoding="utf-8"?>
      <POSMessage MessageType="POS_Ready"
            ApplicationSender="${SerialNumber.value.substring(SerialNumber.value.length - 5)}"
            WorkstationID="PMS"
            MessageID="$iD"
            xmlns:IFSF="http://www.ifsf.org/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="./Schemas/FDC_POS_Ready_Unsolicited.xsd">
          <POSdata>
            <POSTimeStamp>${DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now())}</POSTimeStamp>
          </POSdata>
      </POSMessage>
    ''';

    if (Get.currentRoute == "/Home") {
      startPeriodicFetch();
    } else {
      await fetchToken();
      if (timer != null) {
        timer!.cancel();
        print("Timer stopped.");
      }
    }

    // socketConnection =
    //     TcpSocketConnection(fusionIP.value, int.parse(fusionPort.value));

    if (Get.currentRoute != "/Home") {
      startPeriodicFusionLogin();
    } else {
      await startConnection();
      if (fusionTimer != null) {
        fusionTimer!.cancel();
        print("fusionTimer stopped.");
      }
    }
    // startConnection();
    fetchTransactions();
    calculateTotalAmount();
    calculateTotalTipsAmount();
    calculateTipsplusTotalAmount();
    printRowCount();

    var last_shift = await dbHelper.lastShift();
    print("last_shiftsupervisor${last_shift?['supervisor']}");
    if (last_shift?['status'] == 'opened') {
      managershift.value = last_shift?['supervisor'] ?? '';
      datetimeshift.value = last_shift?['startshift'] ?? '';
    }
  }

  Future<void> fetchTransactionsByshift(int shift) async {
    try {
      final dbHelper = DatabaseHelper();
      List<Map<String, dynamic>> data = await dbHelper.fetchDataByShift(shift);
      print("Filtered transactions: ${data}");

      // Assign the reversed data to the observable list
      filteredTransactions.assignAll(data.reversed);
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  // Navigate to the verify page
  void gotoveify() {
    Get.offNamed("/verify");
  }

  Future<void> fetchTransactions() async {
    try {
      final dbHelper = DatabaseHelper();
      List<dynamic> data = await dbHelper.fetchAllData();
      print("dataofalltrans${data}");

      // Assign the data directly to the observable list
      filteredTransactions.assignAll(data.reversed);
    } catch (e) {
      print("Error fetching transactions: $e");
    }
  }

  Future<void> fetchToken() async {
    final baseUrl = 'https://41.33.226.46/adminpanal/pos/get/token/api/';
    print("Starting fetchToken...------------->");
    print("Starting fetchToken...------------->${isconnect.value}");

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

      // print("Android ID: $androidId");

      // Add the Android ID as a query parameter
      final url = Uri.parse('$baseUrl?android_id=${SerialNumber.value}');
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
            flagconnection = true;
            isconnect.value = true;

            await sendAndroidIdToApi(csrftokenofapi);
          } else {
            print("No cookies received.");
          }
        } else {
          print('Failed to load data. Status code: ${response.statusCode}');
        }
      } on TimeoutException {
        print("Request timed out.");
        flagconnection = false;

        isconnect.value = false;
      } catch (e) {
        print("Error during HTTP request: $e");
        flagconnection = false;

        isconnect.value = false;
      }
    } catch (e) {
      print('Error: $e');
      flagconnection = false;

      isconnect.value = false;
    }

    if (!flagconnection) {
      print("Connection failed. Loading from local configuration.");
      readConfigFromFile();
      isconnect.value = false;
    }
  }

  void startPeriodicFetch() async {
    await fetchToken();

    timer = Timer.periodic(const Duration(minutes: 10), (timer) async {
      print("Running periodic fetchToken...");

      if (isconnect.value) {
        fetchToken();

        sendtaxreid();
        sendShiftsToApi();
        sendTransactionsToApi();
      } else {
        await readConfigFromFile();
      }
    });
  }

  void startPeriodicFusionLogin() async {
    // await startConnection();

    timer = Timer.periodic(const Duration(minutes: 2), (timer) async {
      print("Running periodic fetchToken...");
      startConnection();
    });
  }

  // void checkShiftClose() async {
  //   var status = config.value['shift_data']['status'];
  //   if (status == "closed") {
  //     if (Get.currentRoute == "/Home") {
  //       dbHelper.updatestatusshift(
  //           int.parse(config.value['shift_data']['shift_num']) ?? 0,
  //           "closed",
  //           config.value['shift_data']['endshift']);
  //       await dbHelper.updateIsPortalShift(
  //           int.parse(config.value['shift_data']['shift_num']),
  //           config.value['shift_data']['status']);

  //       Get.offAllNamed('/CloseShift');
  //     }
  //   }
  // }

  void updateTime() {
    timeoftellecollect.value =
        DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now());
  }

  Future<void> sendAndroidIdToApi(String csrfToken) async {
    print('Token: $tokenofapi');

    var last_shift = await dbHelper.lastShift();
    print("last_shiftsupervisor${last_shift?['supervisor']}");

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
        print(" isconnect.value${isconnect.value}");
        print('Android ID sent successfully: ${response.body}');
        final parsedData = json.decode(response.body);

        // Update the config value
        config.value = parsedData;
        fusionPort.value = parsedData['fusion_port'];
        fusionIP.value = parsedData['fusion_ip'];

        // Save the config to a file
        await saveConfigToFile(config.value);
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

          managershift.value = parsedData['shift_data']['supervisor'];
          datetimeshift.value = parsedData['shift_data']['startshift'];

          final supervisorFromShift = parsedData['shift_data']['supervisor_id'];

          // Ensure supervisors exist in parsedData

          final supervisors = parsedData['supervisors'] as List;

          print("supervisorFromShift${supervisorFromShift}");
          // Search for the supervisor in the supervisors list
          final matchingSupervisor = supervisors.firstWhere(
            (supervisor) => supervisor['id'] == supervisorFromShift,
            orElse: () => null,
          );
          print("matchingSupervisor${matchingSupervisor}");

          // If supervisor is found, assign the PIN to pinopenshift.value
          if (matchingSupervisor != null) {
            pinopenshift.value = int.parse(matchingSupervisor['pin']);
            print('Supervisor PIN found: ${pinopenshift.value}');
          } else {
            print('No matching supervisor found.');
          }

          if (last_shift?['shift_num'] ==
              parsedData['shift_data']['shift_num']) {
            print("shift if ------->${parsedData['shift_data']}");
            print('customcontshift${last_shift?['id']}');
            dbHelper.updatestatusshift(
                int.parse(last_shift?['shift_num']) ?? 0,
                parsedData['shift_data']['status'],
                parsedData['shift_data']['endshift']);
            dbHelper.updateShiftNum(int.parse(last_shift?['id']),
                int.parse(last_shift?['shift_num']));
          } else {
            print("shift else------->${parsedData['shift_data']}");
            var shift_id = await dbHelper.insertShift(shift.toMap());
            print("shift_idcustomappbar${shift_id}");
            final prefs = await SharedPreferences.getInstance();
            prefs.setInt('shift_id', shift_id);

            print("shiftsucess${shift}");
          }
          print(
              "parsedData['shift_data']['status']${parsedData['shift_data']['status']}");

          // print('supervisor_id${supervisor_id}');
          // if (shift_id != -1) {
          //   final prefs = await SharedPreferences.getInstance();
          //   prefs.setInt('shift_id', shift_id);
          //   print("shift_id${shift_id}");
          // }
          if (parsedData['shift_data']['status'] == "opened") {
            Get.toNamed('/Home');
          } else {
            Get.toNamed('/Shift');
          }
        } else {
          isconnect.value = true;
          Get.toNamed('/Shift');
        }

        // Optional: Update timestamps or perform further actions
        updateTime();
        print("Config saved and updated: ${config.value}");
        readConfigFromFile();
      } else {
        print(" isconnect.value${isconnect.value}");

        print('Failed to send Android ID. Status code: ${response.statusCode}');
        print("Falling back to reading from local configuration...");
        await readConfigFromFile(); // Read existing config if API fails
      }
    } catch (e) {
      print('Error during API request:sendAndroidIdToApi: $e');
      print("Reading config from local storage...");
      await readConfigFromFile(); // Read existing config in case of error
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
    } catch (e) {
      print("Failed to save config to file: $e");
    }
  }

  Future<dynamic> readConfigFromFile() async {
    try {
      // Check if the file path is set
      if (fileConfigPath.isEmpty) {
        final directory = await getApplicationDocumentsDirectory();
        fileConfigPath = '${directory.path}/configfile.json';
      }

      // Check if the file exists
      final file = File(fileConfigPath);
      if (!file.existsSync()) {
        print("Config file not found at: $fileConfigPath");
        return null;
      }

      // Read and parse the JSON file
      final jsonString = await file.readAsString();
      final configData = jsonDecode(jsonString);

      print("Config read successfully: $configData");
      config.value = configData;
      fusionIP.value = configData['fusion_ip'];
      fusionPort.value = configData['fusion_port'];
      // Return the parsed data
    } catch (e) {
      print("Failed to read config from file: $e");
      return null;
    }
  }

  // Receiving and sending back a custom message
  void messageReceived(List<int> msg) async {
    String xmlString;
    try {
      print("okthismessage");
      // Decode only the portion of the data that you expect to be UTF-8
      // xmlString = utf8.decode(msg.sublist(6)); // Adjust this index as necessary
      xmlString = utf8.decode(msg.sublist(6)); // Adjust this index as necessary
      xmlData.value = xmlString;

      // Get.snackbar(
      //   'Fusion Response',
      //   '',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.black,
      //   colorText: Colors.white,
      //   messageText: Text(
      //     xmlString,
      //     style: TextStyle(
      //         fontSize: 12, color: Colors.white), // Set message font size
      //   ),
      // );
      print("Decoded msg: $xmlString");
      // xmlData.value = xmlString;
      // Get.snackbar(
      //   'Fusion Response',
      //   '${xmlString}',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
      // final directory = await getApplicationDocumentsDirectory();
      // final file = File('${directory.path}/socketLog.json');
      // await file.writeAsString(
      //   xmlString,
      //   mode: FileMode.append,
      // );
      final document = XmlDocument.parse(xmlString);
      var fdcMessage = document.getElement('FDCMessage');
      MessageType.value = fdcMessage!.getAttribute('MessageType') ?? '';
      if (fdcMessage != null && MessageType.value == 'FDC_Ready') {
        // if (MessageType.value == 'FDC_Ready') {
        // Get.snackbar(
        //   'FDC_Ready',
        //   '${MessageType.value}',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        socketConnection.sendMessage(getXmlHeader(incrementXml()));
        // Get.snackbar(
        //   'POS_Ready',
        //   '${MessageType.value}',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        // }
      }

      // final document = XmlDocument.parse(xmlString);
      // xmlData.value = document.toString();
      // checkTransSecNum.value = int.parse(document
      //         .findAllElements('DeviceClass')
      //         .first
      //         .getAttribute('TransactionSeqNo') ??
      //     '');

      // var serviceResponse = document.getElement('ServiceResponse');
      // var fdcMessage = document.getElement('FDCMessage');

      // if (serviceResponse != null) {
      //   // Get attributes of ServiceResponse
      //   var requestType = serviceResponse.getAttribute('RequestType');
      //   var applicationSender =
      //       serviceResponse.getAttribute('ApplicationSender');
      //   var workstationID = serviceResponse.getAttribute('WorkstationID');
      //   var requestID = serviceResponse.getAttribute('RequestID');
      //   var overallResult = serviceResponse.getAttribute('OverallResult');

      //   if (requestType == 'GetFPState') {
      //     checkFueling.value = xmlString;
      //   }
      //   if (requestType == 'GetCurrentFuellingStatus') {
      //     checkTransSecNum.value = int.parse(document
      //             .findAllElements('DeviceClass')
      //             .first
      //             .getAttribute('TransactionSeqNo') ??
      //         '');
      //   }
      //   if (requestType == 'GetFuelSaleTrxDetailsByNo') {
      //     getFuelSaleTrxDetailsByNo.value = document.toString();
      //   }

      //   print('RequestType: $requestType');
      //   print('ApplicationSender: $applicationSender');
      //   print('WorkstationID: $workstationID');
      //   print('RequestID: $requestID');
      //   print('OverallResult: $overallResult');
      // } else {
      //   print('ServiceResponse tag not found');
      // }

      // if (fdcMessage != null) {
      //   // Get attributes of ServiceResponse
      //   var messageType = fdcMessage.getAttribute('MessageType');
      //   print("messageType----------${messageType}");
      //   if (messageType == 'FDC_Ready') {
      //     socketConnection.sendMessage(getXmlHeader(incrementXml()));
      //   }
      //   xmlData.value = document.toString();
      //   // else if (messageType == 'FuelSaleTrx') {
      //   //   print("messageTypeeeeeee----------${messageType}");
      //   //   try {
      //   //     print("document-------parseXmlData${document}");
      //   //     print("fdcMessage-------${fdcMessage}");
      //   //     // socketConnection.sendMessage(getXmlHeader(incrementXml()));
      //   //     statevalue.value = document.findAllElements('State').first.text;
      //   //     print("statevalue${statevalue}");

      //   //     AuthorisationApplicationSender.value = document
      //   //         .findAllElements('AuthorisationApplicationSender')
      //   //         .first
      //   //         .text;
      //   //     print(
      //   //         "AuthorisationApplicationSender${AuthorisationApplicationSender}");

      //   //     counterTrans++;
      //   //     updateCounterTrans(
      //   //         counterTrans.value); // Send counterTrans to HomeController
      //   //     fdCTimeStamp.value =
      //   //         document.findAllElements('FDCTimeStamp').first.text;
      //   //     type.value = document
      //   //             .findAllElements('DeviceClass')
      //   //             .first
      //   //             .getAttribute('Type') ??
      //   //         '';
      //   //     deviceID.value = document
      //   //             .findAllElements('DeviceClass')
      //   //             .first
      //   //             .getAttribute('DeviceID') ??
      //   //         '';
      //   //     pumpNo.value = document
      //   //             .findAllElements('DeviceClass')
      //   //             .first
      //   //             .getAttribute('PumpNo') ??
      //   //         '';
      //   //     nozzleNo.value = document
      //   //             .findAllElements('DeviceClass')
      //   //             .first
      //   //             .getAttribute('NozzleNo') ??
      //   //         '';
      //   //     transactionSeqNo.value = document
      //   //             .findAllElements('DeviceClass')
      //   //             .first
      //   //             .getAttribute('TransactionSeqNo') ??
      //   //         '';
      //   //     print("fdCTimeStamp${fdCTimeStamp.value}");

      //   //     print("type${type.value}");
      //   //     print("deviceID${deviceID.value}");
      //   //     print("pumpNo${pumpNo.value}");
      //   //     print("nozzleNo${nozzleNo.value}");
      //   //     print("transactionSeqNo${transactionSeqNo.value}");

      //   //     // fusionSaleId.value = document
      //   //     //         .findAllElements('DeviceClass')
      //   //     //         .first
      //   //     //         .getAttribute('FusionSaleId') ??
      //   //     //     '';
      //   //     releaseToken.value =
      //   //         document.findAllElements('ReleaseToken').first.text;
      //   //     // completionReason.value =
      //   //     //     document.findAllElements('CompletionReason').first.text;
      //   //     fuelMode.value = document
      //   //             .findAllElements('FuelMode')
      //   //             .first
      //   //             .getAttribute('ModeNo') ??
      //   //         '';

      //   //     productNo.value = document.findAllElements('ProductNo').first.text;
      //   //     amountVal.value = double.tryParse(
      //   //             document.findAllElements('Amount').first.text) ??
      //   //         0.0;
      //   //     volume.value = double.tryParse(
      //   //             document.findAllElements('Volume').first.text) ??
      //   //         0.0;
      //   //     unitPrice.value = double.tryParse(
      //   //             document.findAllElements('UnitPrice').first.text) ??
      //   //         0.0;
      //   //     volumeProduct1.value = double.tryParse(
      //   //             document.findAllElements('VolumeProduct1').first.text) ??
      //   //         0.0;
      //   //     volumeProduct2.value = double.tryParse(
      //   //             document.findAllElements('VolumeProduct2').first.text) ??
      //   //         0.0;
      //   //     productNo1.value = int.tryParse(
      //   //             document.findAllElements('ProductNo1').first.text) ??
      //   //         0;
      //   //     // productUM.value = document.findAllElements('ProductUM').first.text;
      //   //     productName.value =
      //   //         getProductName(int.parse(productNo.value)) ?? 'No Product';
      //   //     // productName.value = document.findAllElements('ProductName').first.text;
      //   //     blendRatio.value = int.tryParse(
      //   //             document.findAllElements('BlendRatio').first.text) ??
      //   //         0;

      //   //     if (statevalue.value == "Payable" &&
      //   //         AuthorisationApplicationSender.value ==
      //   //             androidId_id.split('.').join().substring(0, 5)) {
      //   //       print("thanks fueling");
      //   //       Get.toNamed('/Tips');
      //   //     } else {
      //   //       print('Test Failed');
      //   //     }
      //   //     print('MessageType: $messageType');

      //   //     // final document = XmlDocument.parse(xmlData);
      //   //     // var fdcMessage = document.findAllElements('FDCMessage').first;

      //   //     // // Get the MessageType attribute from the FDCMessage element
      //   //     // MessageType.value = fdcMessage.getAttribute('MessageType') ?? '';
      //   //     // ApplicationSender.value =
      //   //     //     fdcMessage.getAttribute('ApplicationSender') ?? '';
      //   //     // WorkstationID.value = fdcMessage.getAttribute('WorkstationID') ?? '';
      //   //     // print("MessageType----------------->: ${MessageType.value}");
      //   //     // if (MessageType.value == "FuelSaleTrx" && volume == amountVal.value) {
      //   //     //   counterTrans++;
      //   //     //   updateCounterTrans(
      //   //     //       counterTrans.value); // Send counterTrans to HomeController
      //   //     // }

      //   //     // fdCTimeStamp.value = document.findAllElements('FDCTimeStamp').first.text;
      //   //     // type.value =
      //   //     //     document.findAllElements('DeviceClass').first.getAttribute('Type') ??
      //   //     //         '';
      //   //     // deviceID.value = document
      //   //     //         .findAllElements('DeviceClass')
      //   //     //         .first
      //   //     //         .getAttribute('DeviceID') ??
      //   //     //     '';
      //   //     // pumpNo.value = document
      //   //     //         .findAllElements('DeviceClass')
      //   //     //         .first
      //   //     //         .getAttribute('PumpNo') ??
      //   //     //     '';
      //   //     // nozzleNo.value = document
      //   //     //         .findAllElements('DeviceClass')
      //   //     //         .first
      //   //     //         .getAttribute('NozzleNo') ??
      //   //     //     '';
      //   //     // transactionSeqNo.value = document
      //   //     //         .findAllElements('DeviceClass')
      //   //     //         .first
      //   //     //         .getAttribute('TransactionSeqNo') ??
      //   //     //     '';
      //   //     // fusionSaleId.value = document
      //   //     //         .findAllElements('DeviceClass')
      //   //     //         .first
      //   //     //         .getAttribute('FusionSaleId') ??
      //   //     //     '';
      //   //     // print("fusionSaleId.value${fusionSaleId.value}");
      //   //     // statevalue.value = document.findAllElements('State').first.text;
      //   //     // releaseToken.value = document.findAllElements('ReleaseToken').first.text;
      //   //     // // completionReason.value =
      //   //     // //     document.findAllElements('CompletionReason').first.text;
      //   //     // fuelMode.value =
      //   //     //     document.findAllElements('FuelMode').first.getAttribute('ModeNo') ??
      //   //     //         '';
      //   //     // productNo.value = document.findAllElements('ProductNo').first.text;
      //   //     // amountVal.value =
      //   //     //     double.tryParse(document.findAllElements('Amount').first.text) ?? 0.0;
      //   //     // volume.value =
      //   //     //     double.tryParse(document.findAllElements('Volume').first.text) ?? 0.0;
      //   //     // unitPrice.value =
      //   //     //     double.tryParse(document.findAllElements('UnitPrice').first.text) ??
      //   //     //         0.0;
      //   //     // volumeProduct1.value = double.tryParse(
      //   //     //         document.findAllElements('VolumeProduct1').first.text) ??
      //   //     //     0.0;
      //   //     // volumeProduct2.value = double.tryParse(
      //   //     //         document.findAllElements('VolumeProduct2').first.text) ??
      //   //     //     0.0;
      //   //     // productNo1.value =
      //   //     //     int.tryParse(document.findAllElements('ProductNo1').first.text) ?? 0;
      //   //     // productUM.value = document.findAllElements('ProductUM').first.text;
      //   //     // productName.value =
      //   //     //     getProductName(int.parse(productNo.value)) ?? 'No Product';
      //   //     // // productName.value = document.findAllElements('ProductName').first.text;
      //   //     // blendRatio.value =
      //   //     //     int.tryParse(document.findAllElements('BlendRatio').first.text) ?? 0;
      //   //   } catch (e) {
      //   //     print('Error parsing XML: $e');
      //   //   }
      //   // } else if (messageType == 'FPStateChange') {
      //   //   print('elseFPStateChange');
      //   // }
      //   print('MessageType: $messageType');
      // } else {
      //   print('FDCMessage tag not found');
      // }

      // var fdcMessage = document.findAllElements('FDCMessage').first;
      // MessageType.value = fdcMessage.getAttribute('MessageType') ?? '';
      // xmlData.value = xmlString;
      // if (MessageType.value == 'FDC_Ready') {
      //   socketConnection.sendMessage(getXmlHeader(incrementXml()));
      // }

      // var ServiceResponse = document.findAllElements('ServiceResponse').first;
      // print("ServiceResponse${ServiceResponse}");
      // var RequestType = ServiceResponse.getAttribute('RequestType') ?? '';
      // print("RequestType${RequestType}");

      // if (ServiceResponse != '') {
      //   print("iamhere");
      //   if (RequestType == 'GetFPState') {
      //     print("type here");

      //     checkFueling.value = xmlString;
      //     // parseXmlFuelingData(xmlString);
      //     // socketConnection.sendMessage(getXmlHeader(incrementXml()));
      //   }
      // }

      // Update the observable xmlData with the decoded XML string
      // print("xmlData${xmlData}");
      // final document = XmlDocument.parse(xmlString);

      // Check the MessageType in the parsed XML
      // var fdcMessage = document.findAllElements('FDCMessage').first;
      // var ServiceResponse = document.findAllElements('ServiceResponse').first;
      // print("ServiceResponse${ServiceResponse}");

      // Get the MessageType attribute from the FDCMessage element
      // var messageService = ServiceResponse.getAttribute('RequestType') ?? '';

      // print("messageService${messageService}");

      // print("MessageType.value-------${MessageType.value}");

      // print("MessageType: ${MessageType.value}");

      // else {
      //   print('FDC_Ready----Michael----> ${MessageType.value}');
      //   print('FDC_Status----Michael----> ${xmlString}');
      // }
      // You can call update() if you are using GetX with controllers
      // update(); // Uncomment if inside a GetX controller
    } catch (e) {
      // print("Error decoding message: $e");
      return; // Exit if decoding fails
    }

    // // Proceed with XML parsing
    // try {
    //   // final document = filterXmlContent(msg);
    //   // Further processing of the parsed XML document...
    // } catch (e) {
    //   print("Error parsing XML: $e");
    // }
  }

  List<int> getXmlHeader(String xmlContent) {
    // print("xmlContent${xmlContent}");
    xmlContentBytes = utf8.encode(xmlContent);

    headerLength = xmlContentBytes.length;
    headerLengthBytes = ByteData.sublistView(
      ByteData(4)..setInt32(0, headerLength, Endian.big),
    ).buffer.asUint8List();

    headerAlgorithm = 0;
    headerAlgorithmBytes = ByteData.sublistView(
      ByteData(2)..setInt16(0, headerAlgorithm, Endian.big),
    ).buffer.asUint8List();

    header = [...headerLengthBytes, ...headerAlgorithmBytes];
    // print([...header, ...xmlContentBytes]);
    return [...header, ...xmlContentBytes];
  }

  XmlDocument filterXmlContent(List<int> msg) {
    try {
      // Extracting only the relevant portion for XML parsing
      final xmlStartIndex = msg.indexOf(60); // 60 is the ASCII code for '<'
      if (xmlStartIndex == -1) {
        throw Exception('Invalid XML data: no start tag found');
      }

      final relevantBytes = msg.sublist(xmlStartIndex);
      final xmlString = utf8.decode(relevantBytes);
      return XmlDocument.parse(xmlString);
    } catch (e) {
      // print("XML parsing error: $e");
      rethrow; // Rethrow to handle it upstream if needed
    }
  }

  String incrementXml() {
    iD++;
    xmlContent2 = '''
      <?xml version="1.0" encoding="utf-8" ?>
      <POSMessage MessageType="POS_Ready"
            ApplicationSender="${SerialNumber.value.substring(SerialNumber.value.length - 5)}"
            WorkstationID="PMS"
            MessageID="$iD"
            xmlns:IFSF="http://www.ifsf.org/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:noNamespaceSchemaLocation="./Schemas/FDC_POS_Ready_Unsolicited.xsd">
          <POSdata>
            <POSTimeStamp>${DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now())}</POSTimeStamp>
          </POSdata>
      </POSMessage>
    ''';
    return xmlContent2;
  }

  //starting the connection and listening to the socket asynchronously
  startConnection() async {
    Get.snackbar(
      'Starting Connection',
      '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    print('${fusionIP.value} ${fusionPort.value}');
    socketConnection =
        TcpSocketConnection(fusionIP.value, int.parse(fusionPort.value));
    socketConnection.enableConsolePrint(true);
    if (await socketConnection.canConnect(5000, attempts: 3)) {
      Get.snackbar(
        'Connection Stablished',
        '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await socketConnection.connect(5000, messageReceived, attempts: 3);
      socketConnection.sendMessage(getXmlHeader(xmlContent));
      Get.snackbar(
        'POS Logged In',
        '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Get.closeAllSnackbars();
    } else {
      // print('abdullah failed to connect');
      Get.snackbar(
        'ALERT',
        'Connection Failed, Socket not connected',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      await Future.delayed(const Duration(seconds: 15));
      await startConnection();
    }
  }

  String? getProductName(int productNumber) {
    var allNozzles = config.value['pumps']
        .where((pump) => pump['nozzles'] != null) // Ensure nozzles is not null
        .expand((pump) =>
            pump['nozzles'] as Iterable<dynamic>) // Ensure it's an Iterable
        .toList();

    var nozzle = allNozzles.firstWhere(
      (nozzle) => nozzle['product_number'] == productNumber,
      orElse: () => null, // Handle case when not found
    );
    print("sssstest${nozzle?['product_name']}");
    return nozzle?['product_name'];
  }

  String? getProductNameByNozzleNum(int NozzleNumber) {
    var allNozzles = config.value['pumps']
        .where((pump) => pump['nozzles'] != null) // Ensure nozzles is not null
        .expand((pump) =>
            pump['nozzles'] as Iterable<dynamic>) // Ensure it's an Iterable
        .toList();

    var nozzle = allNozzles.firstWhere(
      (nozzle) => nozzle['nozzle_number'] == NozzleNumber,
      orElse: () => null, // Handle case when not found
    );
    print("sssstest${nozzle?['product_name']}");
    return nozzle?['product_name'];
  }

  String? getProductPrice(int productNumber) {
    var allNozzles = config.value['pumps']
        .where((pump) => pump['nozzles'] != null) // Ensure nozzles is not null
        .expand((pump) =>
            pump['nozzles'] as Iterable<dynamic>) // Ensure it's an Iterable
        .toList();

    var nozzle = allNozzles.firstWhere(
      (nozzle) => nozzle['product_number'] == productNumber,
      orElse: () => null, // Handle case when not found
    );
    print("sssstest${nozzle?['product_price']}");
    return nozzle?['product_price'].toString();
  }
  // void parseXmlData(String xmlData) {
  //   try {
  //     final document = XmlDocument.parse(xmlData);
  //     print("document-------parseXmlData${document}");
  //     var fdcMessage = document.getElement('FDCMessage');
  //     print("fdcMessage-------${fdcMessage}");
  //     if (fdcMessage != null) {
  //       // Get attributes of ServiceResponse
  //       var messageType = fdcMessage.getAttribute('MessageType');
  //       print("messageTypeparseXmlData----------${messageType}");

  //       if (messageType == 'FuelSaleTrx') {
  //         // socketConnection.sendMessage(getXmlHeader(incrementXml()));
  //         statevalue.value = document.findAllElements('State').first.text;
  //         print("statevalue${statevalue}");

  //         AuthorisationApplicationSender.value = document
  //             .findAllElements('AuthorisationApplicationSender')
  //             .first
  //             .text;
  //         print(
  //             "AuthorisationApplicationSender${AuthorisationApplicationSender}");

  //         counterTrans++;
  //         updateCounterTrans(
  //             counterTrans.value); // Send counterTrans to HomeController
  //         fdCTimeStamp.value =
  //             document.findAllElements('FDCTimeStamp').first.text;
  //         type.value = document
  //                 .findAllElements('DeviceClass')
  //                 .first
  //                 .getAttribute('Type') ??
  //             '';
  //         deviceID.value = document
  //                 .findAllElements('DeviceClass')
  //                 .first
  //                 .getAttribute('DeviceID') ??
  //             '';
  //         pumpNo.value = document
  //                 .findAllElements('DeviceClass')
  //                 .first
  //                 .getAttribute('PumpNo') ??
  //             '';
  //         nozzleNo.value = document
  //                 .findAllElements('DeviceClass')
  //                 .first
  //                 .getAttribute('NozzleNo') ??
  //             '';
  //         transactionSeqNo.value = document
  //                 .findAllElements('DeviceClass')
  //                 .first
  //                 .getAttribute('TransactionSeqNo') ??
  //             '';
  //         print("fdCTimeStamp${fdCTimeStamp.value}");

  //         print("type${type.value}");
  //         print("deviceID${deviceID.value}");
  //         print("pumpNo${pumpNo.value}");
  //         print("nozzleNo${nozzleNo.value}");
  //         print("transactionSeqNo${transactionSeqNo.value}");

  //         // fusionSaleId.value = document
  //         //         .findAllElements('DeviceClass')
  //         //         .first
  //         //         .getAttribute('FusionSaleId') ??
  //         //     '';
  //         releaseToken.value =
  //             document.findAllElements('ReleaseToken').first.text;
  //         // completionReason.value =
  //         //     document.findAllElements('CompletionReason').first.text;
  //         fuelMode.value = document
  //                 .findAllElements('FuelMode')
  //                 .first
  //                 .getAttribute('ModeNo') ??
  //             '';

  //         productNo.value = document.findAllElements('ProductNo').first.text;
  //         amountVal.value =
  //             double.tryParse(document.findAllElements('Amount').first.text) ??
  //                 0.0;
  //         volume.value =
  //             double.tryParse(document.findAllElements('Volume').first.text) ??
  //                 0.0;
  //         unitPrice.value = double.tryParse(
  //                 document.findAllElements('UnitPrice').first.text) ??
  //             0.0;
  //         volumeProduct1.value = double.tryParse(
  //                 document.findAllElements('VolumeProduct1').first.text) ??
  //             0.0;
  //         volumeProduct2.value = double.tryParse(
  //                 document.findAllElements('VolumeProduct2').first.text) ??
  //             0.0;
  //         productNo1.value =
  //             int.tryParse(document.findAllElements('ProductNo1').first.text) ??
  //                 0;
  //         // productUM.value = document.findAllElements('ProductUM').first.text;
  //         productName.value =
  //             getProductName(int.parse(productNo.value)) ?? 'No Product';
  //         // productName.value = document.findAllElements('ProductName').first.text;
  //         blendRatio.value =
  //             int.tryParse(document.findAllElements('BlendRatio').first.text) ??
  //                 0;

  //         if (statevalue.value == "Payable" &&
  //             AuthorisationApplicationSender.value ==
  //                 androidId_id.split('.').join().substring(0, 5)) {
  //           print("thanks fueling");
  //           Get.toNamed('/Tips');
  //           // textValue.value = '';
  //         }
  //       } else {
  //         print('FPStateChange');
  //       }
  //       print('MessageType: $messageType');
  //     } else {
  //       print('FDCMessage tag not found');
  //     }

  //     // final document = XmlDocument.parse(xmlData);
  //     // var fdcMessage = document.findAllElements('FDCMessage').first;

  //     // // Get the MessageType attribute from the FDCMessage element
  //     // MessageType.value = fdcMessage.getAttribute('MessageType') ?? '';
  //     // ApplicationSender.value =
  //     //     fdcMessage.getAttribute('ApplicationSender') ?? '';
  //     // WorkstationID.value = fdcMessage.getAttribute('WorkstationID') ?? '';
  //     // print("MessageType----------------->: ${MessageType.value}");
  //     // if (MessageType.value == "FuelSaleTrx" && volume == amountVal.value) {
  //     //   counterTrans++;
  //     //   updateCounterTrans(
  //     //       counterTrans.value); // Send counterTrans to HomeController
  //     // }

  //     // fdCTimeStamp.value = document.findAllElements('FDCTimeStamp').first.text;
  //     // type.value =
  //     //     document.findAllElements('DeviceClass').first.getAttribute('Type') ??
  //     //         '';
  //     // deviceID.value = document
  //     //         .findAllElements('DeviceClass')
  //     //         .first
  //     //         .getAttribute('DeviceID') ??
  //     //     '';
  //     // pumpNo.value = document
  //     //         .findAllElements('DeviceClass')
  //     //         .first
  //     //         .getAttribute('PumpNo') ??
  //     //     '';
  //     // nozzleNo.value = document
  //     //         .findAllElements('DeviceClass')
  //     //         .first
  //     //         .getAttribute('NozzleNo') ??
  //     //     '';
  //     // transactionSeqNo.value = document
  //     //         .findAllElements('DeviceClass')
  //     //         .first
  //     //         .getAttribute('TransactionSeqNo') ??
  //     //     '';
  //     // fusionSaleId.value = document
  //     //         .findAllElements('DeviceClass')
  //     //         .first
  //     //         .getAttribute('FusionSaleId') ??
  //     //     '';
  //     // print("fusionSaleId.value${fusionSaleId.value}");
  //     // statevalue.value = document.findAllElements('State').first.text;
  //     // releaseToken.value = document.findAllElements('ReleaseToken').first.text;
  //     // // completionReason.value =
  //     // //     document.findAllElements('CompletionReason').first.text;
  //     // fuelMode.value =
  //     //     document.findAllElements('FuelMode').first.getAttribute('ModeNo') ??
  //     //         '';
  //     // productNo.value = document.findAllElements('ProductNo').first.text;
  //     // amountVal.value =
  //     //     double.tryParse(document.findAllElements('Amount').first.text) ?? 0.0;
  //     // volume.value =
  //     //     double.tryParse(document.findAllElements('Volume').first.text) ?? 0.0;
  //     // unitPrice.value =
  //     //     double.tryParse(document.findAllElements('UnitPrice').first.text) ??
  //     //         0.0;
  //     // volumeProduct1.value = double.tryParse(
  //     //         document.findAllElements('VolumeProduct1').first.text) ??
  //     //     0.0;
  //     // volumeProduct2.value = double.tryParse(
  //     //         document.findAllElements('VolumeProduct2').first.text) ??
  //     //     0.0;
  //     // productNo1.value =
  //     //     int.tryParse(document.findAllElements('ProductNo1').first.text) ?? 0;
  //     // productUM.value = document.findAllElements('ProductUM').first.text;
  //     // productName.value =
  //     //     getProductName(int.parse(productNo.value)) ?? 'No Product';
  //     // // productName.value = document.findAllElements('ProductName').first.text;
  //     // blendRatio.value =
  //     //     int.tryParse(document.findAllElements('BlendRatio').first.text) ?? 0;
  //   } catch (e) {
  //     print('Error parsing XML: $e');
  //   }
  // }

  parseXmlFuelingData(String xmlData) {
    print("document-------??${xmlData}");
    try {
      final document = XmlDocument.parse(xmlData);
      var pumpNo = document
          .findAllElements('DeviceClass')
          .first
          .getAttribute('DeviceID');
      var status = document.findAllElements('DeviceState').first.text;
      print('pumpNo-----------: $pumpNo');
      print('status-----------: $status');

      if (status == 'FDC_FUELLING') {
        return [false, pumpNo];
        // pumpState.value = false;
        // pumpStateNumber.value = int.parse(pumpNo!);
      } else {
        return [true, pumpNo];
        // pumpState.value = true;
        // pumpStateNumber.value = int.parse(pumpNo!);
      }
      // return 'done';
    } catch (e) {
      print('Error parsing XML: $e');
    }
  }

  void updateCounterTrans(int value) {
    counterTrans.value = value;
    print('CounterTrans updated: $value');
  }

  // Save Transaction For Cash
  saveTransaction(int paymantTypenum) async {
    print("Saving transaction data...");
    print("stanNumber.value-------------->${stanNumber.value}");
    var paymantTypeName = 'No Payment Type';
    print("paymantTypeName${paymantTypenum}");
    if (paymantTypenum == 1) {
      paymantTypeName = 'Cash';
      print("paymantTypeName${paymantTypeName}");
    }
    if (paymantTypenum == 2) {
      paymantTypeName = 'Bank';
      print("paymantTypeName${paymantTypeName}");
    }
    if (paymantTypenum == 3) {
      paymantTypeName = 'Calibration';
      print("paymantTypeName${paymantTypeName}");
    }
    if (paymantTypenum == 4) {
      paymantTypeName = 'Fleet';
      print("paymantTypeName${paymantTypeName}");
    }
    if (paymantTypenum == 5) {
      paymantTypeName = 'Bank_Point';
      print("paymantTypeName${paymantTypeName}");
    }

    try {
      // Create a FuelSale instance with the current data
      var result = await dbHelper.lastShift();
      final prefs = await SharedPreferences.getInstance();
      var fuelSale = FuelSale(
        fdCTimeStamp: DateTime.now()
            .toString(), // Or use the parsed timestamp if available
        type: type.value,
        deviceID: deviceID.value,
        pumpNo: pumpNo.value,
        nozzleNo: nozzleNo.value,
        transactionSeqNo: transactionSeqNo.value,
        fusionSaleId: fusionSaleId.value,
        state: statevalue.value,
        releaseToken: releaseToken.value,
        completionReason: "",
        fuelMode: fuelMode.value,
        productNo: productNo.value,
        amount: amountVal.value,
        volume: volume.value,
        unitPrice: unitPrice.value,
        volumeProduct1: volumeProduct1.value,
        volumeProduct2: volumeProduct2.value,
        productNo1: productNo1.value.toString(),
        productUM: productUM.value,
        productName: getProductName(int.parse(productNo.value)) ?? 'No Product',
        blendRatio: blendRatio.value.toString(),
        TipsValue: TipsValue.value ?? "0",
        Isupolade: 'False',
        Isuuidgenerate: "False",
        statusvoid: "complete",
        payment_type: paymantTypeName,
        Isportal: "False",
        Stannumber: stanNumber.value,
        shift_id: result?['id'],
        taxRequestID: 0,
        voucherNo: voucherNo.value,
        ecrRef: ecrRef.value,
        batchNo: batchNo.value,

        // Set the TipsValue from the TipsController
      );

      // Insert the FuelSale instance into the database
      await dbHelper.insertFuelSale(fuelSale.toMap());

      await dbHelper.updateShiftData(
          prefs.getInt('shift_id') ?? 0,
          amountVal.value,
          amountVal.value + double.parse(TipsValue.value),
          double.parse(TipsValue.value));

      print('Fuel sale data saved to SQLite.');
      print('Fuel sale data saved to SQLite.${fuelSale}');
      if (isconnect.value) {
        await sendTransactionToApi();
        if (!issupervisormaiar.value) {
          await generateUuid();
          await sendtaxreid();
        }
      }

      clearFuelSaleTrx(pumpNo.value, transactionSeqNo.value, stanNumber.value);
    } catch (e) {
      print('Error saving transaction data: $e');
    }
  }

  clearFuelSaleTrx(pumpNum, transactionSeqNo, stanNum) {
    // Increment RequestID
    iD++;
    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
    String xl = '''
<?xml version="1.0" encoding="utf-8" ?>
<ServiceRequest RequestType="ClearFuelSaleTrx" ApplicationSender="${SerialNumber.value.substring(SerialNumber.value.length - 5)}" WorkstationID="PMS"
RequestID="${iD}"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="FDC_ClearFuelSaleTrx_Request.xsd">
<POSdata>
<POSTimeStamp>$currentTime</POSTimeStamp>
<DeviceClass Type="FP" DeviceID="$pumpNum" TransactionSeqNo="$transactionSeqNo" />
</POSdata>
</ServiceRequest>''';
    print("ClearFuelSaleTrx${xl}");
    // Send the constructed XML message through socket
    socketConnection.sendMessage(getXmlHeader(xl));
    transactionSeqNo.value = '';
  }

  // Send Bank Transaction To API
  sendTransactionToApi() async {
    var paymantTypeName = 'No Payment Type';
    if (paymentType.value == 1) {
      paymantTypeName = 'Cash';
    }
    if (paymentType.value == 2) {
      paymantTypeName = 'Bank';
    }
    if (paymentType.value == 3) {
      paymantTypeName = 'Calibration';
    }
    if (paymentType.value == 4) {
      paymantTypeName = 'Fleet';
    }
    if (paymentType.value == 5) {
      paymantTypeName = 'Bank Points';
    }
    print("paymantTypeName${paymantTypeName}");
    try {
      var result = await dbHelper.lastShift();
      // Send POST request
      const baseUrl = 'https://41.33.226.46/merchantpanal/pos/transaction/api/';
      final url = Uri.parse('$baseUrl');
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // String? androidId = androidInfo.id;

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrftokenofapi, // Include CSRF token
          'Cookie': 'csrftoken=${csrftokenofapi}', // Attach CSRF cookie
        },
        body: jsonEncode({
          'seq_no': transactionSeqNo.value,
          'fusion_sale': fusionSaleId.value,
          'volume': volume.value,
          'unit_price': unitPrice.value,
          'amount': amountVal.value,
          'unit_measure': productUM.value,
          'tips': TipsValue.value ?? 0,
          'date': fdCTimeStamp.value,
          'payment_type': paymantTypeName,
          'is_taxed': "false",
          'pos': SerialNumber.value,
          'product': productNo.value,
          'nozzle': nozzleNo.value,
          'pump': pumpNo.value,
          'station': config['station_code'],
          'shift': result?['shift_num']
        }),
      );

      if (response.statusCode == 200) {
        print('trans sent successfully------->>>> ${response.body}');
        dbHelper.updateIsPortal(transactionSeqNo.value, "True");
      } else {
        print('Failed to send Android ID. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  sendTransactionsToApi() async {
    try {
      // Send POST request
      var result = await dbHelper.getAllShiftsData();

      const baseUrl =
          'https://41.33.226.46/merchantpanal/pos/transactions/api/';
      final url = Uri.parse('$baseUrl');
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // String? androidId = androidInfo.id;
      var trx_list = [];
      for (var trx in filteredTransactions) {
        if (trx['Isportal'] == "False") {
          trx_list.add({
            'seq_no': trx['transactionSeqNo'],
            'fusion_sale': trx['fusionSaleId'],
            'volume': trx['volume'],
            'unit_price': trx['unitPrice'],
            'amount': trx['amount'],
            'unit_measure': "liters",
            'tips': trx['TipsValue'] ?? 0,
            'date': trx['fdCTimeStamp'],
            'payment_type': trx['payment_type'],
            'is_taxed': trx['Isupolade'],
            'pos': SerialNumber.value,
            'product': trx['productNo'],
            'nozzle': trx['nozzleNo'],
            'pump': trx['pumpNo'],
            'station': config['station_code'],
            'shift': trx['shift_num']
          });
        }
      }
      print("filteredTransactions->>>>${filteredTransactions}");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrftokenofapi, // Include CSRF token
          'Cookie': 'csrftoken=${csrftokenofapi}', // Attach CSRF cookie
        },
        body: jsonEncode(trx_list),
      );

      if (response.statusCode == 200) {
        print('trans  sent successfully: ${response.body}');
        final parsedData = json.decode(response.body);
        for (var trx in filteredTransactions) {
          if (trx['Isportal'] == "False") {
            dbHelper.updateIsPortal(trx['transactionSeqNo'], "True");
          }
        }
        // amountVal.value = 0;
      } else {
        print('Failed to send Android ID. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  getTransactionWithSeqNo() {}
  String currentTime =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
  String getFormattedCurrentDateTime() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time as 'yyyy-MM-ddTHH:mm:ssZ'
    String formattedDateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(now.toUtc());

    return formattedDateTime;
  }

  //generate uuid to the transaction
  Future<void> generateUuid() async {
    print("uuuuuuuuuidddd");
    const String apiUrl = "https://41.33.226.46:14433/uuidapi/";
    Map<String, dynamic> filteredData = {
      "dateTimeIssued": getFormattedCurrentDateTime(),
      "receiptNumber": 'Rec-Test-02',
      "seller": config['seller'],
      "buyer": {"type": "P", "id": "", "name": "Cash User"},
      "Productreference": productNo.value,
      "quantity": volume.value,
      "unitPrice": unitPrice.value,
      "totalSale": amountVal.value + double.parse(TipsValue.value),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(filteredData),
      );
      print("ssssssssssssssuuuuid");
      if (response.statusCode == 200) {
        print("Data sent successfully: ${response.body}");
        var responseData = jsonDecode(response.body);
        print(responseData['request_id']);
        await dbHelper.updateIstaxreq(
            transactionSeqNo.value, responseData['request_id']);

        // await dbHelper.updateIsuuidgenerate(transactionSeqNo.value, 'true');
        // sendRecietCash(response.body);
        print('Fuel sale data saved to SQLite.sssssssssttttttttttt');
        await dbHelper.fetchAndPrintAllData();
        // sendReciet(response.body);
      } else {
        print("Failed to send data: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  sendtaxreid() async {
    print('Token: $tokenofapi');
    var result = await dbHelper.getFuelSalesWithUuidNotGenerated();
    List<int> taxRequestList =
        result.map((row) => row['taxRequestID'] as int).toList();

    // Prepare the list of taxRequestID

    final baseUrl = 'https://41.33.226.46:14433/get/outputs/';

    try {
      final url = Uri.parse(baseUrl);
      print("taxRequestList${taxRequestList}");

      // Send POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Attach CSRF cookie
        },
        body: jsonEncode({'ids': taxRequestList}),
      );

      if (response.statusCode == 200) {
        print("sucess${response.body}");
        var responseData = jsonDecode(response.body);

        print("responseDataresponseData${responseData}");
        // print("responseDataresponseData${responseData['req_id']}");
        // print("responseDatares----------->>>${responseData['data']}");
        if (responseData is List) {
          for (var item in responseData) {
            print("Record updated for req_id: ${item['req_id']}");
            await dbHelper.updateIsuuidgenerate(
                item['req_id'].toString(), "True");

            var access_token = await authintcatePos();
            await sendReceipt(item, access_token);
            // Safely access 'req_id' and update the database
          }
        }

        // int reqId = int.tryParse(response.body['req_id'].toString()) ?? 0;
        // dbHelper.updateIsuuidgenerate(responseData['req_id'], "True");
      } else {
        print("notsucess");
      }
    } catch (e) {
      print('Error during API request:sendtaxreid: $e');
      print("Reading config from local storage...");
      // Read existing config in case of error
    }
  }

  Future<String> authintcatePos() async {
    var posserial = 'Rec-Test-02';
    var pososversion = 'windows';
    var presharedkey = 'C68FEC13-FE34-4839-89F9-ADB0D678CFE0';
    var client_id = 'f71ccd7d-d7fe-4956-8b95-a9b5e8d27a9f';
    var client_secret = 'e1b66109-bf19-4a48-bf5a-6383b128168f';
    const String apiUrl = "https://id.preprod.eta.gov.eg/connect/token";

    try {
      final response = await http.post(Uri.parse(apiUrl), headers: {
        'posserial': posserial,
        'pososversion': pososversion,
        'presharedkey': presharedkey
      }, body: {
        'grant_type': 'client_credentials',
        'client_id': client_id,
        'client_secret': client_secret
      });
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // String? androidId = androidInfo.id;
      // androidId_id = androidId;

      if (response.statusCode == 200) {
        print("Data sent successfully: ${response.body}");
        var result = json.decode(response.body);
        print("authintcatePosauthintcatePos${result['access_token']}");
        var posauth = PosAuth(
            andriod_id: SerialNumber.value,
            pos_serial: posserial,
            client_id: client_id,
            secret_key: client_secret,
            status_code: response.statusCode.toString(),
            access_token: result['access_token'],
            status: response.body);

        // Insert the posauth instance into the database
        await dbHelper.insertPosAuth(posauth.toMap());
        return result['access_token'];

        // Assuming `fromMap` maps the response data to the model
      } else {
        print("Failed to send data: ${response.statusCode}");
        var posauth = PosAuth(
            andriod_id: SerialNumber.value,
            pos_serial: posserial,
            client_id: client_id,
            secret_key: client_secret,
            status_code: response.statusCode.toString(),
            access_token: "",
            status: response.body);

        // Insert the posauth instance into the database
        await dbHelper.insertPosAuth(posauth.toMap());
        print("Response: ${response.body}");
        return '';
      }
    } catch (e) {
      print("Error: $e");
      return '';
    }
  }

  sendReceipt(output, access_token) async {
    print("output----------->${[output['data']]}");
    print("access_token----------->${access_token}");
    const String apiUrl =
        "https://api.preprod.invoicing.eta.gov.eg/api/v1/receiptsubmissions";
    try {
      var requestBody = {
        "receipts": [output['data']]
      };
      print("requestBody->>>>>>>>${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'version': '1',
          'Authorization': 'Bearer $access_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 202) {
        print("Data sent successfully: ${response.body}");
        final responseBody = json.decode(response.body);
        if (responseBody['rejectedDocuments'] != null &&
            responseBody['rejectedDocuments'] is List &&
            responseBody['rejectedDocuments'].isNotEmpty) {
          print("rejected");
          await dbHelper.updateIsupolade(transactionSeqNo.value, 'False');
        } else {
          await dbHelper.updateIsupolade(transactionSeqNo.value, 'True');
          await sendtoupdateistaxed();
          var posreceipt = PosReceipt(
              req_id: output['req_id'].toString(),
              status_code: response.statusCode.toString(),
              status: "${response.body}");
          print("submit-------->${response.body}");

          // Insert the posauth instance into the database
          await dbHelper.insertPosReceipt(posreceipt.toMap());
        }

        // Assuming `fromMap` maps the response data to the model
      } else {
        print("Failed to send data: ${response.statusCode}");
        print("Response: ${response.body}");
        var posreceipt = PosReceipt(
            req_id: output['req_id'].toString(),
            status_code: response.statusCode.toString(),
            status: "${response.body}");

        // Insert the posauth instance into the database
        await dbHelper.insertPosReceipt(posreceipt.toMap());
      }
    } catch (e) {
      print("Error----->>>: $e");
    }
  }

  saveShiftTabledata() async {
    try {
      // Create a FuelSale instance with the current data
      print('datetimeshift.value===>${datetimeshift.value}');
      print('managershift.value===>${managershift.value}');
      print('supervisor_id.value===>${supervisor_id.value}');
      var shift = Shifts(
          startshift: datetimeshift.value,
          endshift: '',
          supervisor: managershift.value,
          totalamount: 0,
          totalmoney: 0,
          totaltips: 0,
          transnum: 0,
          status: "opened",
          Isportal: "False",
          supervisor_id: supervisor_id.value,
          shift_num: "0");

      var shift_id = await dbHelper.insertShift(shift.toMap());
      // print('supervisor_id${supervisor_id}');
      if (shift_id != -1) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('shift_id', shift_id);
        print("shift_id${shift_id}");
      }

      print('shift data saved to SQLite.');
    } catch (e) {
      print('Error saving transaction data: $e');
    }
  }

  Future<void> sendShiftToApi() async {
    try {
      var result = await dbHelper.lastShift();
      print("result===>${result}");

      // await fetchLastShift();

      const baseUrl = 'https://41.33.226.46/merchantpanal/pos/shift/api/';
      final url = Uri.parse(baseUrl);
      final prefs = await SharedPreferences.getInstance();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrftokenofapi, // Include CSRF token
          'Cookie': 'csrftoken=$csrftokenofapi', // Attach CSRF cookie
        },
        body: jsonEncode({
          'shift_num': result?['id'],
          'start_date': result?['startshift'],
          'end_date': result?['endshift'],
          'total_amount': result?['totalamount'],
          'total_tips': result?['totaltips'],
          'total': result?['totalmoney'],
          'total_transactions': result?['transnum'],
          'supervisor': result?['supervisor_id'],
          'status': result?['status'],
          'station': config['station_code'] ?? '',
        }),
      );
      print({
        'shift_num': result?['id'],
        'start_date': result?['startshift'],
        'end_date': result?['endshift'],
        'total_amount': result?['totalamount'],
        'total_tips': result?['totaltips'],
        'total': result?['totalmoney'],
        'total_transactions': result?['transnum'],
        'supervisor': result?['supervisor_id'],
        'status': result?['status'],
        'station': config['station_code'] ?? '',
      });
      if (response.statusCode == 200) {
        print('Shift data sent successfully: ${response.body}');
        var dataresponse = jsonDecode(response.body);
        await dbHelper.updateIsPortalShift(result?['id'], "True");
        await dbHelper.updateShiftNum(
            result?['id'], int.parse(dataresponse['shift_num']));
      } else {
        print(
            'Failed to send shift data. Status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending shift data: $e');
    }
  }

  calculateTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();

    final dbHelper = DatabaseHelper();
    totalAmount.value =
        await dbHelper.getTotalAmount(prefs.getInt('shift_id') ?? 0);
    print("Total Amount: ${totalAmount.value}"); // Print the total amount
  }

  calculateTotalTipsAmount() async {
    final prefs = await SharedPreferences.getInstance();

    final dbHelper = DatabaseHelper();
    totalTipsAmount.value =
        await dbHelper.getTotalTipsAmount(prefs.getInt('shift_id') ?? 0);
    print("Total Amount: ${totalTipsAmount.value}"); // Print the total amount
  }

  calculateTipsplusTotalAmount() async {
    final prefs = await SharedPreferences.getInstance();

    final dbHelper = DatabaseHelper();
    totalTipsplusAmount.value =
        await dbHelper.getTotalTipsAndAmount(prefs.getInt('shift_id') ?? 0);
    print("Total Amount: ${totalAmount.value}"); // Print the total amount
  }

  printRowCount() async {
    final dbHelper = DatabaseHelper();
    TotalTransaction.value = await dbHelper.getRowCount();
  }

  sendShiftsToApi() async {
    try {
      // Fetch shift data
      var result = await dbHelper.getAllShiftsData();

      // Filter and prepare shifts for API
      var shiftsList = result
          .map((shift) => {
                'shift_num': shift['shift_num'],
                'start_date': shift['startshift'],
                'end_date': shift['endshift'],
                'total_amount': shift['totalamount'],
                'total_tips': shift['totaltips'],
                'total': shift['totalmoney'],
                'total_transactions': shift['transnum'],
                'supervisor': shift['supervisor_id'],
                'status': shift['status'],
                'station': config['station_code'],
              })
          .toList();

      if (shiftsList.isEmpty) {
        print("No shifts to send.");
        return;
      }

      print("Prepared shifts list: $shiftsList");

      // Send POST request
      const baseUrl = 'https://41.33.226.46/merchantpanal/pos/shifts/api/';
      final url = Uri.parse(baseUrl);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrftokenofapi,
          'Cookie': 'csrftoken=${csrftokenofapi}',
        },
        body: jsonEncode(shiftsList),
      );

      if (response.statusCode == 200) {
        print('Shift data sent successfully: ${response.body}');
        // Parse response and update local database
        for (var shift in shiftsList) {
          await dbHelper.updateIsPortalShift(
              int.parse(shift['shift_num']), "True");
        }
      } else {
        print(
            'Failed to send shift data. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error during sendShiftToApi: $e');
    }
  }

  Future<void> fetchLastShift() async {
    final dbHelper = DatabaseHelper();
    final result = await dbHelper.lastShift();
    print("result${result}");

    if (result != null) {
      lastShift.value = {
        'id': result['id'],
        'startshift': result['startshift'],
        'endshift': result['endshift'],
        'supervisor': result['supervisor'],
        'totalamount': result['totalamount'] ?? 0.0,
        'totalmoney': result['totalmoney'] ?? 0.0,
        'totaltips': result['totaltips'] ?? 0.0,
        'transnum': result['transnum'] ?? 0,
        'status': result['status'],
        'Isportal': result['Isportal'],
        'supervisor_id': result['supervisor_id'] ?? 0,
      };
    } else {
      lastShift.value = null;
    }
  }

  sendtoupdateistaxed() async {
    print('Token: $tokenofapi');
    const baseUrl =
        'https://41.33.226.46/merchantpanal/pos/transactions/update/istaxed/api/';
    // final url = Uri.parse('$baseUrl');
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // String? androidId = androidInfo.id;

    var taxRequestList = filteredTransactions
        .map((row) => int.parse(row['transactionSeqNo']))
        .toList();
    print("taxRequestList${taxRequestList}");
    print("list->>>>>${jsonEncode({'seq_nums': taxRequestList})}");

    // Prepare the list of taxRequestID

    try {
      final url = Uri.parse(baseUrl);

      // Send POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Attach CSRF cookie
        },
        body: jsonEncode({'seq_nums': taxRequestList}),
      );

      if (response.statusCode == 200) {
        print("sucess${response.body}");
        var responseData = jsonDecode(response.body);

        print("suc->>>>>>>>>>${responseData}");
        // print("responseDataresponseData${responseData['req_id']}");
        // print("responseDatares----------->>>${responseData['data']}");

        // int reqId = int.tryParse(response.body['req_id'].toString()) ?? 0;
        // dbHelper.updateIsuuidgenerate(responseData['req_id'], "True");
      } else {
        print("notsucess");
      }
    } catch (e) {
      print('Error during API request:sendtoupdateistaxed $e');
      print("Reading config from local storage...");
      // Read existing config in case of error
    }
  }

  // static const MethodChannel _channel = MethodChannel("com.example.pms/method");

  // bool isPrinting = false; // Prevent duplicate print jobs

  // void printReceipt() async {
  //   isPrinting = true;
  //   try {
  //     final result = await _channel.invokeMethod('printReceipt');

  //     print(result);
  //   } catch (e) {
  //     print('Error printing receipt: ${e.toString()}');
  //   } finally {
  //     isPrinting = false; // Reset the printing status
  //   }
  // }

  sendCloseShift() async {
    print("sendCloseShift");
    try {
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // String? androidId = androidInfo.id;
      // androidId_id = androidId;

      var last_shift = await dbHelper.lastShift();
      print("last_shift${last_shift}");
      print("androidId_id${SerialNumber.value}");

      // Send POST request
      const baseUrl =
          'https://41.33.226.46/merchantpanal/pos/shift/close/request/api/';
      final url = Uri.parse(baseUrl);

      var close_shift_req = {
        'shift_num': last_shift?['shift_num'],
        'android_id': SerialNumber.value
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrftokenofapi,
          'Cookie': 'csrftoken=${csrftokenofapi}',
        },
        body: jsonEncode(close_shift_req),
      );

      if (response.statusCode == 200) {
        print("closeshiftdata");
        print('clsoes shift sent successfully: ${response.body}');
        // dbHelper.updatestatusshift(last_shift?['id'], "closed",
        //     DateFormat("yyyy-MM-dd' 'HH:mm:ss").format(DateTime.now()));
        Get.toNamed('/CloseShift');

        // Parse response and update local database
      } else {
        print(
            'Failed to send shift data. Status code: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error during sendShiftToApi: $e');
    }
  }

  Future<String?> GetSerialNumber() async {
    String? response;
    try {
      const _channel = MethodChannel('com.example.pms/method');
      response = await _channel.invokeMethod<String>('getSerialNumber');

      SerialNumber.value = response ?? '';

      print("response${response}");
    } catch (e) {
      // Handle error
      print("Error retrieving serial number: $e");
      response = 'No response';
    }
    return response;
  }
}
