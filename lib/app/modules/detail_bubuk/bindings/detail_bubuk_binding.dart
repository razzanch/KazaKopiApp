import 'package:get/get.dart';
import '../controllers/detail_bubuk_controller.dart';

class detailbubukbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<detail_bubuk_controller>(
      () => detail_bubuk_controller(),
    );
  }
}
