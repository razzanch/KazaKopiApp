import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminvoucherView extends StatefulWidget {
  @override
  _AdminvoucherViewState createState() => _AdminvoucherViewState();
}

class _AdminvoucherViewState extends State<AdminvoucherView> {
  final TextEditingController _voucherNameController = TextEditingController();
  final TextEditingController _voucherValueController = TextEditingController();
  final TextEditingController _minPurchaseController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  File? selectedImageFile;
  DateTime? selectedExpiryDate;

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
          _imageController.text = pickedFile.path;
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
                        icon: Icon(Icons.photo_library,
                            color: Colors.teal, size: 40),
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
                        icon: Icon(Icons.camera_alt,
                            color: Colors.teal, size: 40),
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

  Future<String?> uploadImageToSupabase(
      File imageFile, String voucherName) async {
    try {
      final supabase = Supabase.instance.client;
      final fileBytes = await imageFile.readAsBytes();

      // Bersihkan nama voucher untuk memastikan hanya karakter yang valid
      final sanitizedVoucherName =
          voucherName.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');

      // Gunakan nama voucher dalam nama file
      final String fileName = 'voucher-${sanitizedVoucherName}.jpg';

      // Upload file ke Supabase
      await supabase.storage
          .from('voucher_pictures')
          .uploadBinary(fileName, fileBytes);

      // Dapatkan URL publik
      final publicUrl =
          supabase.storage.from('voucher_pictures').getPublicUrl(fileName);
      return publicUrl;
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image');
      return null;
    }
  }

  void _selectExpiryDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedExpiryDate = DateTime(pickedDate.year, pickedDate.month,
              pickedDate.day, pickedTime.hour, pickedTime.minute);
          _expiryDateController.text =
              '${selectedExpiryDate?.toLocal()}'.split(' ')[0] +
                  ' ${pickedTime.format(context)}';
        });
      }
    }
  }

  void _activateVoucher() async {
    final voucherNamePattern = RegExp(r'^[a-zA-Z0-9%\s]*$');
    final voucherValuePattern = RegExp(r'^\d+(\.\d+)?\$?$');
    final minPurchasePattern = RegExp(r'^\d+\$?$');

    if (_voucherNameController.text.isEmpty ||
        !voucherNamePattern.hasMatch(_voucherNameController.text)) {
      Get.snackbar('Error',
          'Voucher Name can only contain letters, numbers, %, and spaces.');
      return;
    }

    if (_voucherValueController.text.isEmpty ||
        !voucherValuePattern.hasMatch(_voucherValueController.text)) {
      Get.snackbar('Error', 'Voucher Value must be a valid number.');
      return;
    }

    if (_minPurchaseController.text.isEmpty ||
        !minPurchasePattern.hasMatch(_minPurchaseController.text)) {
      Get.snackbar('Error', 'Minimum Purchase must be a valid integer.');
      return;
    }

    if (selectedExpiryDate == null) {
      Get.snackbar('Error', 'Please select an expiry date.');
      return;
    }

    // Pengecekan voucherName di Firestore
    final querySnapshot = await FirebaseFirestore.instance
        .collection('voucher')
        .where('voucherName', isEqualTo: _voucherNameController.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      Get.snackbar('Error', 'Voucher with this name already exists.');
      return;
    }

    String? imageUrl;
    if (selectedImageFile != null) {
      imageUrl = await uploadImageToSupabase(
          selectedImageFile!, _voucherNameController.text);
    }

    try {
      await FirebaseFirestore.instance.collection('voucher').add({
        'voucherName': _voucherNameController.text,
        'voucherValue': double.parse(_voucherValueController.text),
        'minPurchase': int.parse(_minPurchaseController.text),
        'expiryDate': selectedExpiryDate?.toIso8601String(),
        'imageUrl': imageUrl,
      });

      Get.snackbar('Success', 'Voucher activated successfully.',
          backgroundColor: Colors.green, colorText: Colors.white);
      setState(() {
        _voucherNameController.clear();
        _voucherValueController.clear();
        _minPurchaseController.clear();
        _expiryDateController.clear();
        selectedImageFile = null;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to activate voucher: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
  title: Text(
    'Voucher Management',
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
  iconTheme: IconThemeData(
    color: Colors.white, // Mengatur warna ikon back menjadi putih
    
  ),
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
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    GestureDetector(
      onTap: () {
        // Tambahkan logika navigasi ke halaman daftar voucher
        Get.toNamed(Routes.ADMINLISTVC);
      },
      child: Text(
        'See Available Discount Vouchers',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.teal, // Warna teal untuk teks
        ),
      ),
    ),
    IconButton(
      icon: Icon(Icons.local_offer, color: Colors.teal), // Ikon tetap teal
      onPressed: () {
        // Tambahkan logika navigasi ke halaman daftar voucher
        Get.toNamed(Routes.ADMINLISTVC);
      },
    ),
  ],
),

                SizedBox(height: 20),
                TextField(
                  controller: _voucherNameController,
                  decoration: InputDecoration(
                    labelText: 'Voucher Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _voucherValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Voucher Value (In Decimal)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _minPurchaseController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Minimum Purchase (In Integer)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _expiryDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onTap: _selectExpiryDate,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: TextEditingController(
                      text: selectedImageFile?.path ?? 'Tap to choose image'),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Voucher Image',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onTap: () {
                    _pickImage(context);
                  },
                ),
                SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _activateVoucher,
                      child: Text(
                        'Activate Voucher',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
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
