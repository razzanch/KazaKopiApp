import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();

  // UID RxString
  final Rx<String> uid = ''.obs;

  // Define RxString for selected image path
  final Rx<String> selectedImagePath = "assets/razzan.jpg".obs;

  // Define the list of available images
  final List<String> availableImages = [
    "assets/razzan.jpg",
    "assets/M4.png",
    "assets/pp1.jpg",
    "assets/pp2.jpg",
    "assets/pp3.jpg",
    "assets/pp4.jpg",
    "assets/pp5.jpg",
    "assets/pp6.jpg",
    "assets/pp7.jpg",
    "assets/pp8.jpg",
    "assets/pp9.jpg",
    "assets/pp10.jpg",
    "assets/pp11.jpg",
    "assets/pp12.jpg",
  ];

  // Define the method to update selected image
  void updateSelectedImage(String imagePath) {
    selectedImagePath.value = imagePath;
  }

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Function to load user data
  void loadUserData() async {
    String userUid = _auth.currentUser?.uid ?? '';
    uid.value = userUid;
    try {
      var userData = await _firestore.collection('users').doc(userUid).get();
      if (userData.exists) {
        var data = userData.data();
        nameController.text = data?['name'] ?? '';
        phoneNumberController.text = data?['phoneNumber'] ?? '';
        emailController.text = data?['email'] ?? '';
        instagramController.text = data?['instagram'] ?? '';

        selectedImagePath.value = data?['urlImage'] ?? 'assets/razzan.jpg';
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Updated updateProfile function
  void updateProfile() async {
    String userUid = _auth.currentUser?.uid ?? '';

    try {
      await _firestore.collection('users').doc(userUid).update({
        'name': nameController.text,
        'phoneNumber': phoneNumberController.text,
        'urlImage': selectedImagePath.value,
        'instagram': instagramController.text,
        'lastUpdate': FieldValue.serverTimestamp(),
      });
      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
      print('Error updating profile: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    instagramController.dispose();

    super.onClose();
  }
}
