import 'package:get/get.dart';

import '../controllers/adminhistory_controller.dart';

class AdminhistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminhistoryController>(
      () => AdminhistoryController(),
    );
  }
}
