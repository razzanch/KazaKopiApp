import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Tambahkan SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and Title
              Center(
                child: Column(
                  children: [
                    // Logo
                    Image.asset('assets/LOGO.png',
                        height: 100), // Ensure the correct logo path
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

                    // Subtitle for Sign In
                    Text(
                      "Welcome Back! Please sign in.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // Username TextField
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter your username',
                ),
              ),
              SizedBox(height: 20),

              // Phone Number TextField
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Enter your phone number',
                ),
              ),
              SizedBox(height: 20),

              // Email TextField
              TextField(
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

              // Sign-In Button
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.HOME);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800], // Button color
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
