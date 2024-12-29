import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateminumanView extends StatefulWidget {
  final bool isEdit;
  final String documentId;

  CreateminumanView({
    required this.isEdit,
    this.documentId = '',
  });

  @override
  _CreateminumanViewState createState() => _CreateminumanViewState();
}

class _CreateminumanViewState extends State<CreateminumanView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerPriceLarge = TextEditingController();
  final TextEditingController controllerPriceSmall = TextEditingController();
  final TextEditingController controllerImageUrl = TextEditingController();

  bool isLoading = false;
  bool status = true;
  String? selectedLocation;
  File? selectedImageFile;

  final List<String> locations = [
    'Pasar Tambak Rejo, Surabaya',
    'CitraLand CBD Boulevard, Surabaya',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _fetchDocumentData(); // Fetch data when in edit mode
    }
  }

  Future<void> _fetchDocumentData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot document = await firestore.collection('minuman').doc(widget.documentId).get();
      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        controllerName.text = data['name'] ?? '';
        controllerDescription.text = data['description'] ?? '';
        controllerPriceLarge.text = data['hargalarge'].toString();
        controllerPriceSmall.text = data['hargasmall'].toString();
        controllerImageUrl.text = data['imageUrl'] ?? '';
        status = data['status'] ?? true;

        // Ensure selectedLocation is a valid location
        if (locations.contains(data['location'])) {
          selectedLocation = data['location'];
        } else {
          selectedLocation = locations.first;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[300],
    appBar: AppBar(
      title: Text(
        widget.isEdit ? 'Edit Coffee Drink Menu' : 'Add Coffee Drink Menu',
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.teal,
      centerTitle: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      automaticallyImplyLeading: false,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Warna latar belakang abu-abu
            borderRadius: BorderRadius.circular(15), // Radius untuk sudut
          ),
          padding: const EdgeInsets.all(16.0), // Padding di dalam Container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16.0),
              _buildTextField(controllerName, 'Nama', false),
              SizedBox(height: 12.0),
              _buildTextField(controllerDescription, 'Deskripsi', false),
              SizedBox(height: 12.0),
              _buildLocationDropdown(), // Dropdown untuk lokasi
              SizedBox(height: 12.0),
              _buildTextField(controllerPriceLarge, 'Harga Ukuran Besar', true, keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildTextField(controllerPriceSmall, 'Harga Ukuran Kecil', true, keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildImageUrlField(), // Updated field for Image URL
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(30.0),
                    isSelected: [status, !status],
                    selectedColor: Colors.white,
                    fillColor: status ? Colors.teal : Colors.red,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text("Tersedia", style: TextStyle(fontSize: 16.0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text("Habis", style: TextStyle(fontSize: 16.0)),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        status = index == 0;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: _buildBottomNavigationBar(), // Bottom navigation tetap seperti sebelumnya
  );
}


  Widget _buildTextField(TextEditingController controller, String label, bool isNumeric, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
      style: TextStyle(fontSize: 18.0, color: Colors.black),
      keyboardType: isNumeric ? keyboardType : TextInputType.text,
    );
  }

   Widget _buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedLocation,
      onChanged: (String? newValue) {
        setState(() {
          selectedLocation = newValue!;
        });
      },
      items: locations.map<DropdownMenuItem<String>>((String location) {
        return DropdownMenuItem<String>(
          value: location,
          child: Text(location),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Lokasi',
        labelStyle: TextStyle(color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.teal),
        ),
      ),
      style: TextStyle(fontSize: 18.0, color: Colors.black),
    );
  }

  Widget _buildImageUrlField() {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: AbsorbPointer(
        child: TextField(
          controller: controllerImageUrl,
          decoration: InputDecoration(
            labelText: 'Gambar Produk',
            labelStyle: TextStyle(color: Colors.teal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.teal),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.teal),
            ),
          ),
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ),
    );
  }

  void _pickImage(BuildContext context) {
  _showImageSourceDialog(context);
}

void pickImage(ImageSource source) async {
  try {
    final picker = ImagePicker();

    // Ambil gambar dari sumber yang dipilih
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedImageFile = File(pickedFile.path); // Update file yang dipilih
        controllerImageUrl.text = pickedFile.path; // Tampilkan path lokal
      });
    } else {
      Get.snackbar('Error', 'No image selected');
    }
  } catch (e) {
    print('Error picking image: $e');
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
                        Navigator.pop(context); // Tutup dialog
                        pickImage(ImageSource.gallery); // Pilih galeri
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
                        Navigator.pop(context); // Tutup dialog
                        pickImage(ImageSource.camera); // Pilih kamera
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



Future<String?> uploadImageToSupabase(File imageFile) async {
  try {
    final supabase = Supabase.instance.client;

    // Read the image bytes
    final fileBytes = await imageFile.readAsBytes();

    // Generate a sanitized version of the name from the TextField
    final sanitizedControllerName = controllerName.text.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_');

    // Generate a unique file name based on the sanitized name and current timestamp
    final String fileName = '$sanitizedControllerName-${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Upload the file to Supabase Storage bucket 'minuman_pictures'
    await supabase.storage.from('minuman_pictures').uploadBinary(fileName, fileBytes);

    // Generate the public URL for the uploaded image
    final publicUrl = supabase.storage.from('minuman_pictures').getPublicUrl(fileName);
    print("Uploaded Image URL: $publicUrl");

    return publicUrl;

  } catch (e) {
    print('Error uploading image: $e');
    Get.snackbar('Error', 'Failed to upload image');
    return null;
  }
}


  Widget _buildSaveButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _saveData,
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(
              widget.isEdit ? 'Update' : 'Save',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    ),
  );
}

