import 'package:get/get.dart';

import '../controllers/myanalitics_controller.dart';

class MyanaliticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyanaliticsController>(
      () => MyanaliticsController(),
    );
  }
}
