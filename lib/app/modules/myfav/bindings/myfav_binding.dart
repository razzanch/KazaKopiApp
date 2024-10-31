import 'package:get/get.dart';

import '../controllers/myfav_controller.dart';

class MyfavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyfavController>(
      () => MyfavController(),
    );
  }
}
