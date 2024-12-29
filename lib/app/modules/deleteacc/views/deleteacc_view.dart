import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/login/views/login_view.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteaccView extends StatefulWidget {
  @override
  _DeleteaccViewState createState() => _DeleteaccViewState();
}

class _DeleteaccViewState extends State<DeleteaccView> {
   String? urlImage; // Variabel untuk menyimpan URL gambar pengguna
  final String defaultImage = 'assets/LOGO.png';
  final ProfileController profileController = Get.put(ProfileController());
  
 
  // Controllers for TextFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmDeleteController = TextEditingController();
  
  void logout() async {
  // Sign out from Firebase Auth
  await FirebaseAuth.instance.signOut();

  // Remove token and email from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  await prefs.remove('email'); // Hapus email saat logout

  // Redirect to login page
  Get.offAll(() => LoginView()); // Make sure LoginView is the correct page for login
  }

  void _deleteAccount() async {
  // Regex untuk validasi email dan password
  final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$'); // Email valid dengan domain @gmail.com
  final passwordPattern = RegExp(r'^[a-zA-Z0-9]{6,}$'); // Hanya huruf dan angka, minimal 6 karakter

  // Validasi input
  if (_emailController.text.isEmpty || 
      _passwordController.text.isEmpty || 
      _confirmDeleteController.text.isEmpty) {
    Get.snackbar(
      'Error',
      'Please fill in all fields',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  // Validasi email
  if (!emailPattern.hasMatch(_emailController.text)) {
    Get.snackbar(
      'Error',
      'Email must be a valid Gmail address (e.g., example@gmail.com)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  // Validasi password
  if (!passwordPattern.hasMatch(_passwordController.text)) {
    Get.snackbar(
      'Error',
      'Password must contain only letters and numbers and be at least 6 characters long',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  // Verifikasi bahwa teks konfirmasi sesuai dengan "DELETE"
  if (_confirmDeleteController.text != 'DELETE') {
    Get.snackbar(
      'Error',
      'Please type "DELETE" to confirm account deletion',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  try {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.email == _emailController.text) {
      // Verifikasi email dan password lama dengan re-authentication
      final authCredential = EmailAuthProvider.credential(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Re-authenticate pengguna untuk memastikan password lama benar
      await currentUser.reauthenticateWithCredential(authCredential);

      // Hapus akun setelah re-authentication berhasil
      await currentUser.delete();

      // Hapus dokumen pengguna dari Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid) // Menggunakan UID pengguna yang sedang login
          .delete();

      // Tampilkan dialog berhasil
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Account Deletion Succeeded',
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
                    logout(); // Navigate to login and prevent going back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF495048), // Button background color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Return', // Button text
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      // Jika email atau password tidak sesuai dengan pengguna yang sedang login
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
      'Failed to delete account: ${e.toString()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Delete Account',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold), // Set text color to white
        ),
        backgroundColor: Colors.teal, // Set AppBar background color
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Padding for back button
          child: CircleAvatar(
            backgroundColor: Colors.teal, // Circle color
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white), // Back button
              onPressed: () {
                Get.toNamed(Routes.MAINPROFILE); // Go back to the main profile page
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Obx(() {
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
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Margin kiri, kanan, dan atas
    child: Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Warna Container menjadi grey[300]
        borderRadius: BorderRadius.circular(10), // Sudut melengkung
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email TextField
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
          // Password TextField
          TextField(
            controller: _passwordController,
            obscureText: true, // Mask password input
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Confirmation TextField
          TextField(
            controller: _confirmDeleteController,
            decoration: InputDecoration(
              labelText: 'Type "DELETE" to confirm',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 30),
          // Delete Account Button
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _deleteAccount,
                child: Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Set button color
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(color: Colors.grey), // Garis pembatas
          SizedBox(height: 10),
          Text(
            'Note: Once your account is deleted, it cannot be recovered.',
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
