import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/routes/app_pages.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
  title: Text(
    widget.isEdit ? 'Edit Coffee Drink Menu' : 'Add Coffee Drink Menu',
    textAlign: TextAlign.left,
    style: TextStyle(color: Colors.white), // Mengatur warna teks menjadi putih
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
      bottomNavigationBar: _buildBottomNavigationBar(), // This should remain as you have it
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
      onTap: _showImageSelectionDialog,
      child: AbsorbPointer(
        child: TextField(
          controller: controllerImageUrl,
          decoration: InputDecoration(
            labelText: 'Image URL',
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

  void _showImageSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose One'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  controllerImageUrl.text = 'assets/M1.png';
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Image.asset('assets/M1.png', width: 50, height: 50),
                    SizedBox(width: 10),
                    Text('Kopi Susu Reguler'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controllerImageUrl.text = 'assets/M2.png';
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Image.asset('assets/M2.png', width: 50, height: 50),
                    SizedBox(width: 10),
                    Text('Kopi Susu Gula Aren'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controllerImageUrl.text = 'assets/M3.png';
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Image.asset('assets/M3.png', width: 50, height: 50),
                    SizedBox(width: 10),
                    Text('Creamy Signature'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controllerImageUrl.text = 'assets/M4.png';
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Image.asset('assets/M4.png', width: 50, height: 50),
                    SizedBox(width: 10),
                    Text('Chocolate'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
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
  if (controllerName.text.isNotEmpty &&
      controllerDescription.text.isNotEmpty &&
      controllerPriceLarge.text.isNotEmpty &&
      controllerPriceSmall.text.isNotEmpty &&
      selectedLocation != null) {
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.isEdit) {
        await firestore.collection('minuman').doc(widget.documentId).update({
          'name': controllerName.text,
          'description': controllerDescription.text,
          'location': selectedLocation,
          'hargalarge': double.parse(controllerPriceLarge.text),
          'hargasmall': double.parse(controllerPriceSmall.text),
          'status': status,
          'imageUrl': controllerImageUrl.text,
        });
      } else {
        await firestore.collection('minuman').add({
          'name': controllerName.text,
          'description': controllerDescription.text,
          'location': selectedLocation,
          'hargalarge': double.parse(controllerPriceLarge.text),
          'hargasmall': double.parse(controllerPriceSmall.text),
          'status': status,
          'imageUrl': controllerImageUrl.text,
        });
      }

      // Success snackbar
      Get.snackbar(
        'Success',
        'Data saved successfully',
        backgroundColor: Colors.green, // Green background
        colorText: Colors.white, // White text
        snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
      );

      // Navigate back after saving
      Get.offAllNamed(Routes.ADMINHOME);
    } catch (e) {
      // Handle error
      Get.snackbar('Error', 'Failed to save data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  } else {
    Get.snackbar('Error', 'Please fill in all fields');
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