import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportView extends StatefulWidget {
  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
    String? urlImage; // Variabel untuk menyimpan URL gambar pengguna
  final String defaultImage = 'assets/LOGO.png';
final ProfileController profileController = Get.put(ProfileController());

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageController = TextEditingController(); // Untuk menampilkan path gambar
  File? selectedImageFile;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _usernameController.text = userDoc['username'] ?? '';
            _emailController.text = userDoc['email'] ?? '';
            _uidController.text = userDoc['uid'] ?? '';
          });
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch user data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

 void _pickImage(BuildContext context) {
    _showImageSourceDialog(context);
  }

  void pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          selectedImageFile = File(pickedFile.path);
          _imageController.text = pickedFile.path; // Menampilkan path lokal di TextField
        });
      } else {
        Get.snackbar('Error', 'No image selected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick an image');
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Image Source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo_library, color: Colors.teal, size: 40),
                        onPressed: () {
                          Navigator.pop(context);
                          pickImage(ImageSource.gallery);
                        },
                      ),
                      Text('Gallery', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.teal, size: 40),
                        onPressed: () {
                          Navigator.pop(context);
                          pickImage(ImageSource.camera);
                        },
                      ),
                      Text('Camera', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> uploadImageToSupabase(File imageFile, String uid) async {
  try {
    final supabase = Supabase.instance.client;

    // Read the image bytes
    final fileBytes = await imageFile.readAsBytes();

    // Generate a unique file name based on UID and current timestamp
    final String fileName = '$uid-${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Upload the file to Supabase Storage bucket 'report_pictures'
    await supabase.storage.from('report_pictures').uploadBinary(fileName, fileBytes);

    // Generate the public URL for the uploaded image
    final publicUrl = supabase.storage.from('report_pictures').getPublicUrl(fileName);
    print("Uploaded Image URL: $publicUrl");

    return publicUrl;

  } catch (e) {
    print('Error uploading image: $e');
    Get.snackbar('Error', 'Failed to upload image');
    return null;
  }
}


  void _sendReport() async {
  final validPattern = RegExp(r'^[a-zA-Z0-9.()\s]*$'); // Validasi huruf, angka, ., ), spasi, dan enter

  if (_titleController.text.isEmpty || !validPattern.hasMatch(_titleController.text)) {
    Get.snackbar(
      'Error',
      'Title can only contain letters, numbers, ., ), spaces, and enter.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  if (_contentController.text.isEmpty || !validPattern.hasMatch(_contentController.text)) {
    Get.snackbar(
      'Error',
      'Content can only contain letters, numbers, ., ), spaces, and enter.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    return;
  }

  String? imageUrl;

  if (selectedImageFile != null) {
    imageUrl = await uploadImageToSupabase(selectedImageFile!, _uidController.text);
  }

  try {
     String documentId = '${_uidController.text}_${_titleController.text}'; // Menggabungkan UID dan Title
    await FirebaseFirestore.instance.collection('report').doc(documentId).set({
      'username': _usernameController.text,
      'email': _emailController.text,
      'uid': _uidController.text,
      'title': _titleController.text,
      'content': _contentController.text,
      'imageUrl': imageUrl, // Simpan URL gambar jika ada
      'timestamp': FieldValue.serverTimestamp(),
    });

    Get.snackbar(
      'Success',
      'Your report has been submitted successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    setState(() {
      _titleController.clear();
      _contentController.clear();
      selectedImageFile = null; // Reset gambar setelah berhasil submit
      FocusScope.of(context).unfocus();
    });
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to send report: ${e.toString()}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.teal,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.toNamed(Routes.HELPCENTER);
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() {
              final imagePath = profileController.selectedImagePath.value;

              return CircleAvatar(
                radius: 20,
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Responses to your report will be sent to your email by the Kazakopi Nusantara team.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _usernameController,
                  readOnly: true,
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
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _uidController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'UID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _contentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30),
TextField(
  controller: TextEditingController(
      text: selectedImageFile?.path ?? 'Tap to choose image'),
  readOnly: true,
  decoration: InputDecoration(
    labelText: 'Report Image',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  onTap: () {
    _pickImage(context); // Buka dialog untuk memilih gambar
  },
),

             SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _sendReport,
                      child: Text(
                        'Send Your Report',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
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
        ),
      ),

    );
  }
}
