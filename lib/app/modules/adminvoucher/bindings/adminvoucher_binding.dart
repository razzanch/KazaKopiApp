import 'package:get/get.dart';

import '../controllers/adminvoucher_controller.dart';

class AdminvoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminvoucherController>(
      () => AdminvoucherController(),
    );
  }
}
