import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainProfileController extends GetxController {
  // Reactive variables
  var username = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var uid = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserData(); // Call the function to fetch user data
  }

  void _fetchUserData() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          username.value = data['username'] ?? '';
          email.value = data['email'] ?? '';
          phoneNumber.value = data['phoneNumber'] ?? '';
          uid.value = data['uid'] ?? '';
        } else {
          print("User not found");
        }
      });
    } else {
      print("No user is signed in");
    }
  }
}
