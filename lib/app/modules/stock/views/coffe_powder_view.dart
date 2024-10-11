// lib/app/modules/home/views/coffee_powder_view.dart
import 'package:flutter/material.dart';
import '../../home/views/home_view.dart'; // Import dengan benar
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class CoffeePowderView extends StatelessWidget {
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tinggi layar
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        // Membungkus Column dengan SingleChildScrollView
        child: Padding(
          padding:
              const EdgeInsets.all(0), // Menghapus padding di sekitar layar
          child: Column(
            children: [
              // Kotak berwarna di atas gambar
              Container(
                color: Color(0xFF046E79),
                height: 200, // Tinggi kotak
                width: double.infinity, // Agar kotak mentok ke kanan dan kiri
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Menyusun konten secara vertikal
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Menyusun konten ke kiri
                  children: [
                    // Menambahkan logo location dan teks
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.white), // Ikon lokasi
                          SizedBox(width: 8), // Jarak antara ikon dan teks
                          Text(
                            'Location',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  16, // Ukuran font diubah menjadi lebih kecil
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Teks di bawah logo dan teks location
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'MALANG, JAWA TIMUR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              20, // Ukuran font untuk MALANG, JAWA TIMUR lebih besar
                          fontWeight:
                              FontWeight.bold, // Membuat teks lebih tebal
                        ),
                      ),
                    ),
                    // Menambahkan search bar dengan jarak ke bawah
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 20.0), // Menambah jarak vertikal
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // Warna search bar
                          borderRadius:
                              BorderRadius.circular(10), // Sudut melengkung
                        ),
                        child: Row(
                          children: [
                            // Ikon pencarian di dalam search bar
                            Padding(
                              padding: const EdgeInsets.all(
                                  8.0), // Padding untuk ikon
                              child: Icon(Icons.search,
                                  color: Colors.black), // Ikon pencarian
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder
                                      .none, // Menghilangkan border default
                                ),
                                style: TextStyle(
                                    color: Colors.black), // Warna teks
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8), // Jarak antara kotak dan gambar
              // Menggunakan Padding untuk mengatur jarak di samping gambar
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Jarak kiri dan kanan
                child: SizedBox(
                  height: screenHeight * 0.25, // 25% dari tinggi layar
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/special.png', // Mengganti special_offer.png dengan special.png
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16), // Jarak antara gambar dan teks "Bubuk Kopi"
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Mengatur jarak antara dua teks
                children: [
                  GestureDetector(
                    // Mengubah Padding menjadi GestureDetector untuk "Minuman"
                    onTap: () {
                      Get.to(HomeView()); // Navigasi ke HomeView
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 55.0), // Memindahkan "Minuman" lebih ke kiri
                      child: Text(
                        'Minuman', // Teks di samping "Bubuk Kopi"
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(
                              0xFF495048), // Mengubah warna menjadi #495048
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    // Mengubah Padding menjadi GestureDetector
                    onTap: () {
                      // Aksi ketika "Bubuk Kopi" di klik
                      Get.to(StockCoffeeView()); // Navigasi ke StockCoffeeView
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right:
                              55.0), // Memindahkan "Bubuk Kopi" lebih ke kanan
                      child: Text(
                        'Bubuk Kopi', // Teks di bawah gambar
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(
                              0xFF495048), // Mengubah warna menjadi #495048
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8), // Jarak antara teks dan kotak
              Align(
                alignment:
                    Alignment.centerLeft, // Mengatur posisi kotak ke kiri
                child: Padding(
                  padding: const EdgeInsets.only(
                      left:
                          240.0), // Memberikan padding ke kiri untuk menggeser kotak ke kanan
                  child: Container(
                    height: 8, // Tinggi kotak lebih pendek
                    decoration: BoxDecoration(
                      color: Color(0xFF495048), // Warna kotak
                      borderRadius:
                          BorderRadius.circular(30), // Sudut melengkung
                    ),
                    width: Get.width *
                        0.3, // Lebar kotak disesuaikan agar lebih pendek
                  ),
                ),
              ),
              SizedBox(height: 16), // Jarak antara teks "Minuman" dan grid
              // Menghapus Expanded dan membuat GridView dapat di-scroll
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap:
                    true, // Menentukan bahwa GridView harus menyesuaikan ukuran
                physics:
                    NeverScrollableScrollPhysics(), // Menghilangkan scroll GridView
                children: [
                  buildCoffeeCard(
                      'Robusta', 'Tersedia', 'assets/images/11.png'),
                  buildCoffeeCard(
                      'Arabic', 'Tersedia', 'assets/images/4.1.png'),
                ],
              ),
              SizedBox(height: 16), // Menambahkan ruang di bawah grid
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFF495048)), // Ikon Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,
                color: Color(0xFF495048)), // Ikon Cart
            label: 'Cart',
          ),
        ],
        currentIndex: 0, // Menandakan bahwa Home adalah yang aktif
        selectedItemColor: Color(0xFF495048), // Warna saat item dipilih
        unselectedItemColor: Colors.grey, // Warna saat item tidak dipilih
        onTap: (index) {
          // Logika untuk berpindah tampilan jika diperlukan
          if (index == 0) {
            Get.to(HomeView()); // Navigasi ke HomeView
          } else if (index == 1) {
            // Jika Cart dipilih, navigasikan ke tampilan Cart yang harus dibuat
            // Get.to(CartView()); // Uncomment ini jika Anda sudah membuat CartView
          }
        },
      ),
    );
  }

  Widget buildCoffeeCard(String title, String availability, String imagePath) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 100, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 8, vertical: 4), // Padding untuk teks
            color: Color(0xFF495048), // Latar belakang berwarna #495048
            child: Text(
              availability,
              style: TextStyle(color: Colors.white), // Warna teks menjadi putih
            ),
          ),
        ],
      ),
    );
  }
}

class StockCoffeeView {}
