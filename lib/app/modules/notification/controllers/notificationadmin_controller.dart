import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationadminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // UID Admin yang harus menerima notifikasi
  final String specialUid = 'Idx7Tiy4kwOXob9ZgltbnWhWnu43';

  @override
  void onInit() {
    super.onInit();
    print("Initializing NotificationadminController...");
    _initializeNotifications();
    _setupFirebaseMessaging();
    _listenToOrderCollection();
  }

  @override
  void onClose() {
    print("Closing NotificationadminController...");
    super.onClose();
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
        _handleNotificationTap(response);
      },
    );

    print("Local notifications initialized.");
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    print("Requesting notification permissions...");
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted =
          await androidImplementation.requestNotificationsPermission();
      print("Android notification permissions granted: $granted");
    }

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Notification permissions granted: ${settings.authorizationStatus}");
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print("User denied notification permissions.");
    }
  }

  Future<void> _setupFirebaseMessaging() async {
    print("Setting up Firebase Messaging...");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.data}");
      _handleForegroundMessage(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("Initial message received: ${message.data}");
        _handleTerminatedMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("Message opened from background: ${message.data}");
      _handleBackgroundMessage(message);
    });

    print("Firebase Messaging setup complete.");
  }

  void _listenToOrderCollection() {
    print("Listening to 'order' collection...");

    if (_auth.currentUser?.uid != specialUid) {
      print(
          "Current user UID (${_auth.currentUser?.uid}) does not match special UID. Listener not started.");
      return;
    }

    _firestore.collection('order').snapshots().listen((querySnapshot) {
      print(
          "Order collection snapshot received with ${querySnapshot.docs.length} documents.");
      for (var change in querySnapshot.docChanges) {
        print("Change detected: ${change.doc.data()}");
        if (change.type == DocumentChangeType.added) {
          print("New order added: ${change.doc.data()}");
          final data = change.doc.data();
          if (data != null) {
            print("Preparing notification for data: $data");
            _showNotification(
              title: 'New Order Received!',
              body:
                  '${data['username']} placed a new order. Check it now!',
              payload: {
                'orderId': change.doc.id,
                'status': data['status'] ?? 'No status',
                'uid': data['uid'] ?? 'No UID',
              },
            );
          } else {
            print("Document data is null or invalid.");
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
    print("Showing notification: $title - $body");

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
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        platformChannelSpecifics,
        payload: payload.toString(),
      );
      print("Notification displayed successfully.");
    } catch (e) {
      print("Error displaying notification: $e");
    }
  }

  void _handleNotificationTap(NotificationResponse response) {
    print("Notification tapped with payload: ${response.payload}");
    // Tambahkan navigasi atau tindakan lain jika diperlukan
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print("Handling foreground message...");
    _showNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print("Handling background message...");
    _showNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      payload: message.data,
    );
  }

  void _handleTerminatedMessage(RemoteMessage message) {
    print("Handling terminated message...");
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
