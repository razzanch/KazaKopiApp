import '../../home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/views/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  // Fungsi untuk registrasi pengguna
  Future<void> registerUser(String email, String password, String username, String phoneNumber) async {
    try {
      isLoading.value = true;

      // Proses registrasi dengan email dan password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Jika berhasil, simpan data pengguna ke Firestore
      await _saveUserDataToFirestore(username, phoneNumber, userCredential.user?.uid);

      // Tampilkan pesan sukses dan arahkan ke HomeView
      Get.snackbar('Success', 'Registration successful', backgroundColor: Colors.green);
      Get.off(HomeView());
    } catch (authError) {
      // Tampilkan pesan error jika registrasi di Firebase Authentication gagal
      Get.snackbar('Error', 'Registration failed: $authError', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk login pengguna
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Login successful', backgroundColor: Colors.green);
      Get.off(HomeView()); // Navigasi ke HomeView setelah login berhasil
    } catch (error) {
      Get.snackbar('Error', 'Login failed: $error', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk logout
  void logout() async {
    await _auth.signOut();
    Get.offAll(LoginView());
  }

  // Helper function untuk menyimpan data pengguna ke Firestore
  // Helper function untuk menyimpan data pengguna ke Firestore
Future<void> _saveUserDataToFirestore(String username, String phoneNumber, String? uid) async {
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'phoneNumber': phoneNumber,
        'email': _auth.currentUser?.email,
        'uid': uid,
      });
    }
}

}
