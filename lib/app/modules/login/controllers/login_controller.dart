import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  // Controllers for email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observable count variable (you can keep or remove this if not needed)
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose the controllers when the controller is closed to free up resources
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
