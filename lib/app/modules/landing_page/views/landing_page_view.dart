import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/landing_page_controller.dart';

class LandingPageView extends GetView<LandingPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image TIRAIBG
          Image.asset(
            'assets/TIRAIBG.png',
            width: MediaQuery.of(context).size.width,
            height: 270,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Translated logo and text
                Transform.translate(
                  offset: Offset(0, 30), // Adjust X and Y values as needed
                  child: Column(
                    children: [
                      Image.asset('assets/LOGO.png', height: 150),
                      SizedBox(height: 100),
                      Text(
                        "Kaza Kopi Nusantara",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 50),
                      Text(
                        "Time for a coffee break....",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 40),
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
                SizedBox(height: 40), // Space between description and button
                // Full-width Get Started Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                  child: SizedBox(
                    width: double.infinity, // Make button full-width
                    child: ElevatedButton(
                      onPressed: () async {
                        // Check login status before navigating
                        await controller.checkLoginStatus();
                        if (controller.isLoggedIn.value) {
                          if (controller.isAdmin.value) {
                            Get.offAllNamed(Routes.ADMINHOME);
                          } else {
                            Get.offAllNamed(Routes.HOME);
                          }
                        } else {
                          Get.offAllNamed(Routes.LOGIN);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: EdgeInsets.symmetric(vertical: 15),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
