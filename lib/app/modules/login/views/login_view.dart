import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  LoginView() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'login_channel',
      'Login Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Login Berhasil', 'Selamat datang kembali di Kaza Kopi Nusantara!', platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Center(
              child: Column(
                children: [
                  Image.asset('assets/LOGO.png', height: 100),
                  SizedBox(height: 30),
                  // App Name
                  Text(
                    "Kaza Kopi Nusantara",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Login Text
                  Text(
                    "Login to your account",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // Email TextField
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 20),

            // Password TextField
            TextField(
              controller: controller.passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                hintText: 'Enter your password',
              ),
            ),

            SizedBox(height: 20),

            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Tambahkan logika untuk mengatur ulang password
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Login Button
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null // Disable button saat loading
                  : () async {
                      String email = controller.emailController.text;
                      String password = controller.passwordController.text;

                      // Panggil fungsi login dari controller
                      await controller.loginUser(email, password);
                      if (controller.isLoading.value == false) {
                        await showNotification(); // Tampilkan notifikasi setelah login berhasil
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800], // Button color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: controller.isLoading.value
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            )),

            SizedBox(height: 20),

            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.SIGNUP);
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}