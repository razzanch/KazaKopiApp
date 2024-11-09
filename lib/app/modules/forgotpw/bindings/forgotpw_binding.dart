import 'package:get/get.dart';

import '../controllers/forgotpw_controller.dart';

class ForgotpwBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotpwController>(
      () => ForgotpwController(),
    );
  }
}
