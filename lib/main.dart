import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pms/Report/Report_Binding.dart';
import 'package:pms/ReportShifts/ReportShift_Binding.dart';

import 'AuthorizedPage/AuthorizedPage.dart';
import 'AuthorizedPage/Authorized_Binding.dart';
import 'AvailableTrxDetails/AvailableTrxDetails.dart';
import 'AvailableTrxDetails/AvailableTrxDetails_Binding.dart';
import 'ChoosePayment/ChoosePayment.dart';
import 'ChoosePayment/ChoosePayment_Binding.dart';
import 'CloseRequest/CloseRequestPage.dart';
import 'CloseRequest/CloseRequest_Binding.dart';
import 'CloseRequest/CloseRequest_MiddleWare.dart';
import 'CustomAppbar/CustomAppbar_Controller.dart';
import 'Fueling/Fueling.dart';
import 'Fueling/Fueling_Binding.dart';
import 'Home/Home.dart';
import 'Home/Home_Binding.dart';
import 'Maiarshift/Maiar_Binding.dart';
import 'Maiarshift/Maiar_Page.dart';
import 'Nozzles/Nozzles_Binding.dart';
import 'Nozzles/Nozzles_Page.dart';
import 'PresetValue/PresetValue_Binding.dart';
import 'PresetValue/PresetValue_Page.dart';
import 'Pumps/Pumps_Binding.dart';
import 'Pumps/Pumps_Page.dart';
import 'Receipt/Receipt.dart';
import 'Receipt/Receipt_Binding.dart';

import 'Report/Report.dart';
import 'ReportShifts/ReportShift.dart';
import 'ResetPayment/ResetPayment.dart';
import 'ResetPayment/ResetPayment_Binding.dart';
import 'Setting/Setting.dart';
import 'Setting/Setting_Binding.dart';
import 'Shared/password_Controller.dart';
import 'Shifts/Shift_Binding.dart';
import 'Shifts/Shift_Page.dart';
import 'SuperVisourCloseShift/VerifyCloseShift_Binding.dart';
import 'SuperVisourCloseShift/VerifyCloseShift_Page.dart';
import 'SuperVisourSetlemment/VerifySetlemment_Binding.dart';
import 'SuperVisourSetlemment/VerifySetlemment_Page.dart';
import 'Syncing/SyncingPage.dart';
import 'Syncing/Syncing_Binding.dart';
import 'Syncing/Syncing_MiddleWare.dart';
import 'Tips/Tips.dart';
import 'Tips/Tips_Binding.dart';
import 'AvailableTransactions/AvailableTransactions.dart';
import 'AvailableTransactions/AvailableTransactions_Binding.dart';
import 'Transactions/Transactions.dart';
import 'Transactions/Transactions_Binding.dart';
import 'Local/Local.dart';
import 'VerifyAttendent/Verify_Binding.dart';
import 'VerifyAttendent/Verify_Page.dart';
import 'VerifyAvailableTrx/VerifyAvailableTrx_Binding.dart';
import 'VerifyAvailableTrx/VerifyAvailableTrx_Page.dart';
import 'my_http_overrides.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background/flutter_background.dart';

SharedPreferences? prefs;
final customappbar = Get.put(CustomAppbarController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  Get.put(PasswordController());
  HttpOverrides.global = MyHttpOverrides(); // Bypass SSL
  Get.put(CustomAppbarController());
  // initBackgroundService();
  runApp(const MyApp());
}

// Future<void> initBackgroundService() async {
//   bool success = await FlutterBackground.initialize();
//   if (success) {
//     FlutterBackground.enableBackgroundExecution();
//     runBackgroundTask();
//   }
// }

