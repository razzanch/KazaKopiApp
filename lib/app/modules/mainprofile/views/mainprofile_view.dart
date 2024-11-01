import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/mainprofile/controllers/mainprofile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class MainProfileView extends StatelessWidget {
  final MainProfileController controller = Get.put(MainProfileController());

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
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/razzan.jpg'),
                  ),
                ),
                // Logout Button at the top right corner
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    icon: Icon(Icons.logout),
                    color: Colors.red,
                    onPressed: () {
                      Get.toNamed(Routes.LOGIN);
                    },
                    tooltip: 'Logout',
                  ),
                ),
                // Text ID positioned in the top left corner
                Positioned(
                  left: 20,
                  top: 25,
                  child: Text(
                    'ID: 202210370311445',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
                  // Displaying the user's information
                  Obx(() => Text(
                        'Username: ${controller.username.value}',
                        style: TextStyle(fontSize: 18),
                      )),
                  SizedBox(height: 20),
                  Obx(() => Text(
                        'Email: ${controller.email.value}',
                        style: TextStyle(fontSize: 18),
                      )),
                  SizedBox(height: 20),
                  Obx(() => Text(
                        'Phone Number: ${controller.phoneNumber.value}',
                        style: TextStyle(fontSize: 18),
                      )),
                  SizedBox(height: 20),
                  Obx(() => Text(
                        'User ID: ${controller.uid.value}',
                        style: TextStyle(fontSize: 18),
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
                        onTap: () => Get.toNamed(Routes.OURIG),
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
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Space below the text
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
                Get.toNamed(Routes.HOME);
              },
              icon: Icon(Icons.home, color: Colors.grey),
              tooltip: 'Home',
            ),
            // Cart Icon
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CART);
              },
              icon: Icon(Icons.shopping_cart, color: Colors.grey),
              tooltip: 'Cart',
            ),
            // Profile Icon
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.PROFILE);
              },
              icon: Icon(Icons.person, color: Colors.teal),
              tooltip: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
