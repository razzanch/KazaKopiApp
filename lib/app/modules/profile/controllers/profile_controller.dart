import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  // Default profile picture
  final Rx<String> selectedImagePath = "assets/pp5.jpg".obs;

  // Store selected file for uploading
  File? selectedImageFile;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

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

  void pickImage(ImageSource source) async {
  try {
    final picker = ImagePicker();

    // Ambil gambar dari sumber yang dipilih (Gallery atau Camera)
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      selectedImageFile = File(pickedFile.path); // Update selected image file
      selectedImagePath.value = selectedImageFile!.path; // Update preview
    } else {
      Get.snackbar('Error', 'No image selected');
    }
  } catch (e) {
    print('Error picking image: $e');
    Get.snackbar('Error', 'Failed to pick an image');
  }
}


  Future<String?> uploadProfilePicture(File imageFile) async {
    final String uid = _auth.currentUser?.uid ?? '';

    try {
      final supabase = Supabase.instance.client;

      // Buka file dan baca isinya
      final fileBytes = await imageFile.readAsBytes();

      // Nama file baru yang unik untuk pengguna
      final String newFileName = '$uid-${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Ambil daftar file di folder profile_pictures
      final existingFiles = await supabase.storage.from('profile_pictures').list(path: '');

      // Cari dan hapus file lama berdasarkan UID
      for (var file in existingFiles) {
        if (file.name.startsWith('$uid-')) {
          print("File to be deleted: ${file.name}");

          try {
            // Hapus file lama
            await supabase.storage.from('profile_pictures').remove([file.name]);
            print("Deleted file: ${file.name}");
          } catch (e) {
            print("Error deleting file: $e");
            throw Exception("Failed to delete file: $e");
          }
        }
      }

      // Upload file baru ke bucket Supabase
      final response = await supabase.storage.from('profile_pictures').uploadBinary(newFileName, fileBytes);
      print("Upload success: $response");

      // Generate URL publik untuk file yang diunggah
      final publicUrl = supabase.storage.from('profile_pictures').getPublicUrl(newFileName);
      print("Public URL: $publicUrl");

      return publicUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      Get.snackbar('Error', 'Failed to upload profile picture');
      return null;
    }
  }

  void updateProfile() async {
    String uid = _auth.currentUser?.uid ?? '';

    try {
      // Upload new profile picture if selected
      String? imageUrl;
      if (selectedImageFile != null) {
        imageUrl = await uploadProfilePicture(selectedImageFile!);
        if (imageUrl == null) throw Exception("Image upload failed");
      }

      await _firestore.collection('users').doc(uid).update({
        'username': nameController.text,
        'phoneNumber': phoneNumberController.text,
        'urlImage': imageUrl ?? selectedImagePath.value,
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
    super.onClose();
  }
}