// void runBackgroundTask() {
//   Future.delayed(Duration(seconds: 10), () {
//     // Add the task you want to run in the background
//     customappbar.startConnection();
//     print("Background task is running!");
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: const Locale('en', 'US'), // default locale
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'PMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => SyncingPage(),
          binding: SyncingBinding(),
          middlewares: [
            SyncingMiddleware(),
          ],
        ),
        // GetPage(
        //     name: '/Setting',
        //     page: () => SettingPage(),
        //     binding: SettingBinding()),
        GetPage(
            name: '/Shift', page: () => ShiftPage(), binding: ShiftBinding()),
        GetPage(
          name: '/CloseShift',
          page: () => CloseRequestPage(),
          binding: CloseRequestBinding(),
          // middlewares: [
          //   CloseRequestMiddleware(),
          // ],
        ),
        GetPage(
            name: '/Mair', page: () => MaiarPage(), binding: MaiarBinding()),
        GetPage(
            name: '/VerifyCloseShift',
            page: () => VerifycloseshiftPage(),
            binding: VerifycloseshiftBinding()),
        GetPage(
            name: '/VerifySetlemment',
            page: () => VerifySetlemmentPage(),
            binding: VerifySetlemmentBinding()),
        GetPage(name: '/Home', page: () => HomePage(), binding: HomeBinding()),
        GetPage(
            name: '/verify',
            page: () => VerifyPage(),
            binding: VerifyBinding()),
        GetPage(
            name: "/Pumps", page: () => PumpsPage(), binding: PumpsBinding()),
        GetPage(
            name: "/Nozzles",
            page: () => NozzelsPage(),
            binding: NozzlesBinding()),
        GetPage(
            name: "/PresetValue",
            page: () => PresetvaluePage(),
            binding: PresetvalueBinding()),
        // GetPage(
        //     name: "/Authorize",
        //     page: () => Authorized(),
        //     binding: AuthorizedBinding()),
        GetPage(
            name: "/Fueling",
            page: () => FuelingPage(),
            binding: FuelingBinding()),
        GetPage(
            name: "/authorizedpage",
            page: () => Authorizedpage(),
            binding: AuthorizedBinding()),
        GetPage(
            name: "/ChoosePayment",
            page: () => ChoosePayment(),
            binding: ChoosePaymentBinding()),

        GetPage(
            name: "/Availabletrxdetails",
            page: () => Availabletrxdetails(),
            binding: AvailabletrxdetailsBinding()),
        GetPage(
          name: '/Receipt',
          page: () => Receipt(),
          binding: ReceiptBinding(),
        ),
        GetPage(
          name: '/Tips',
          page: () => Tips(),
          binding: TipsBinding(),
        ),
        GetPage(
          name: '/Transactions',
          page: () => Transactions(),
          binding: TransactionsBinding(),
        ),
        GetPage(
            name: "/Verifyavailabletrx",
            page: () => VerifyavailabletrxPage(),
            binding: VerifyavailabletrxBinding()),
        GetPage(
          name: '/Availabletransactions',
          page: () => Availabletransactions(),
          binding: AvailabletransactionsBinding(),
        ),
        GetPage(
            name: "/ResetPayment",
            page: () => ResetPayment(),
            binding: ResetPaymentBinding()),
        GetPage(
            name: "/Report", page: () => Report(), binding: ReportBinding()),
        GetPage(
            name: "/ReportShift",
            page: () => Reportshift(),
            binding: ReportshiftBinding()),
        // GetPage(
        //   name: '/Resetpage',
        //   page: () => Resetpage(
        //     pumpNo: Get.arguments['pumpNo'],
        //     nozzleNo: Get.arguments['nozzleNo'],
        //     transactionSeqNo: Get.arguments['transactionSeqNo'],
        //     amountVal: Get.arguments['amountVal'],
        //     volume: Get.arguments['volume'],
        //     unitPrice: Get.arguments['unitPrice'],
        //     volumeProduct1: Get.arguments['volumeProduct1'],
        //     volumeProduct2: Get.arguments['volumeProduct2'],
        //     productNo1: Get.arguments['productNo1'],
        //     blendRatio: Get.arguments['blendRatio'],
        //     selectedPaymentOption: Get.arguments['selectedPaymentOption'],
        //     productName: Get.arguments['productName'],
        //   ),
        //   // binding: ResetBinding(),
        // ),
        // GetPage(name: "/Tips", page: () => TipsPage(), binding: TipsBinding()),
        // GetPage(
        //     name: "/TipsAfterVoid",
        //     page: () => TipsPageAfterVoid(),
        //     binding: TipsBindingAfterVoid()),
        // GetPage(
        //     name: "/Alltrans",
        //     page: () => AllTransactionPage(),
        //     binding: AllTransactyionBinding()),
      ],
    );
  }
}
