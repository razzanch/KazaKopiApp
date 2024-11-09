import 'package:get/get.dart';

import '../../../data/services/getconnect_controller.dart';

class GetconnectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetConnectController>(
      () => GetConnectController(),
    );
  }
}
