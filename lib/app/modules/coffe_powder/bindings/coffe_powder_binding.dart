import 'package:get/get.dart';

import '../controllers/coffe_powder_controller.dart';

class CoffePowderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoffePowderController>(
      () => CoffePowderController(),
    );
  }
}
