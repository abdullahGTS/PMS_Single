import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/main.dart';

class CloseRequestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // bool? closeStatus = prefs?.getBool('closeStatus');
    // print("closeStatus${closeStatus}");
    // // print(user);
    // if (closeStatus == null) {
    //   return null;
    // }
    // if (closeStatus == true) {
    //   return const RouteSettings(name: '/Shift');
    // }
    // if (closeStatus == false) {
    //   return const RouteSettings(name: '/CloseShift');
    // }
    // return null;
  }
}
