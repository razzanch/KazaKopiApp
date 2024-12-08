
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ResetpwView extends StatefulWidget {
  @override
  _ResetpwViewState createState() => _ResetpwViewState();
}

class _ResetpwViewState extends State<ResetpwView> {
  String? urlImage; // Variabel untuk menyimpan URL gambar pengguna
  final String defaultImage = 'assets/LOGO.png';
  final ProfileController profileController = Get.put(ProfileController());
  
  

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _resetPassword() async {
  // Regex untuk validasi email dan password
  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$'); // Validasi email harus @gmail.com
  final passwordPattern = RegExp(r'^[a-zA-Z0-9]{6,}$'); // Hanya huruf dan angka, minimal 6 karakter

  // Validasi email
  if (_emailController.text.isEmpty || !emailPattern.hasMatch(_emailController.text)) {
    Get.snackbar(
      'Error',
      'Email must be a valid Gmail address (e.g., example@gmail.com)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  // Validasi old password
  if (_oldPasswordController.text.isEmpty || !passwordPattern.hasMatch(_oldPasswordController.text)) {
    Get.snackbar(
      'Error',
      'Old password must contain only letters and numbers and be at least 6 characters long',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  // Validasi new password
  if (_newPasswordController.text.isEmpty || !passwordPattern.hasMatch(_newPasswordController.text)) {
    Get.snackbar(
      'Error',
      'New password must contain only letters and numbers and be at least 6 characters long',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  try {
    // Dapatkan pengguna yang sedang login
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.email == _emailController.text) {
      // Verifikasi email dan old password
      final authCredential = EmailAuthProvider.credential(
        email: _emailController.text,
        password: _oldPasswordController.text,
      );

      // Re-authenticate pengguna
      await currentUser.reauthenticateWithCredential(authCredential);

      // Perbarui password
      await currentUser.updatePassword(_newPasswordController.text);

      // Tampilkan dialog berhasil
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Password Reset Succeeded',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/sukses.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.toNamed(Routes.MAINPROFILE);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF495048),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Return',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Jika email tidak sesuai dengan pengguna yang sedang login
      Get.snackbar(
        'Error',
        'Email and password do not match the current user.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    // Tangani kesalahan jika terjadi
    Get.snackbar(
      'Error',
      'Failed to reset password: ${e.toString()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold), // Set text color to white
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              final imagePath = profileController.selectedImagePath.value;

              return CircleAvatar(
                radius: 20,
                backgroundImage: imagePath.startsWith('http')
                    ? NetworkImage(imagePath)
                    : (File(imagePath).existsSync()
                        ? FileImage(File(imagePath))
                        : AssetImage('assets/pp5.jpg')) as ImageProvider,
                onBackgroundImageError: (_, __) {
                  // Jika gambar gagal, gunakan fallback
                  profileController.selectedImagePath.value = 'assets/pp5.jpg';
                },
              );
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Set Container color to grey[300]
        borderRadius: BorderRadius.circular(10), // Set corner radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _oldPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Old Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _resetPassword,
                child: Text(
                  'Change',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(color: Colors.grey), // Add divider
          SizedBox(height: 10),
          Text(
            '*Note: After the password change, you will not be able to log in using the old password.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  ),
),

    );
  }
}
