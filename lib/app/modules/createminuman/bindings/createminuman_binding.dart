import 'package:get/get.dart';

import '../controllers/createminuman_controller.dart';

class CreateminumanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateminumanController>(
      () => CreateminumanController(),
    );
  }
}
