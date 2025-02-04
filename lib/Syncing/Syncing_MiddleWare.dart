import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/main.dart';

class SyncingMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    bool? getConfig = prefs?.getBool('getConfig');
    print("getConfig${getConfig}");
    // print(user);
    if (getConfig == null) {
      return null;
    }
    if (getConfig == true) {
      return const RouteSettings(name: '/Shift');
    }
    if (getConfig == false) {
      return const RouteSettings(name: '/');
    }
    return null;
  }
}
