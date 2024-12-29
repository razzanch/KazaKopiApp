import 'package:get/get.dart';

import '../controllers/adminlistvc_controller.dart';

class AdminlistvcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminlistvcController>(
      () => AdminlistvcController(),
    );
  }
}
