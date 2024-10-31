import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignUpController> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  SignupView() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'signup_channel',
      'Signup Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Sign Up Berhasil', 'Selamat datang di Kaza Kopi Nusantara!', platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/LOGO.png', height: 100),
                    SizedBox(height: 30),
                    Text(
                      "Kaza Kopi Nusantara",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 10),
                    Text("Welcome! Please sign Up.", style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                  ],
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter your username',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Enter your phone number',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 20),
              Obx(() {
                return ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty &&
                              usernameController.text.isNotEmpty &&
                              phoneController.text.isNotEmpty) {
                            try {
                              await controller.registerUser(
                                emailController.text,
                                passwordController.text,
                                usernameController.text,
                                phoneController.text,
                              );
                              await showNotification();
                              Get.toNamed(Routes.LOGIN);
                            } catch (error) {
                              Get.snackbar(
                                'Error',
                                'Sign Up failed: $error',
                                backgroundColor: Colors.red,
                              );
                            }
                          } else {
                            Get.snackbar(
                              'Error',
                              'Semua kolom harus diisi',
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                );
              }),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}