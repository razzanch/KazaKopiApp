import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Profile Picture',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: controller.availableImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.updateSelectedImage(
                              controller.availableImages[index]);
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage(controller.availableImages[index]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateProfile() {
    if (controller.nameController.text.isEmpty ||
        controller.phoneNumberController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }
    controller.updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Profile',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold), // Set text color to white
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.teal,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.toNamed(Routes.MAINPROFILE);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Margin kiri, kanan, dan atas
    child: Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Warna Container menjadi grey[300]
        borderRadius: BorderRadius.circular(10), // Sudut melengkung
      ),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: 10),
                Obx(() => CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(controller.selectedImagePath.value),
                    )),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => _showImagePickerDialog(context),
                  child: Text(
                    'Choose Profile Picture',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username TextField
                TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 10),
                // Phone Number TextField
                TextField(
                  controller: controller.phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _updateProfile,
                      child: Text(
                        'Update Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(color: Colors.grey), // Garis pembatas di bawah tombol
          SizedBox(height: 10),
          Text(
            '*Note: After updating your profile information, the old account information will be lost.',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  ),
),
    );
  }
}
