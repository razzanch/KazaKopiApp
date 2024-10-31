import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:myapp/app/routes/app_pages.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Controllers for TextFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();

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
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _instagramController.text.isEmpty) {
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

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Update Profile Succeeded',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/sukses.png', // Path ke gambar sukses
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Menutup dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF495048), // Warna background tombol
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Return', // Teks tombol diubah menjadi "Return"
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Account'),
        backgroundColor: Colors.white, // Set AppBar background color
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Jarak untuk padding
          child: CircleAvatar(
            backgroundColor: Colors.teal, // Warna lingkaran
            child: IconButton(
              icon:
                  Icon(Icons.arrow_back, color: Colors.white), // Tombol kembali
              onPressed: () {
                Get.toNamed(Routes.MAINPROFILE); // Kembali ke halaman sebelumnya
              },
            ),
          ),
        ), // Remove shadow
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
                              SizedBox(
                                  height: 10), // Adjust this value to move down
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
                                    fontSize: 18, // Increase font size here
                                    fontWeight: FontWeight.bold, // Make it bold
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _instagramController,
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
                            width: double.infinity, // Tombol akan mengisi lebar layar induknya
                            height: 50, // Mengatur tinggi tombol
                            child: ElevatedButton(
                              onPressed: _updateProfile, // Call the update function
                              child: Text(
                                'Update Profile',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal, // Set the button color to teal
                                padding: EdgeInsets.symmetric(vertical: 15), // Mengatur padding vertikal
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Set a slight curve for the corners
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
      // Bottom Navigation Bar (Navbar)
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
                color: Color(0xFF495048), // Warna highlight abu-abu
              ),
              child: IconButton(
                padding: EdgeInsets.only(left: 60, right: 60),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content: const Text('Anda sudah berada di halaman profile'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back(); // Menutup dialog
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
