import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Add Firebase Auth
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Get current user UID
  String? get currentUserUid => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
    _setupFirebaseMessaging();
    _listenToOrderCollection();
  }

  Future<void> _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response);
      },
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
            
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
    
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Check if the message is intended for the current user
      if (message.data['uid'] == currentUserUid) {
        _handleForegroundMessage(message);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.data['uid'] == currentUserUid) {
        _handleTerminatedMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['uid'] == currentUserUid) {
        _handleBackgroundMessage(message);
      }
    });
  }

  void _listenToOrderCollection() {
    // Only proceed if there's a logged-in user
    if (currentUserUid == null) return;

    _firestore.collection('order')
        .where('uid', isEqualTo: currentUserUid) // Filter by current user's UID
        .snapshots()
        .listen((querySnapshot) {
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data();
          if (data != null && data['status'] != null) {
            _showNotification(
              title: 'Order Update',
              body: 'Status Pesanan Terbaru! : ${data['status']}',
              payload: {
                'orderId': change.doc.id,
                'status': data['status'],
                'uid': data['uid'],
              },
            );
          }
        }
      }
    });
  }

  Future<void> _showNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    // Double-check that the notification is for the current user
    if (payload['uid'] != currentUserUid) return;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        platformChannelSpecifics,
        payload: payload.toString(),
      );
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  void _handleNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      // Navigate to appropriate screen based on payload
      // Get.to(() => OrderDetailScreen(orderId: response.payload));
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _showNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      _showNotification(
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        payload: message.data,
      );
    }
  }

  void _handleTerminatedMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      _showNotification(
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        payload: message.data,
      );
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
}