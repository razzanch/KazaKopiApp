import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class detailbubukbinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
