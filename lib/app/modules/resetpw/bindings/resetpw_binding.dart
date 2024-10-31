import 'package:get/get.dart';

import '../controllers/resetpw_controller.dart';

class ResetpwBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetpwController>(
      () => ResetpwController(),
    );
  }
}
