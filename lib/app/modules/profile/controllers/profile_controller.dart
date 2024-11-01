import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Contoh TextEditingController untuk form input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();

  // Fungsi untuk mengupdate profil pengguna
  void updateProfile() async {
    String uid = _auth.currentUser?.uid ?? '';

    try {
      await _firestore.collection('users').doc(uid).update({
        'name': nameController.text,
        'phoneNumber': phoneNumberController.text,
        'email': emailController.text,
        'instagram': instagramController.text,
        'lastUpdate': FieldValue.serverTimestamp(),
      });
      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
    }
  }

  @override
  void onClose() {
    // Pastikan untuk membersihkan controller saat tidak digunakan
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    instagramController.dispose();
    super.onClose();
  }
}
