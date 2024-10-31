import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Pastikan untuk mengimpor FirebaseAuth
import '../../home/views/home_view.dart'; // Sesuaikan dengan jalur yang benar untuk HomeView

class LoginController extends GetxController {
  // Controllers for email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Observable loading state
  RxBool isLoading = false.obs; // Inisialisasi variabel isLoading

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

  // Fungsi untuk login pengguna
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true; // Set isLoading ke true
      final FirebaseAuth _auth = FirebaseAuth.instance; // Inisialisasi FirebaseAuth

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Tampilkan pesan sukses
      Get.snackbar('Success', 'Login successful', backgroundColor: Colors.green);

      Get.off(HomeView()); // Navigasi ke HomeView setelah login berhasil
    } catch (error) {
      Get.snackbar('Error', 'Login failed: $error', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false; // Set isLoading ke false setelah proses login selesai
    }
  }
}