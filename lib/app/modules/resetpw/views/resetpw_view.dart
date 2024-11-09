import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ResetpwView extends StatefulWidget {
  @override
  _ResetpwViewState createState() => _ResetpwViewState();
}

class _ResetpwViewState extends State<ResetpwView> {
  String? urlImage; // Variabel untuk menyimpan URL gambar pengguna
  final String defaultImage = 'assets/LOGO.png';
  
  @override
  void initState() {
    super.initState();
    fetchUserImage();
  }

  Future<void> fetchUserImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          urlImage = userDoc.data()?['urlImage'] ?? defaultImage;
        });
      } else {
        setState(() {
          urlImage = defaultImage;
        });
      }
    }
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _resetPassword() async {
  if (_emailController.text.isEmpty ||
      _oldPasswordController.text.isEmpty ||
      _newPasswordController.text.isEmpty) {
    Get.snackbar(
      'Error',
      'Please fill in all fields',
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
      // Verifikasi email dan old password yang dimasukkan
      // Menggunakan re-authentication untuk memastikan password lama benar
      final authCredential = EmailAuthProvider.credential(
        email: _emailController.text,
        password: _oldPasswordController.text,
      );

      // Re-authenticate pengguna untuk memverifikasi old password
      await currentUser.reauthenticateWithCredential(authCredential);

      // Jika re-authentication berhasil, perbarui password
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
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(urlImage ?? defaultImage),
            ),
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
