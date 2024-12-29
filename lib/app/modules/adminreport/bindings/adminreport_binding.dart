import 'package:get/get.dart';

import '../controllers/adminreport_controller.dart';

class AdminreportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminreportController>(
      () => AdminreportController(),
    );
  }
}
