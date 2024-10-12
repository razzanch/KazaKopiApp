import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';


class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  // Menyimpan indeks pilihan metode pembayaran
  int? selectedPaymentMethod;

  // Menyimpan kuantitas setiap item yang dibeli
  Map<String, int> itemQuantities = {
    'Kopi Susu Reguler': 1,
    'Kopi Susu Gula Aren': 1,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Warna background AppBar
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Jarak untuk padding
          child: CircleAvatar(
            backgroundColor: Colors.teal, // Warna lingkaran
            child: IconButton(
              icon:
                  Icon(Icons.arrow_back, color: Colors.white), // Tombol kembali
              onPressed: () {
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Menambahkan SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul "YOUR ORDER"
              Text(
                'YOUR ORDER:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50), // Jarak antar elemen

              // Item yang dibeli
              _buildOrderItem('Kopi Susu Reguler'),
              SizedBox(height: 20),
              _buildOrderItem('Kopi Susu Gula Aren'),
              SizedBox(height: 50), // Jarak antar elemen

              // Alamat
              Text(
                '🇺🇦 Ukraine, Ivano-Frankivsk, Konovaltsya 132',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 50), // Jarak antar elemen

              // Payment Method
              Text(
                'Payment method:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildPaymentMethod(0, 'assets/visa.png', 'VISA/MasterCard'),
              _buildPaymentMethod(1, 'assets/dana.png', 'DANA'),
              _buildPaymentMethod(2, 'assets/linkaja.png', 'LINK AJA'),
              SizedBox(height: 40), // Jarak antar elemen

              // Total
              Align(
                alignment: Alignment.centerRight, // Mengatur posisi ke kanan
                child: Text(
                  'Total: \$${_calculateTotal()}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20), // Jarak antar elemen

              // Create Order Button
              Center(
                child: SizedBox(
                  width: double.infinity, // Lebar sesuai dengan layar
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Cek apakah pengguna telah memilih metode pembayaran
                      if (selectedPaymentMethod == null) {
                        _showPaymentMethodDialog(context);
                      } else {
                        _showFullScreenDialog(
                            context); // Tampilkan dialog terima kasih
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Warna button
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5), // Ubah border radius sesuai keinginan
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Mengatur teks dan ikon ke kedua ujung
                      children: [
                        Text(
                          'Create Order',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(Icons.arrow_forward,
                            color: Colors.white), // Ikon ">"
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                Get.toNamed(Routes.HOME); // Ubah sesuai rute yang Anda gunakan
              },
              icon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              tooltip: 'Home',
            ),
            // Container with the gray circle over the Cart icon
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF495048), // Warna highlight abu-abu
                  ),
                  width: 50, // Diameter of the circle
                  height: 50,
                ),
                IconButton(
                  padding: EdgeInsets.all(0), // Remove extra padding
                  onPressed: () {
                     showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content: const Text('Anda sudah berada di halaman cart'),
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
                    Icons.shopping_cart,
                    color: Colors.white, // Change icon color to white
                  ),
                  tooltip: 'Cart',
                ),
              ],
            ),
            // Icon Profile
            IconButton(
              padding: EdgeInsets.only(left: 60, right: 60),
              onPressed: () {
                Get.toNamed(Routes.PROFILE);
              },
              icon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              tooltip: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun item pesanan
  Widget _buildOrderItem(String name) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nama makanan dan rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 16),
                  SizedBox(width: 5),
                  Text('4.8',
                      style: TextStyle(
                          fontSize:
                              16)), // Set rating secara statis atau dinamis
                ],
              ),
            ],
          ),
          // Jumlah
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  // Mengurangi kuantitas jika lebih dari 1
                  if (itemQuantities[name]! > 1) {
                    setState(() {
                      itemQuantities[name] = itemQuantities[name]! - 1;
                    });
                  }
                },
              ),
              Text(itemQuantities[name].toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Menambah kuantitas
                  setState(() {
                    itemQuantities[name] = itemQuantities[name]! + 1;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menghitung total harga
  double _calculateTotal() {
    double total = 0;
    total += itemQuantities['Kopi Susu Reguler']! * 5; // Harga unit Profiterol
    total += itemQuantities['Kopi Susu Gula Aren']! * 6; // Harga unit Espresso
    return total;
  }

  Widget _buildPaymentMethod(int index, String imagePath, String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = index; // Update indeks yang dipilih
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selectedPaymentMethod == index
              ? Colors.blue[100]
              : Colors.transparent, // Highlight jika dipilih
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            // Gambar metode pembayaran
            Image.asset(
              imagePath,
              width: 30, // Ukuran gambar
              height: 30,
            ),
            SizedBox(width: 10), // Jarak antara gambar dan teks
            // Teks metode pembayaran
            Text(
              method,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Metode Pembayaran'),
          content: Text('Silakan pilih metode pembayaran terlebih dahulu.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFullScreenDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Thank You For Your Order!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Wait For The Call',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Menutup dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