void _saveData() async {
  final supabase = Supabase.instance.client;

  // Validasi input menggunakan regex
  final namePattern = RegExp(r'^[a-zA-Z0-9\s]+$');
  final descriptionPattern = RegExp(r'^[a-zA-Z0-9\s]+$');
  final pricePattern = RegExp(r'^\d+(\.\d+)?$');

  if (controllerName.text.isEmpty ||
      controllerDescription.text.isEmpty ||
      controllerPriceLarge.text.isEmpty ||
      controllerPriceSmall.text.isEmpty ||
      selectedLocation == null) {
    Get.snackbar(
      'Error',
      'Please fill in all fields',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  if (!namePattern.hasMatch(controllerName.text)) {
    Get.snackbar(
      'Error',
      'Name can only contain letters and numbers',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  if (!descriptionPattern.hasMatch(controllerDescription.text)) {
    Get.snackbar(
      'Error',
      'Description can only contain letters and numbers',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  if (!pricePattern.hasMatch(controllerPriceLarge.text) ||
      !pricePattern.hasMatch(controllerPriceSmall.text)) {
    Get.snackbar(
      'Error',
      'Price must be a valid number',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    // Cek duplikasi nama di Firestore
    final querySnapshot = await firestore
        .collection('minuman')
        .where('name', isEqualTo: controllerName.text)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      if (!widget.isEdit || (widget.isEdit && querySnapshot.docs.first.id != widget.documentId)) {
        Get.snackbar(
          'Error',
          'Name already exists in the collection',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    // Upload gambar jika diperlukan
    String? finalImageUrl = controllerImageUrl.text;

    if (widget.isEdit && selectedImageFile != null) {
      // Sanitasi nama file
      final sanitizedControllerName = controllerName.text
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .replaceAll(' ', '_');

      // List file yang ada di bucket Supabase
      final response = await supabase.storage.from('minuman_pictures').list();
      final existingFiles = response.map((file) => file.name).toList();

      // Cari dan hapus file lama berdasarkan nama
      for (var fileName in existingFiles) {
        if (fileName.startsWith('$sanitizedControllerName-')) {
          try {
            await supabase.storage.from('minuman_pictures').remove([fileName]);
            print("Deleted old file: $fileName");
          } catch (e) {
            print("Error deleting file: $e");
            Get.snackbar(
              'Error',
              'Failed to delete old image',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            setState(() {
              isLoading = false;
            });
            return;
          }
        }
      }

      // Upload file baru
      finalImageUrl = await uploadImageToSupabase(selectedImageFile!);
      if (finalImageUrl == null) {
        Get.snackbar(
          'Error',
          'Failed to upload new image',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        setState(() {
          isLoading = false;
        });
        return;
      }
    }

    if (!widget.isEdit && selectedImageFile != null) {
        finalImageUrl = await uploadImageToSupabase(selectedImageFile!);
        if (finalImageUrl == null) {
          Get.snackbar(
            'Error',
            'Failed to upload new image',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          setState(() {
            isLoading = false;
          });
          return;
        }
      }

    // Data yang akan disimpan
    final data = {
      'name': controllerName.text,
      'description': controllerDescription.text,
      'location': selectedLocation,
      'hargalarge': double.parse(controllerPriceLarge.text),
      'hargasmall': double.parse(controllerPriceSmall.text),
      'status': status,
      'imageUrl': finalImageUrl, // URL final setelah upload
    };

    if (widget.isEdit) {
      await firestore.collection('minuman').doc(widget.documentId).update(data);
    } else {
      await firestore.collection('minuman').add(data);
    }

    Get.snackbar(
      'Success',
      'Data saved successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.offAllNamed(Routes.ADMINHOME);
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to save data: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}









  Widget _buildBottomNavigationBar() {
  return Container(
    height: 50,
    color: const Color.fromARGB(255, 255, 255, 255),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Ikon Home untuk navigasi ke halaman admin home
        IconButton(
          onPressed: () {
            Get.toNamed(Routes.ADMINHOME); // Rute ke halaman AdminHome
          },
          icon: Icon(
            Icons.home,
            color: Colors.grey[800],
          ),
          tooltip: 'Home',
        ),
        // Ikon untuk menambah menu minuman dengan latar belakang bulat
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[800], // Warna latar belakang
              ),
              width: 50,
              height: 50,
            ),
            IconButton(
              onPressed: () {
                // Menampilkan dialog peringatan
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Warning'),
                      content: const Text('Anda sudah berada di halaman Add Coffee Drink'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Get.back(); // Menutup dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.local_cafe, // Ikon untuk menambah menu minuman
                color: Colors.white, // Warna ikon putih
              ),
              tooltip: 'Add Minuman Menu',
            ),
          ],
        ),
        // Ikon untuk menambah menu bubuk kopi
        IconButton(
          onPressed: () {
            Get.toNamed(Routes.CREATEBUBUK); // Rute ke halaman CreateBubuk
          },
          icon: Icon(
            Icons.grain, // Ikon untuk menambah menu bubuk kopi
            color: Colors.grey[800],
          ),
          tooltip: 'Add Bubuk Menu',
        ),
         IconButton(
              onPressed: () {
               Get.toNamed(Routes.ADMINHELPCENTER);
              },
              icon: Icon(
                Icons.support_agent,
                color: Colors.grey[800],
              ),
              tooltip: 'Help Center',
            ),
        // Ikon Management Order tanpa latar belakang
        IconButton(
          onPressed: () {
            Get.toNamed(Routes.ADMINORDER); // Rute ke halaman AdminOrder
            //)
          },
          icon: Icon(
            Icons.assignment, // Ikon untuk management order
            color: Colors.grey[800], // Ubah warna ikon menjadi grey
          ),
          tooltip: 'Management Order',
        ),
      ],
    ),
  );
}
}