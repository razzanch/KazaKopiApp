import 'package:get/get.dart';

import '../controllers/adminanalytics_controller.dart';

class AdminanalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminanalyticsController>(
      () => AdminanalyticsController(),
    );
  }
}
