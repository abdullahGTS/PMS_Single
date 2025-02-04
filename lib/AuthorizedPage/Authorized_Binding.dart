import 'package:get/get.dart';

import 'Authorized_Controller.dart';

class AuthorizedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthorizedController>(() => AuthorizedController());
  }
}
