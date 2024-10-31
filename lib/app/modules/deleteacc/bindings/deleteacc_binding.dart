import 'package:get/get.dart';

import '../controllers/deleteacc_controller.dart';

class DeleteaccBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteaccController>(
      () => DeleteaccController(),
    );
  }
}
