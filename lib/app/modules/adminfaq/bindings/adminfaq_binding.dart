import 'package:get/get.dart';

import '../controllers/adminfaq_controller.dart';

class AdminfaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminfaqController>(
      () => AdminfaqController(),
    );
  }
}
