import 'package:get/get.dart';
import 'package:myapp/app/modules/notification/controllers/notificationadmin_controller.dart';

class NotificationadminBinding extends Bindings {
  @override
  void dependencies() {
Get.put<NotificationadminController>(NotificationadminController(),permanent: true
);
}
}
