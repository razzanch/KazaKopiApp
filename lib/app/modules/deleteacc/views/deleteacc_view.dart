import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class DeleteaccView extends StatefulWidget {
  @override
  _DeleteaccViewState createState() => _DeleteaccViewState();
}

class _DeleteaccViewState extends State<DeleteaccView> {
  // Controllers for TextFields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmDeleteController = TextEditingController();

  void _deleteAccount() {
    // Check if all TextFields are filled
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmDeleteController.text.isEmpty) {
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

    // Check if confirmation text is "DELETE"
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

    // Show success dialog for account deletion
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
                  Navigator.of(context).pop(); // Close the dialog
                  Get.toNamed(Routes.MAINPROFILE); // Redirect to login or another page
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
        backgroundColor: Colors.white, // Set AppBar background color
        elevation: 0,
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
                  height: 50, // Set button height
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
                color: Color(0xFF495048), // Highlight color
              ),
              child: IconButton(
                padding: EdgeInsets.only(left: 60, right: 60),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content: const Text('You are already on the delete account page'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back(); // Close the dialog
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
                tooltip: 'Profile',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
