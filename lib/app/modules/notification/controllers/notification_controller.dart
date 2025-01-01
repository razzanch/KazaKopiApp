import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  StreamSubscription<QuerySnapshot>? _orderSubscription;

  // Get current user UID
  String? get currentUserUid => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    print("NotificationController initialized.");
    _initializeNotifications();
    _setupFirebaseMessaging();
    _listenToOrderCollection();
  }

  @override
  void onClose() {
    super.onClose();
    print("NotificationController closed.");
    // Cancel the Firestore subscription if it exists
    _orderSubscription?.cancel();
  }

  Future<void> _initializeNotifications() async {
    print("Initializing local notifications...");
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification tapped: ${response.payload}");
        _handleNotificationTap(response);
      },
    );

    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    print("Requesting notification permissions...");
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      print("Android notification permissions granted: $granted");
    }

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print("Firebase Messaging permissions granted: ${settings.authorizationStatus}");
  }

  Future<void> _setupFirebaseMessaging() async {
    print("Setting up Firebase Messaging...");

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground FCM message received: ${message.data}");
      if (message.data['uid'] == currentUserUid) {
        _handleForegroundMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("FCM message opened app: ${message.data}");
      if (message.data['uid'] == currentUserUid) {
        _handleBackgroundMessage(message);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("FCM message on app start: ${message.data}");
        if (message.data['uid'] == currentUserUid) {
          _handleTerminatedMessage(message);
        }
      }
    });
  }

  void _listenToOrderCollection() {
    if (currentUserUid == null) {
      print("No logged-in user, Firestore listener not set.");
      return;
    }

    print("Listening to Firestore orders for UID: $currentUserUid");
    _orderSubscription = _firestore
        .collection('order')
        .where('uid', isEqualTo: currentUserUid)
        .snapshots()
        .listen((querySnapshot) {
      print("Order changes detected: ${querySnapshot.docChanges.length}");
      for (var change in querySnapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data();
          print("Firestore document modified: $data");

          if (data != null && data['status'] != null) {
            _showNotification(
              title: 'Order Update',
              body: 'Status Pesanan Terbaru: ${data['status']}',
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
    if (payload['uid'] != currentUserUid) {
      print("Notification ignored: Not for current user.");
      return;
    }

    print("Preparing to show notification: $title - $body");
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
      print("Notification shown successfully.");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  void _handleNotificationTap(NotificationResponse response) {
    print("Notification tapped, payload: ${response.payload}");
    if (response.payload != null) {
      // Navigate to appropriate screen based on payload
      // Example: Get.to(() => OrderDetailScreen(orderId: response.payload));
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print("Handling foreground FCM message...");
    _showNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print("Handling background FCM message...");
    _showNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }

  void _handleTerminatedMessage(RemoteMessage message) {
    print("Handling terminated state FCM message...");
    _showNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
}
