import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatebubukView extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String description;
  final String location;
  final bool status;
  final String imageUrl;
  final double harga100gr;
  final double harga200gr;
  final double harga300gr;
  final double harga500gr;
  final double harga1000gr;

  CreatebubukView({
    required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.description = '',
    this.location = '',
    this.status = true,
    this.imageUrl = '',
    this.harga100gr = 0.0,
    this.harga200gr = 0.0,
    this.harga300gr = 0.0,
    this.harga500gr = 0.0,
    this.harga1000gr = 0.0,
  });

  @override
  _CreateBubukViewState createState() => _CreateBubukViewState();
}

class _CreateBubukViewState extends State<CreatebubukView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerHarga100gr = TextEditingController();
  final TextEditingController controllerHarga200gr = TextEditingController();
  final TextEditingController controllerHarga300gr = TextEditingController();
  final TextEditingController controllerHarga500gr = TextEditingController();
  final TextEditingController controllerHarga1000gr = TextEditingController();
  final TextEditingController controllerImageUrl = TextEditingController();

  bool isLoading = false;
  bool status = true;
  String? selectedLocation;
  File? selectedImageFile;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _fetchDocumentData();
    }
  }

  Future<void> _fetchDocumentData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot doc =
          await firestore.collection('bubukkopi').doc(widget.documentId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        controllerName.text = data['name'] ?? '';
        controllerDescription.text = data['description'] ?? '';
        controllerHarga100gr.text = data['harga100gr'].toString();
        controllerHarga200gr.text = data['harga200gr'].toString();
        controllerHarga300gr.text = data['harga300gr'].toString();
        controllerHarga500gr.text = data['harga500gr'].toString();
        controllerHarga1000gr.text = data['harga1000gr'].toString();
        controllerImageUrl.text = data['imageUrl'] ?? '';
        status = data['status'] ?? true;

        // Set the selected location, defaulting if not found
        selectedLocation =
            data['location'] ?? 'Pasar Tambak Rejo, Surabaya'; // Default value
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
        widget.isEdit ? 'Edit Coffee Powder Menu' : 'Add Coffee Powder Menu',
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Warna latar belakang abu-abu
            borderRadius: BorderRadius.circular(15), // Sudut membulat
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
              _buildTextField(controllerHarga100gr, 'Harga 100gr', true,
                  keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildTextField(controllerHarga200gr, 'Harga 200gr', true,
                  keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildTextField(controllerHarga300gr, 'Harga 300gr', true,
                  keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildTextField(controllerHarga500gr, 'Harga 500gr', true,
                  keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildTextField(controllerHarga1000gr, 'Harga 1000gr', true,
                  keyboardType: TextInputType.number),
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
    bottomNavigationBar: _buildBottomNavigationBar(), // Bottom navigation tetap sama
  );
}


  Widget _buildTextField(
      TextEditingController controller, String label, bool isNumeric,
      {TextInputType keyboardType = TextInputType.text}) {
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
      items: [
        'Pasar Tambak Rejo, Surabaya',
        'CitraLand CBD Boulevard, Surabaya',
      ].map<DropdownMenuItem<String>>((String location) {
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

      final sanitizedControllerName = controllerName.text
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .replaceAll(' ', '_');

      // Generate a unique file name based on the documentId and current timestamp
      final String fileName =
          '$sanitizedControllerName-${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the file to Supabase Storage bucket 'minuman_pictures'
      await supabase.storage
          .from('bubuk_pictures')
          .uploadBinary(fileName, fileBytes);

      // Generate the public URL for the uploaded image
      final publicUrl =
          supabase.storage.from('bubuk_pictures').getPublicUrl(fileName);
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
                style:
                    TextStyle(color: Colors.white), // Set text color to white
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

  Future<void> _saveData() async {
    final supabase = Supabase.instance.client;

    // Validasi input menggunakan regex
    final namePattern =
        RegExp(r'^[a-zA-Z0-9\s]+$'); // Hanya huruf, angka, dan spasi
    final pricePattern =
        RegExp(r'^\d+(\.\d+)?$'); // Hanya angka desimal atau integer

    // Cek validasi untuk field nama
    if (controllerName.text.isEmpty ||
        !namePattern.hasMatch(controllerName.text)) {
      Get.snackbar(
        'Error',
        'Name must only contain letters and numbers and cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Cek validasi untuk field deskripsi
    if (controllerDescription.text.isEmpty ||
        !namePattern.hasMatch(controllerDescription.text)) {
      Get.snackbar(
        'Error',
        'Description must only contain letters and numbers and cannot be empty',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Cek validasi untuk harga
    final List<TextEditingController> priceControllers = [
      controllerHarga100gr,
      controllerHarga200gr,
      controllerHarga300gr,
      controllerHarga500gr,
      controllerHarga1000gr,
    ];

    for (var controller in priceControllers) {
      if (controller.text.isEmpty || !pricePattern.hasMatch(controller.text)) {
        Get.snackbar(
          'Error',
          'All price fields must only contain valid numbers and cannot be empty',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Cek apakah nama sudah ada di Firestore
      final querySnapshot = await firestore
          .collection('bubukkopi')
          .where('name', isEqualTo: controllerName.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Jika dokumen sudah ada dan bukan dokumen yang sedang diedit
        if (!widget.isEdit ||
            (widget.isEdit &&
                querySnapshot.docs.first.id != widget.documentId)) {
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
        final response = await supabase.storage.from('bubuk_pictures').list();
        final existingFiles = response.map((file) => file.name).toList();

        // Cari dan hapus file lama berdasarkan nama
        for (var fileName in existingFiles) {
          if (fileName.startsWith('$sanitizedControllerName-')) {
            try {
              await supabase.storage.from('bubuk_pictures').remove([fileName]);
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
      // Data untuk disimpan
      Map<String, dynamic> data = {
        'name': controllerName.text,
        'description': controllerDescription.text,
        'harga100gr': double.parse(controllerHarga100gr.text),
        'harga200gr': double.parse(controllerHarga200gr.text),
        'harga300gr': double.parse(controllerHarga300gr.text),
        'harga500gr': double.parse(controllerHarga500gr.text),
        'harga1000gr': double.parse(controllerHarga1000gr.text),
        'location': selectedLocation,
        'status': status,
        'imageUrl': finalImageUrl,
      };

      if (widget.isEdit) {
        // Update dokumen yang sudah ada
        await firestore
            .collection('bubukkopi')
            .doc(widget.documentId)
            .update(data);
      } else {
        // Tambahkan dokumen baru
        await firestore.collection('bubukkopi').add(data);
      }

      Get.snackbar(
        'Success',
        'Data saved successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(Routes.ADMINHOME); // Kembali ke halaman utama admin
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
          // Ikon untuk menambah menu minuman tanpa latar belakang
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.CREATEMINUMAN);
            },
            icon: Icon(
              Icons.local_cafe, // Ikon untuk menambah menu minuman
              color: Colors.grey[800], // Ubah warna ikon menjadi grey
            ),
            tooltip: 'Add Minuman Menu',
          ),
          // Ikon untuk menambah menu bubuk kopi dengan latar belakang bulat
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content: const Text(
                            'Anda sudah berada di halaman Add Coffee Powder'),
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
                  Icons.grain, // Ikon untuk menambah menu bubuk kopi
                  color: Colors.white, // Warna ikon putih
                ),
                tooltip: 'Add Bubuk Menu',
              ),
            ],
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
