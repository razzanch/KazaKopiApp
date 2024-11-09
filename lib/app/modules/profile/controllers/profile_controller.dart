import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  // Define RxString for selected image path
  final Rx<String> selectedImagePath = "assets/pp5.jpg".obs;

  // Define the list of available images
  final List<String> availableImages = [
    "assets/pp1.jpg",
    "assets/pp2.jpg",
    "assets/pp3.jpg",
    "assets/pp4.jpg",
    "assets/pp6.jpg",
    // Add more asset paths as needed
  ];

  // Define the method to update selected image
  void updateSelectedImage(String imagePath) {
    selectedImagePath.value = imagePath;
  }

  // Function to load initial data if needed
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Function to load user data
  void loadUserData() async {
    String uid = _auth.currentUser?.uid ?? '';
    try {
      var userData = await _firestore.collection('users').doc(uid).get();
      if (userData.exists) {
        var data = userData.data();
        nameController.text = data?['username'] ?? '';
        phoneNumberController.text = data?['phoneNumber'] ?? '';
        selectedImagePath.value = data?['urlImage'] ?? 'assets/pp5.jpg';
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Updated updateProfile function
  void updateProfile() async {
    String uid = _auth.currentUser?.uid ?? '';

    try {
      await _firestore.collection('users').doc(uid).update({
        'username': nameController.text,
        'phoneNumber': phoneNumberController.text,
        'urlImage': selectedImagePath.value,
        'lastUpdate': FieldValue.serverTimestamp(),
      });
      Get.snackbar("Success", "Profile updated successfully");
      Get.offAllNamed('/mainprofile');
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
      print('Error updating profile: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }
}
