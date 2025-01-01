import 'package:get/get.dart';
import 'package:myapp/app/modules/notification/controllers/unified_notification_controller.dart';


class UnifiedNotificationBinding extends Bindings {
  @override
  void dependencies() {
Get.put<UnifiedNotificationController>(UnifiedNotificationController(),permanent: true
);
}
}
