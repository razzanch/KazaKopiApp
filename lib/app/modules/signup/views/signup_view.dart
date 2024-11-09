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

  void clearFields() {
    usernameController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background image TIRAIBG
            Image.asset(
              'assets/TIRAIBG.png',
              width: MediaQuery.of(context).size.width,
              height: 270,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Row for Logo and Text
                  Transform.translate(
                    offset: Offset(0, -200), // Adjust the y value to move the logo and text upwards
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/LOGO.png', height: 80),
                        SizedBox(width: 10),
                        Text(
                          "Kaza Kopi Nusantara",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -110), // Adjust the y value to move all elements upwards
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Welcome! Please sign Up.",
                          style: TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 40),
                        // Username TextField
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            hintText: 'Enter your username',
                          ),
                        ),
                        SizedBox(height: 20),
                        // Phone Number TextField
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                            hintText: 'Enter your phone number',
                          ),
                        ),
                        SizedBox(height: 20),
                        // Email TextField
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Enter your email',
                          ),
                        ),
                        SizedBox(height: 20),
                        // Password TextField
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
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
                        // Text below button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () {
                                clearFields(); // Clear all TextFields
                                Get.toNamed(Routes.LOGIN); // Navigate to LOGIN route
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                   // Divider above the footer
                  Divider(color: Colors.grey[600]), // Divider added here
                  
                  // Footer
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Kaza Kopi Nusantara 2024 ©", // Add your copyright logo here
                      style: TextStyle(
                        color: Colors.grey[600], // Gray color for the footer text
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}