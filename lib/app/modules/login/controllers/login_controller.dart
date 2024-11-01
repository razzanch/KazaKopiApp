import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/app/modules/login/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/views/home_view.dart';
import '../../adminhome/views/adminhome_view.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  Future<bool> loginUser(String email, String password) async {
    try {
      isLoading.value = true;

      // Attempt login with Firebase
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save login status and email in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'your_token_value');
      await prefs.setString('email', email); // Menyimpan email pengguna

      // Show success message
      Get.snackbar('Success', 'Login successful', backgroundColor: Colors.green);

      // Check if the email is admin
      if (email == 'admin123@gmail.com') {
        Get.offAll(() => AdminhomeView()); // Navigate to AdminhomeView for admin
      } else {
        Get.offAll(() => HomeView()); // Navigate to HomeView for regular users
      }

      return true;
    } catch (error) {
      Get.snackbar('Error', 'Login failed: $error', backgroundColor: Colors.red);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk logout
  void logout() async {
    await _auth.signOut();

    // Remove token and email from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email'); // Hapus email saat logout

    // Redirect to login page
    Get.offAll(() => LoginView());
  }
}
