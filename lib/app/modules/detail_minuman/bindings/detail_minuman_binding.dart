import 'package:get/get.dart';

import '../controllers/detail_minuman_controller.dart';

class DetailMinumanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailMinumanController>(
      () => DetailMinumanController(),
    );
  }
}
