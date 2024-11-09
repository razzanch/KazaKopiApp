import 'package:get/get.dart';

import '../controllers/ourlocation_controller.dart';

class OurlocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OurlocationController>(
      () => OurlocationController(),
    );
  }
}
