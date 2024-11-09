import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ForgotpwView extends StatefulWidget {
  @override
  _ForgotpwViewState createState() => _ForgotpwViewState();
}

class _ForgotpwViewState extends State<ForgotpwView> {
  final TextEditingController _emailController = TextEditingController();


  // Firebase Authentication and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to reset password
  void _resetPassword() async {
    // Check if email field is filled
    if (_emailController.text.isEmpty) {
      // Show an error snackbar if email is not provided
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
      // Query Firestore to find a matching user by email
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // User found, send password reset email
        var userDoc = querySnapshot.docs.first;
        String email = userDoc['email'];

        // Trigger password reset using FirebaseAuth
        await _auth.sendPasswordResetEmail(email: email);

        // Show a success notification
        Get.snackbar(
          'Success',
          'Password reset instructions have been sent to your email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await _auth.signOut();  // Sign out the user
        Get.toNamed(Routes.LOGIN);

      } else {
        // Show an error notification if user not found
        Get.snackbar(
          'Error',
          'User not found with the provided email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle any errors that occur during the Firestore query or password reset
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
          'Forgot Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                Get.toNamed(Routes.LOGIN); // Navigate to login screen
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
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

                
                SizedBox(height: 30),
                // Reset Password Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text(
                        'Reset Password',
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
                // Warning Text
                Divider(color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'Note: To reset your password, simply click "Reset Password". You will receive an email from KazakopiApp team with instructions to reset your password.',
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
