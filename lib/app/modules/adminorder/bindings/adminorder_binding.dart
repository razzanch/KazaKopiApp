import 'package:get/get.dart';

import '../controllers/adminorder_controller.dart';

class AdminorderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminorderController>(
      () => AdminorderController(),
    );
  }
}
