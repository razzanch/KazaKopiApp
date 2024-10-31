import 'package:get/get.dart';

import '../controllers/ourig_controller.dart';

class OurigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OurigController>(
      () => OurigController(),
    );
  }
}
