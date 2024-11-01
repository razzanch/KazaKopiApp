import 'package:get/get.dart';

import '../controllers/createbubuk_controller.dart';

class CreatebubukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatebubukController>(
      () => CreatebubukController(),
    );
  }
}
