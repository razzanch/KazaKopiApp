import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

   void _pickImage(BuildContext context) {
    _showImageSourceDialog(context);
  }

  void _showImageSourceDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.photo_library, color: Colors.teal, size: 40),
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        controller.pickImage(ImageSource.gallery); // Open Gallery
                      },
                    ),
                    Text('Gallery', style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.teal, size: 40),
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        controller.pickImage(ImageSource.camera); // Open Camera
                      },
                    ),
                    Text('Camera', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}


  void _updateProfile() {
  // Regex untuk validasi username dan nomor telepon
  final usernamePattern = RegExp(r'^[a-zA-Z0-9]+$'); // Hanya huruf dan angka
  final phoneNumberPattern = RegExp(r'^\d+$'); // Hanya angka

  // Validasi input username
  if (controller.nameController.text.isEmpty ||
      !usernamePattern.hasMatch(controller.nameController.text)) {
    Get.snackbar(
      'Error',
      'Username must only contain letters and numbers and cannot be empty',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  // Validasi input nomor telepon
  if (controller.phoneNumberController.text.isEmpty ||
      !phoneNumberPattern.hasMatch(controller.phoneNumberController.text)) {
    Get.snackbar(
      'Error',
      'Phone number must only contain numbers and cannot be empty',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  // Jika semua validasi lolos, lanjutkan dengan update profil
  controller.updateProfile();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.teal,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.toNamed(Routes.MAINPROFILE);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Obx(() {
  final imagePath = controller.selectedImagePath.value;

  return CircleAvatar(
    radius: 60,
    backgroundImage: imagePath.startsWith('http')
        ? NetworkImage(imagePath)
        : (File(imagePath).existsSync()
            ? FileImage(File(imagePath))
            : AssetImage('assets/pp5.jpg')) as ImageProvider,
    onBackgroundImageError: (_, __) {
      // Jika gambar gagal, gunakan fallback
      controller.selectedImagePath.value = 'assets/pp5.jpg';
    },
  );
}),

                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => _pickImage(context),
                        child: Text(
                          'Choose Profile Picture',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username TextField
                      TextField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Phone Number TextField
                      TextField(
                        controller: controller.phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _updateProfile,
                            child: Text(
                              'Update Profile',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  '*Note: After updating your profile information, the old account information will be lost.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


