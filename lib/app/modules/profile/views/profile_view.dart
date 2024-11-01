import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Get the ProfileController
  final ProfileController profileController = Get.put(ProfileController());

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _updateProfile() {
    // Check if all TextFields are filled
    if (profileController.nameController.text.isEmpty ||
        profileController.phoneNumberController.text.isEmpty ||
        profileController.emailController.text.isEmpty ||
        profileController.instagramController.text.isEmpty) {
      // Show a snackbar or alert dialog to indicate that fields are required
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Call the updateProfile method from the controller
    profileController.updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Account'),
        backgroundColor: Colors.white,
        elevation: 0,
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
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Header with Avatar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: _image == null
                                    ? AssetImage('assets/razzan.jpg')
                                    : FileImage(_image!) as ImageProvider,
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: _pickImage,
                                child: Text(
                                  'Edit Photo or Avatar',
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
                      ],
                    ),
                  ),
                  // User Information
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: profileController.nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: profileController.phoneNumberController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: profileController.emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: profileController.instagramController,
                          decoration: InputDecoration(
                            labelText: 'Instagram',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                ],
              ),
            ),
            // Placeholder to avoid overflow
            SizedBox(height: 10),
          ],
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Icon Home
            IconButton(
              padding: EdgeInsets.only(left: 60, right: 60),
              onPressed: () {
                Get.toNamed(Routes.HOME);
              },
              icon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              tooltip: 'Home',
            ),
            // Icon Schedule
            IconButton(
              padding: EdgeInsets.only(left: 0, right: 0),
              onPressed: () {
                Get.toNamed(Routes.CART);
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.grey,
              ),
              tooltip: 'Cart',
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF495048),
              ),
              child: IconButton(
                padding: EdgeInsets.only(left: 60, right: 60),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content:
                            const Text('Anda sudah berada di halaman profile'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                tooltip: 'Profil',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
