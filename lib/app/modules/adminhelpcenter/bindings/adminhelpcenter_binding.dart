import 'package:get/get.dart';

import '../controllers/adminhelpcenter_controller.dart';

class AdminhelpcenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminhelpcenterController>(
      () => AdminhelpcenterController(),
    );
  }
}
