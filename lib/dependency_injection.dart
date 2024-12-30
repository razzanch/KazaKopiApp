import 'package:myapp/app/modules/connection/bindings/connection_binding.dart';
import 'package:myapp/app/modules/notification/bindings/notification_binding.dart';
import 'package:myapp/app/modules/notification/bindings/notificationadmin_binding.dart';

class DependencyInjection {
  static void init() {
    ConnectionBinding().dependencies();
    NotificationBinding().dependencies();
    NotificationadminBinding().dependencies();
  }
}
