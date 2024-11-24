import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart'; 
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server/gmail.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxInt generatedOTP = 0.obs;

  // Fungsi untuk mengirim OTP
  Future<void> sendOTP(String email) async {
    try {
      isLoading.value = true;

      // Generate kode OTP
      generatedOTP.value = Random().nextInt(900000) + 100000;

      // Konfigurasi SMTP
      String username = 'appkazakopi@gmail.com'; // Ganti dengan email pengirim
      String password = 'gqku tvmm qqdg fmem'; // Ganti dengan app password email

      final smtpServer = gmail(username, password);

      // Buat email
      final message = mailer.Message() // Gunakan alias di sini
        ..from = mailer.Address(username, 'Kaza Kopi Nusantara')
        ..recipients.add(email)
        ..subject = 'Kode OTP Anda'
        ..text = 'Kode OTP Anda adalah: ${generatedOTP.value}';

      // Kirim email
      await mailer.send(message, smtpServer);

      Get.snackbar(
        'OTP Sent',
        'Kode OTP telah dikirim ke $email',
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim OTP: $e', backgroundColor: Colors.red);
      print('Error sending OTP: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk memverifikasi OTP dan menyimpan data pengguna
  Future<void> verifyOTPAndRegister(
    String enteredOTP,
    String email,
    String password,
    String username,
    String phoneNumber,
  ) async {
    if (enteredOTP == generatedOTP.value.toString()) {
      try {
        isLoading.value = true;

        // Registrasi pengguna di Firebase Authentication
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Simpan data pengguna ke Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
          'username': username,
          'phoneNumber': phoneNumber,
          'email': email,
          'uid': userCredential.user?.uid,
        });

        Get.snackbar('Success', 'Registration successful', backgroundColor: Colors.green);
        Get.offNamed('/login'); // Navigasi ke halaman Home
      } catch (e) {
        Get.snackbar('Error', 'Gagal registrasi: $e', backgroundColor: Colors.red);
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Error', 'Kode OTP salah!', backgroundColor: Colors.red);
    }
  }
}
