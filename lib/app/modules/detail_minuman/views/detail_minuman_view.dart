import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/detail_minuman_controller.dart';

class DetailMinumanView extends GetView<DetailMinumanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    'Coffee Menu',
    style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
  ),
  backgroundColor: Colors.teal,
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white), // Ikon tombol back
    onPressed: () {
      Get.toNamed(Routes.HOME); // Mengarahkan ke Routes.HOME
    },
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.favorite, color: Colors.red),
      onPressed: () {
        Get.toNamed(Routes.HOME); // Mengarahkan ke Routes.HOME
      },
    ),
  ],
),


      body: Obx(() {
        // Cek apakah kita di detail atau daftar produk
        if (controller.product.value == null) {
          return ListView.builder(
            itemCount: controller.products.length,
            itemBuilder: (context, index) {
              final product = controller.products[index];
              return ListTile(
                leading: Image.asset(product.image, width: 50, height: 50),
                title: Text(product.name),
                subtitle: Text('RP ${product.price.toStringAsFixed(0)}'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Set produk yang dipilih dan navigasi ke detail
                  controller.product.value = product;
                },
              );
            },
          );
        }

        // Jika produk tidak null, tampilkan detail produk
        final product = controller.product.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      product.image,
                      height: 200,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final currentIndex = controller.products.indexOf(product);
                            if (currentIndex > 0) {
                              controller.product.value = controller.products[currentIndex - 1];
                            }
                          },
                          child: Text(
                            'Previous',
                            style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Ubah warna latar belakang menjadi teal
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            product.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final currentIndex = controller.products.indexOf(product);
                            if (currentIndex < controller.products.length - 1) {
                              controller.product.value = controller.products[currentIndex + 1];
                            }
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Ubah warna latar belakang menjadi teal
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF00796B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.white, size: 16),
                          SizedBox(width: 5),
                          Text(
                            product.rating.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Coffee Size',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ChoiceChip(
                    label: Text('SMALL'),
                    selected: controller.selectedSize.value == 'SMALL',
                    selectedColor: Color(0xFF5F6D6D),
                    backgroundColor: Colors.grey[300],
                    onSelected: (bool selected) {
                      if (selected) controller.setSize('SMALL');
                    },
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('LARGE'),
                    selected: controller.selectedSize.value == 'LARGE',
                    selectedColor: Color(0xFF5F6D6D),
                    backgroundColor: Colors.grey[300],
                    onSelected: (bool selected) {
                      if (selected) controller.setSize('LARGE');
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              Text(
                product.description,
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.justify, // Menyusun teks dengan rata kanan dan kiri
              ),
              SizedBox(height: 20), // Spasi untuk estetika
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RP ${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.addToCart,
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00A18E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
