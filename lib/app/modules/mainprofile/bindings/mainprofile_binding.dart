import 'package:get/get.dart';

import '../controllers/mainprofile_controller.dart';

class MainprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainprofileController>(
      () => MainprofileController(),
    );
  }
}
