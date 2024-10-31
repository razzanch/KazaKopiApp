import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ResetpwView extends StatefulWidget {
  @override
  _ResetpwViewState createState() => _ResetpwViewState();
}

class _ResetpwViewState extends State<ResetpwView> {
  // Controllers for TextFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _resetPassword() {
    // Check if all TextFields are filled
    if (_emailController.text.isEmpty ||
        _oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty) {
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
                'Password Reset Succeeded',
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
                  Get.toNamed(Routes.MAINPROFILE);
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
        title: Text('Change Password'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              // Old Password TextField
              TextField(
                controller: _oldPasswordController,
                obscureText: true, // Mask password input
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // New Password TextField
              TextField(
                controller: _newPasswordController,
                obscureText: true, // Mask password input
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Reset Password Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50, // Mengatur tinggi tombol
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    child: Text(
                      'Change',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Set button color
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
                        content: const Text('Anda sudah berada di halaman reset password'),
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
