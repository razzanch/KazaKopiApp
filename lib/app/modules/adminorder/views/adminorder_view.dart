import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:myapp/app/modules/login/controllers/login_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/adminorder_controller.dart';

class AdminorderView extends GetView<AdminorderController> {
  const AdminorderView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    // Mendapatkan tanggal saat ini
    String currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        title: Align(
          alignment: Alignment.centerLeft, // Rata kiri untuk teks Order Management
          child: const Text('Order Management'),
        ),
        actions: [
          // Button Logout
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red), // Ikon logout berwarna merah
            tooltip: 'Logout',
            onPressed: () {
              loginController.logout();
            },
          ),
        ],
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
                  Get.toNamed(Routes.ADMINHISTORY); // Rute ke halaman AdminHistory
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
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Ikon Home untuk navigasi ke halaman admin home
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADMINHOME); // Rute ke halaman AdminHome
              },
              icon: Icon(
                Icons.home,
                color: Colors.grey[800],
              ),
              tooltip: 'Home',
            ),
            // Ikon untuk menambah menu minuman
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CREATEMINUMAN); // Rute ke halaman CreateMinuman
              },
              icon: Icon(
                Icons.local_cafe, // Ikon untuk menambah menu minuman
                color: Colors.grey[800],
              ),
              tooltip: 'Add Minuman Menu',
            ),
            // Ikon untuk menambah menu bubuk kopi
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CREATEBUBUK); // Rute ke halaman CreateBubuk
              },
              icon: Icon(
                Icons.grain
, // Ikon untuk menambah menu bubuk kopi
                color: Colors.grey[800],
              ),
              tooltip: 'Add Bubuk Menu',
            ),
            // Ikon Management Order dengan dialog peringatan
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF495048),
                  ),
                  width: 50,
                  height: 50,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content: const Text('Anda sudah berada di halaman Order Management'),
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
                    Icons.assignment, // Ikon untuk management order
                    color: Colors.white,
                  ),
                  tooltip: 'Management Order',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
