import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/login/controllers/login_controller.dart';
import 'package:myapp/app/modules/mainprofile/controllers/mainprofile_controller.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class MainprofileView extends StatelessWidget {
  final MainprofileController controller = Get.put(MainprofileController());
  final LoginController loginController = Get.put(LoginController());
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Background image
                Image.asset(
                  'assets/TIRAIBG.png',
                  width: MediaQuery.of(context).size.width,
                  height: 270,
                  fit: BoxFit.cover,
                ),
                // Avatar positioned near the bottom of the background image
                Positioned(
  top: 100,
  left: MediaQuery.of(context).size.width / 2 - 80,
  child: Obx(() {
  final imagePath = profileController.selectedImagePath.value;

  return CircleAvatar(
    radius: 80,
    backgroundImage: imagePath.startsWith('http')
        ? NetworkImage(imagePath)
        : (File(imagePath).existsSync()
            ? FileImage(File(imagePath))
            : AssetImage('assets/pp5.jpg')) as ImageProvider,
    onBackgroundImageError: (_, __) {
      // Jika gambar gagal, gunakan fallback
      profileController.selectedImagePath.value = 'assets/pp5.jpg';
    },
  );
}),
),

                // Logout Button at the top right corner
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    icon: Icon(Icons.logout),
                    color: Colors.red,
                    onPressed: () {
                      loginController.logout();
                    },
                    tooltip: 'Logout',
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.grey),
                  SizedBox(height: 20),

                  // Last Update display
                  Obx(() => Text(
                        'Last update: ${controller.lastUpdate.value}',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                        ),
                      )),
                  SizedBox(height: 20),

                  // Displaying the user's information in TextFields
                  Obx(() => TextField(
                        controller: TextEditingController(
                            text: controller.username.value),
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                        ),
                      )),
                  SizedBox(height: 20),
                  Obx(() => TextField(
                        controller:
                            TextEditingController(text: controller.email.value),
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      )),
                  SizedBox(height: 20),
                  Obx(() => TextField(
                        controller: TextEditingController(
                            text: controller.phoneNumber.value),
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      )),
                  SizedBox(height: 20),
                  Obx(() => TextField(
                        controller:
                            TextEditingController(text: controller.uid.value),
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          labelText: 'User ID',
                          prefixIcon: Icon(Icons.key),
                        ),
                      )),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        // Update Profile Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.PROFILE);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Update Account',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Reset Password Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.RESETPW);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Change Password',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(Icons.refresh, color: Colors.black),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFCECECE),
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Delete Account Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.DELETEACC);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delete Account',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.delete, color: Colors.white),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  // Activity header
                  Text(
                    'Activity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.grey),
                  SizedBox(height: 10),
                  // Row of images: MyOrder, MyFav, OurIG, HC
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.MYORDER),
                        child: Image.asset(
                          'assets/MyOrder.png',
                          width: 170,
                          height: 170,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.MYFAV),
                        child: Image.asset(
                          'assets/MyFav.png',
                          width: 170,
                          height: 170,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.OURLOCATION),
                        child: Image.asset(
                          'assets/OurIG.png',
                          width: 170,
                          height: 170,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.HELPCENTER),
                        child: Image.asset(
                          'assets/HC.png',
                          width: 170,
                          height: 170,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Thin divider below image section
                  Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: 10), // Space between divider and text
                  Center(
                    child: Text(
                      'Kazakopi Nusantara ©',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 30), // Extra spacing
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar (Navbar)
      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Icon
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.HOME); // Navigate to the home page
              },
              icon: Icon(Icons.home, color: Colors.grey),
              tooltip: 'Home',
            ),
            // Cart Icon
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CART); // Navigate to the cart page
              },
              icon: Icon(Icons.shopping_cart, color: Colors.grey),
              tooltip: 'Cart',
            ),
            // News Icon (empty onPressed logic)
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.GETCONNECT);
              }, // Leave empty for News section
              icon: Icon(Icons.article, color: Colors.grey),
              tooltip: 'News',
            ),
            // Profile Icon with highlight background
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF495048), // Gray highlight color
              ),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content:
                            const Text('Anda sudah berada di halaman profile'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.person, color: Colors.white),
                tooltip: 'Profil',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
