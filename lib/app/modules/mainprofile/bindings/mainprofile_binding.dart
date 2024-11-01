import 'package:get/get.dart';
import 'package:myapp/app/modules/mainprofile/controllers/mainprofile_controller.dart';

class MainProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainProfileController>(() => MainProfileController());
  }
}
