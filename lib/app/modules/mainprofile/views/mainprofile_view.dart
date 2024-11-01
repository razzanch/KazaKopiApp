import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/login/controllers/login_controller.dart';

import 'package:myapp/app/routes/app_pages.dart';

class MainprofileView extends StatefulWidget {
  @override
  _MainprofileViewState createState() => _MainprofileViewState();
}

class _MainprofileViewState extends State<MainprofileView> {

    final LoginController loginController = Get.put(LoginController());
  // Controllers for TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();

  void _updateProfile() {
    Get.toNamed(Routes.PROFILE); // Directly route to the PROFILE page
  }

  void _resetPassword() {
    Get.toNamed(Routes.RESETPW); // Route to reset password page
  }

  void _deleteAccount() {
    Get.toNamed(
        Routes.DELETEACC); // Redirect to login or another screen after deletion
  }

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
                  height: 270, // Fixed height for the background
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
                      loginController.logout();
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
            SizedBox(height: 5), // Space between the avatar and the form
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
                  TextField(
                    controller: _usernameController,
                    readOnly: true, // TextField readOnly
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    readOnly: true, // TextField readOnly
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _phoneController,
                    readOnly: true, // TextField readOnly
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _uidController,
                    readOnly: true, // TextField readOnly
                    decoration: InputDecoration(
                      labelText: 'User ID',
                      filled: true, // Enables the background color
                      fillColor:
                          Colors.grey, // Sets background color to light gray
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        // Update Profile Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _updateProfile,
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
                            onPressed: _resetPassword,
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
                            onPressed: _deleteAccount,
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
                  Divider(thickness: 1, color: Colors.grey), // Thin separator
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
              onPressed: () {}, // Leave empty for News section
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
