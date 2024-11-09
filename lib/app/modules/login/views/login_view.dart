import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/app/modules/home/views/home_view.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  final LoginController controller =
      Get.put(LoginController(), permanent: true);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LoginView() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'login_channel',
      'Login Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Login Berhasil',
        'Selamat datang kembali di Kaza Kopi Nusantara!',
        platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Make the entire body scrollable
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
                children: [
                  Center(
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: Offset(0,
                              -200), // Adjust the x and y values here for logo and text
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
                        SizedBox(height: 0), // SizedBox below the row
                        // Wrap the following elements with Transform.translate to move them down
                        Transform.translate(
                          offset: Offset(0,
                              -80), // Adjust the y value to move all elements below the logo
                          child: Column(
                            children: [
                              Text(
                                "Login to your account",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  border:
                                      InputBorder.none, // No border by default
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Gray underline when focused
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Gray underline when enabled
                                  ),
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
                                  border:
                                      InputBorder.none, // No border by default
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Gray underline when focused
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .grey), // Gray underline when enabled
                                  ),
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: 'Enter your password',
                                ),
                              ),
                              SizedBox(height: 0),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // Align items at both ends
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                         Get.offAll(() => HomeView()); // Tambahkan logika untuk mengatur ulang password
                                      },
                                      child: Text(
                                        'As a guest',
                                        style: TextStyle(
                                          color: Colors.grey[800], // Changed to teal
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(Routes
                                            .FORGOTPW); // Tambahkan logika untuk mengatur ulang password
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Colors.teal, // Changed to teal
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Obx(() => ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () async {
                                            String email = emailController.text;
                                            String password =
                                                passwordController.text;

                                            bool success = await controller
                                                .loginUser(email, password);
                                            if (success) {
                                              await showNotification(); // Tampilkan notifikasi hanya jika login berhasil
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[800],
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 15),
                                    ),
                                    child: controller.isLoading.value
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                  )),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: Colors.black, // Changed to teal
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      emailController.clear();
                                      passwordController.clear();
                                      Get.toNamed(
                                          '/signup'); // Adjust route if needed
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer to push the footer to the bottom

                  // Divider above the footer
                  Divider(color: Colors.grey[600]), // Divider added here

                  // Footer
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Kaza Kopi Nusantara 2024 ©", // Add your copyright logo here
                      style: TextStyle(
                        color:
                            Colors.grey[600], // Gray color for the footer text
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
