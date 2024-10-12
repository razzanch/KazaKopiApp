import 'package:get/get.dart';

import '../controllers/detail_bubuk_controller.dart';

class DetailBubukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailBubukController>(
      () => DetailBubukController(),
    );
  }
}
