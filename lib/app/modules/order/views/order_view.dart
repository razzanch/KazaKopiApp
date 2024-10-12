import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

import '../controllers/order_controller.dart';

class OrderView extends GetView<OrderController> {
  final List<Map<String, dynamic>> orderHistory = [
    {
      'title': 'Kopi Susu Reguler',
      'date': '24 September 2024',
      'image': 'assets/M1.png',
    },
    {
      'title': 'Kopi Susu Gula Aren',
      'date': '23 September 2024',
      'image': 'assets/M2.png',
    },
    {
      'title': 'Arabic Fine Prager',
      'date': '22 September 2024',
      'image': 'assets/M3.png',
    },
    {
      'title': 'Kopi Susu Reguler',
      'date': '22 September 2024',
      'image': 'assets/M4.png',
    },
    {
      'title': 'Kopi Susu Gula Aren',
      'date': '21 September 2024',
      'image': 'assets/M1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed(Routes.STOCK);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ORDER HISTORY:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: orderHistory.length,
                itemBuilder: (context, index) {
                  final order = orderHistory[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.asset(
                        order['image'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(order['title']),
                      subtitle: Text(order['date']),
                      trailing: Icon(Icons.check_circle_outline),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text('Rincian Pembelian:'),
            GestureDetector(
              onTap: () {
                // Handle download action
              },
              child: Text(
                'Download',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Get.toNamed(Routes.STOCK);
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content: const Text('Anda sudah berada di halaman Order History'),
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
            ),
          ],
        ),
      ),
    );
  }
}
