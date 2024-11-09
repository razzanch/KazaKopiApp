import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/routes/app_pages.dart';

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
      DocumentSnapshot doc = await firestore.collection('bubukkopi').doc(widget.documentId).get();
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
        selectedLocation = data['location'] ?? 'Pasar Tambak Rejo, Surabaya'; // Default value
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
    widget.isEdit ? 'Edit Coffee Powder Menu' : 'Add Coffee Powder Menu',
    textAlign: TextAlign.left,
    style: TextStyle(color: Colors.white), // Mengatur warna teks menjadi putih
  ),
  backgroundColor: Colors.teal,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
  ),
  centerTitle: false,
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
              _buildTextField(controllerHarga100gr, 'Harga 100gr', true, keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildTextField(controllerHarga200gr, 'Harga 200gr', true, keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildTextField(controllerHarga300gr, 'Harga 300gr', true, keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildTextField(controllerHarga500gr, 'Harga 500gr', true, keyboardType: TextInputType.number),
              SizedBox(height: 12.0),
              _buildTextField(controllerHarga1000gr, 'Harga 1000gr', true, keyboardType: TextInputType.number),
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
                  controllerImageUrl.text = 'assets/BK1.png';
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Image.asset('assets/BK1.png', width: 50, height: 50),
                    SizedBox(width: 10),
                    Text('Robusta Dampit'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controllerImageUrl.text = 'assets/BK2.png';
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Image.asset('assets/BK2.png', width: 50, height: 50),
                    SizedBox(width: 10),
                    Text('Robusta Black'),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  controllerImageUrl.text = 'assets/BK3.png';
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Image.asset('assets/BK3.png', width: 50, height: 50),
                    SizedBox(width: 10),
                    Text('Arabica White'),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  controllerImageUrl.text = 'assets/BK4.png';
                  Navigator.of(context).pop();
                },
                child: Row(
                  children: [
                    Image.asset('assets/BK4.png', width: 50, height: 50),
                    SizedBox(width: 10),
                    Text('Arabica Black'),
                  ],
                ),
              ),
              // Add more options as needed
            ],
          ),
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


  Future<void> _saveData() async {
  setState(() {
    isLoading = true;
  });

  Map<String, dynamic> data = {
    'name': controllerName.text,
    'description': controllerDescription.text,
    'harga100gr': double.tryParse(controllerHarga100gr.text) ?? 0.0,
    'harga200gr': double.tryParse(controllerHarga200gr.text) ?? 0.0,
    'harga300gr': double.tryParse(controllerHarga300gr.text) ?? 0.0,
    'harga500gr': double.tryParse(controllerHarga500gr.text) ?? 0.0,
    'harga1000gr': double.tryParse(controllerHarga1000gr.text) ?? 0.0,
    'location': selectedLocation,
    'status': status,
    'imageUrl': controllerImageUrl.text,
  };

  try {
    if (widget.isEdit) {
      // Update existing document
      await firestore.collection('bubukkopi').doc(widget.documentId).update(data);
    } else {
      // Create new document
      await firestore.collection('bubukkopi').add(data);
    }

    // Success snackbar
    Get.snackbar(
      'Success',
      'Data saved successfully',
      backgroundColor: Colors.green, // Green background
      colorText: Colors.white, // White text color
      snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
    );

    Get.offAllNamed(Routes.ADMINHOME); // Navigate back after saving
  } catch (e) {
    Get.snackbar('Error', 'Failed to save data: $e');
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
                      content: const Text('Anda sudah berada di halaman Add Coffee Powder'),
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
