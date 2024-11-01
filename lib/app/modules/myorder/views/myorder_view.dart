import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:myapp/app/modules/login/controllers/login_controller.dart';
import 'package:myapp/app/modules/myorder/controllers/myorder_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class MyorderView extends GetView<MyorderController> {
  const MyorderView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    // Mendapatkan tanggal saat ini
    String currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back default
        title: Align(
          alignment: Alignment.centerLeft, // Rata kiri untuk teks Order Management
          child: const Text('My Order'),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Ikon back berwarna hitam
          tooltip: 'Back',
          onPressed: () {
            Get.toNamed(Routes.MAINPROFILE); // Rute ke halaman MainProfile
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Teks tanggal align left
          children: [
            // Teks tanggal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Today, ' + currentDate,
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Container abu-abu kosong dengan radius dan margin
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12), // Radius sudut
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Margin rapi dengan tepi layar
              height: 150, // Tinggi container
              child: Center(
                child: Text(
                  'Di sini akan ada card-card menu',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
            // UI yang mengarahkan pengguna ke halaman AdminHistory
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  // // Rute ke halaman AdminHistory
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.teal, // Mengubah warna menjadi teal
                    borderRadius: BorderRadius.circular(12), // Radius sudut
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lihat Riwayat Pemesanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Klik ini untuk melihat aktivitas pemesanan yang telah selesai.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // No Bottom Navigation Bar
    );
  }
}
