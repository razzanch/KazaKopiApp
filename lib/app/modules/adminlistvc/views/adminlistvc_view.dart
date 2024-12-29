import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminlistvcView extends StatefulWidget {
  @override
  _AdminlistvcViewState createState() => _AdminlistvcViewState();
}

class _AdminlistvcViewState extends State<AdminlistvcView> {
  DateTime? selectedDateFilter; // Variabel untuk menyimpan tanggal yang dipilih
  DateTime? selectedDate;
  File? selectedImageFile;
  TextEditingController _imageController = TextEditingController();

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
          child: Column(
            children: [
              // Filter tanggal
              GestureDetector(
                onTap: () async {
                  await _showDateSelectionDialog();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDateFilter == null
                            ? 'All Date'
                            : DateFormat('MMMM d, yyyy').format(selectedDateFilter!),
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.date_range, color: Colors.teal),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Tombol "Show All Vouchers"
             if (selectedDateFilter != null)
  GestureDetector(
    onTap: () {
      setState(() {
        selectedDateFilter = null; // Set null untuk menampilkan semua voucher
      });
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white, // Warna putih untuk background
        borderRadius: BorderRadius.circular(8), // Border radius
        border: Border.all(color: Colors.teal, width: 1), // Border dengan warna teal
      ),
      child: Text(
        'Show All Vouchers',
        style: TextStyle(
          color: Colors.teal, // Warna teks teal
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  ),

              SizedBox(height: 16),
              // Daftar voucher
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildVoucherList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDateSelectionDialog() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDateFilter = picked;
      });
    }
  }
Widget _buildVoucherList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('voucher').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'No vouchers available.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      // Filter berdasarkan tanggal jika selectedDate tidak null
      var filteredDocs = snapshot.data!.docs.where((doc) {
        var data = doc.data() as Map<String, dynamic>;
        if (selectedDateFilter == null) return true; // Tampilkan semua jika tanggal tidak dipilih

        String? expiryDateString = data['expiryDate'];
        if (expiryDateString == null) return false;

        DateTime expiryDate = DateFormat('yyyy-MM-dd').parse(expiryDateString);
        return expiryDate == selectedDateFilter;
      }).toList();

      if (filteredDocs.isEmpty) {
        return Center(
          child: Text(
            'No vouchers match the selected date.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredDocs.length,
        itemBuilder: (context, index) {
          var doc = filteredDocs[index];
          var data = doc.data() as Map<String, dynamic>;

          return Card(
  margin: EdgeInsets.symmetric(vertical: 8.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  // Menambahkan warna card berdasarkan tanggal kadaluarsa
  color: _isExpired(data['expiryDate']) ? Colors.black : Colors.white,
  elevation: 4,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Gambar di bagian atas
      Image(
        image: (data['imageUrl'] ?? '').startsWith('http')
            ? NetworkImage(data['imageUrl'])
            : AssetImage('assets/default.png') as ImageProvider,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/default.png', 
            height: 140, 
            width: double.infinity, 
            fit: BoxFit.cover
          );
        },
      ),
      // Informasi di bawah gambar
      Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        data['voucherName'] ?? 'Unknown Voucher',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          // Mengubah warna teks jika expired
          color: _isExpired(data['expiryDate']) ? Colors.red : Colors.black,
        ),
      ),
      SizedBox(height: 5),
      Column( // Ganti Row dengan Column untuk menampilkan Expiry Date dan Expired di bawahnya
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expiry Date: ${data['expiryDate'] ?? 'N/A'}',
            style: TextStyle(
              fontSize: 14,
              color: _isExpired(data['expiryDate']) 
                  ? Colors.red 
                  : Colors.grey[600],
              fontWeight: _isExpired(data['expiryDate']) 
                  ? FontWeight.bold 
                  : FontWeight.normal,
            ),
          ),
          if (_isExpired(data['expiryDate']))
            Padding(
              padding: const EdgeInsets.only(top: 4.0), // Jarak antara Expiry Date dan Expired
              child: Text(
                '(Expired)',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    ],
  ),
),
      // Tombol actions tetap sama
      Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(doc),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteVoucher(doc.id),
            ),
          ],
        ),
      ),
    ],
  ),
);
        },
      );
    },
  );
}

bool _isExpired(String? expiryDateStr) {
  if (expiryDateStr == null) return false;
  try {
    final expiryDate = DateFormat('yyyy-MM-dd').parse(expiryDateStr);
    final now = DateTime.now();
    return expiryDate.isBefore(DateTime(now.year, now.month, now.day));
  } catch (e) {
    return false;
  }
}

Future<void> _deleteVoucher(String id) async {
  try {
    await FirebaseFirestore.instance.collection('voucher').doc(id).delete();
    Get.snackbar('Success', 'Voucher deleted successfully');
  } catch (e) {
    Get.snackbar('Error', 'Failed to delete voucher');
  }
}

