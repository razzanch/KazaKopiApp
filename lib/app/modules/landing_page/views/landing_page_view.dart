import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

import '../controllers/landing_page_controller.dart';



class LandingPageView extends GetView<LandingPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Menggunakan Center untuk memusatkan konten
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and Image
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                children: [
                  // Logo from your assets
                  Image.asset('assets/LOGO.png', height: 100),

                  SizedBox(height: 40),

                  // Title Text
                  Text(
                    "Kaza Kopi Nusantara",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),

                  SizedBox(height: 50),

                  // Subtitle Text
                  Text(
                    "Time for a coffee break....",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),

                  SizedBox(height: 40),

                  // Description Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      "Your daily dose of fresh brew delivered to your doorstep. Start your coffee journey now!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
                height: 40), // Menambahkan ruang antara deskripsi dan tombol

            // Get Started Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.LOGIN);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
