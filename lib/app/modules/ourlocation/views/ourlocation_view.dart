import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/ourlocation_controller.dart';

class OurlocationView extends GetView<OurlocationController> {
  OurlocationView({super.key});

  // Menggunakan RxString untuk mengelola nilai selectedLocation secara reaktif
  final RxString selectedLocation = 'https://maps.app.goo.gl/FT3qx5kgCB9rfogB8'.obs;

  final List<Map<String, String>> locations = [
    {
      'name': 'Pasar Tambak Rejo, Surabaya',
      'url': 'https://maps.app.goo.gl/FT3qx5kgCB9rfogB8'
    },
    {
      'name': 'CitraLand CBD Boulevard, Surabaya',
      'url': 'https://maps.app.goo.gl/4qcKuXQtYNMhoCpD6'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Location',
          style: TextStyle(color: Colors.white), // Set the title text color to white
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Set the back arrow color to white
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0), // Margin kiri, kanan, dan atas
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[400], // Warna abu-abu
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown dengan desain yang stylish
            Card(
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Obx(() {
                  return DropdownButton<String>(
                    isExpanded: true,
                    value: selectedLocation.value, // Menggunakan RxString
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedLocation.value = newValue; // Mengubah nilai RxString
                      }
                    },
                    items: locations.map<DropdownMenuItem<String>>((location) {
                      return DropdownMenuItem<String>(
                        value: location['url'],
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.teal[700]), // Icon lokasi
                            SizedBox(width: 8),
                            Text(
                              location['name']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.teal[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    icon: Icon(
                      Icons.arrow_drop_down, // Menambahkan ikon panah untuk dropdown
                      color: Colors.teal[700],
                    ),
                    underline: Container(),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            // WebView menampilkan lokasi peta yang dipilih
            Expanded(
              child: Card(
                elevation: 8,
                shadowColor: Colors.black.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Obx(() {
                    return WebViewWidget(
                      controller: controller.webViewController(selectedLocation.value),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