Future<void> _showEditDialog(DocumentSnapshot doc) async {
    var data = doc.data() as Map<String, dynamic>;

    TextEditingController voucherNameController = TextEditingController(text: data['voucherName']);
    TextEditingController voucherValueController = TextEditingController(text: data['voucherValue'].toString());
    TextEditingController minPurchaseController = TextEditingController(text: data['minPurchase'].toString());
    TextEditingController expiryDateController = TextEditingController(text: data['expiryDate']);
    _imageController.text = data['imageUrl'];

    void _pickDate() async {
  // Menampilkan date picker untuk memilih tanggal
  DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  
  if (pickedDate != null) {
    // Menampilkan time picker untuk memilih waktu
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (pickedTime != null) {
      // Menggabungkan tanggal yang dipilih dan waktu yang dipilih menjadi DateTime
      DateTime combinedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Format tanggal dan waktu yang telah digabungkan
      expiryDateController.text = DateFormat('yyyy-MM-dd HH:mm').format(combinedDateTime);
    }
  }
}

   Future<void> _updateVoucher() async {
  String voucherName = voucherNameController.text.trim();
  double? voucherValue = double.tryParse(voucherValueController.text.trim());
  int? minPurchase = int.tryParse(minPurchaseController.text.trim());
  String expiryDate = expiryDateController.text.trim();
  String imageUrl = _imageController.text.trim();

  // Validasi input pengguna
  if (voucherName.isEmpty || voucherValue == null || minPurchase == null || expiryDate.isEmpty) {
    Get.snackbar('Error', 'Please fill in all fields with valid data');
    return;
  }

  try {
    // Pengecekan apakah ada voucher dengan voucherName yang sama di Firestore
    final voucherQuery = await FirebaseFirestore.instance
        .collection('voucher')
        .where('voucherName', isEqualTo: voucherName)
        .get();

    // Cek apakah ada dokumen lain dengan voucherName yang sama
    if (voucherQuery.docs.isNotEmpty && voucherQuery.docs.first.id != doc.id) {
      // Jika voucherName sudah ada dan bukan dokumen yang sedang diperbarui
      Get.snackbar('Error', 'Voucher name already exists');
      return;
    }

    // Hanya upload gambar jika ada file baru yang dipilih
    if (selectedImageFile != null) {
      final newImageUrl = await uploadImageToSupabase(selectedImageFile!, voucherName);
      if (newImageUrl != null) {
        imageUrl = newImageUrl;
      } else {
        Get.snackbar('Error', 'Failed to upload image');
        return;
      }
    }

    // Update dokumen dengan URL gambar yang baru atau yang lama
    await FirebaseFirestore.instance.collection('voucher').doc(doc.id).update({
      'voucherName': voucherName,
      'voucherValue': voucherValue,
      'minPurchase': minPurchase,
      'expiryDate': expiryDate,
      'imageUrl': imageUrl,
    });

    Get.snackbar('Success', 'Voucher updated successfully!');
    Navigator.of(context).pop();
  } catch (e) {
    print('Error updating voucher: $e'); // Tambahkan log error
    Get.snackbar('Error', 'Failed to update voucher: ${e.toString()}');
  }
}


    showDialog(
  context: context,
  builder: (context) => Dialog(
    backgroundColor: Colors.transparent,  // Transparansi untuk latar belakang
    insetPadding: EdgeInsets.symmetric(horizontal: 24.0), // Padding sisi
    child: Container(
      decoration: BoxDecoration(
        color: Colors.teal.shade50,  // Background teal yang lembut
        borderRadius: BorderRadius.circular(20.0),  // Sudut lebih melengkung
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),  // Bayangan lembut
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.0),
      child: SingleChildScrollView(  // Membuat konten bisa digulir
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Agar ukuran dialog fleksibel
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Voucher',  // Ganti dengan judul yang sesuai
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.teal.shade300),
            SizedBox(height: 16),
            
            // Form Fields
            TextField(
              controller: voucherNameController,
              decoration: InputDecoration(labelText: 'Voucher Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: voucherValueController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Voucher Value'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: minPurchaseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Min Purchase'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: expiryDateController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Expiry Date'),
              onTap: _pickDate,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _imageController,
              readOnly: true,
              decoration: InputDecoration(labelText: 'Image URL'),
              onTap: () => _pickImage(context),
            ),
            SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel', style: TextStyle(color: Colors.teal.shade900)),
                ),
                ElevatedButton(
                  onPressed: _updateVoucher,
                  child: Text('Update Voucher'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.teal.shade600,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);

  }

  Future<String?> uploadImageToSupabase(File imageFile, String voucherName) async {
  try {
    final supabase = Supabase.instance.client;
    final fileBytes = await imageFile.readAsBytes();

    // Tambahkan timestamp untuk menghindari nama file yang sama
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final sanitizedVoucherName = voucherName.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    final String fileName = 'voucher-${sanitizedVoucherName}-$timestamp.jpg';

    // Upload file ke Supabase dengan error handling yang lebih baik
    final response = await supabase.storage
        .from('voucher_pictures')
        .uploadBinary(fileName, fileBytes);

    if (response.isEmpty) {
      throw Exception('Upload response is empty');
    }

    // Dapatkan URL publik
    final publicUrl = supabase.storage.from('voucher_pictures').getPublicUrl(fileName);
    print('Successfully uploaded image. URL: $publicUrl'); // Tambahkan log sukses
    return publicUrl;
  } catch (e) {
    print('Error uploading image: $e'); // Tambahkan log error
    Get.snackbar('Error', 'Failed to upload image: ${e.toString()}');
    return null;
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose Image Source', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

}
