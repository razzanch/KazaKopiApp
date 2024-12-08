import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/modules/detail_bubuk/views/detail_bubuk_view.dart';
import 'package:myapp/app/modules/detail_minuman/views/detail_minuman_view.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController pageController = PageController();
  bool isMinumanSelected = true; // Menentukan tab yang aktif
  String selectedLocation =
      'Pasar Tambak Rejo, Surabaya'; // Variabel untuk lokasi yang dipilih
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? urlImage; // Variabel untuk menyimpan URL gambar pengguna
  final String defaultImage = 'assets/LOGO.png';
  final currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  final ProfileController profileController = Get.put(ProfileController());
  late stt.SpeechToText _speech; // Instance SpeechToText
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Fungsi untuk memulai speech-to-text
  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech Status: $status'),
      onError: (error) => print('Speech Error: $error'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            searchQuery = result.recognizedWords.toLowerCase();
            searchController.text = searchQuery; // Masukkan hasil ke TextField
          });
        },
      );
    } else {
      print("Speech recognition not available");
    }
  }

  // Fungsi untuk menghentikan speech-to-text
  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.teal,
  elevation: 0,
  shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
  automaticallyImplyLeading: false,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Location",
        style: TextStyle(fontSize: 14, color: Colors.white70, height: 0.8),
      ),
      DropdownButton<String>(
        value: selectedLocation,
        dropdownColor: Colors.teal,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        underline: SizedBox(),
        isDense: true,
        items: [
          DropdownMenuItem(
            value: 'Pasar Tambak Rejo, Surabaya',
            child: Text('Pasar Tambak Rejo, Surabaya'),
          ),
          DropdownMenuItem(
            value: 'CitraLand CBD Boulevard, Surabaya',
            child: Text('CitraLand CBD Boulevard, Surabaya'),
          ),
        ],
        onChanged: (newLocation) {
          setState(() {
            selectedLocation = newLocation!;
          });
        },
      ),
    ],
  ),
 actions: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: currentUser == null // Check if the user is logged in
          ? ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.LOGIN); // Navigate to login route
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                minimumSize: Size(60, 30), // Set smaller size for the button
                padding: EdgeInsets.symmetric(horizontal: 10), // Reduce padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            )
          : Obx(() {
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
  controller: searchController,
  onChanged: (value) {
    setState(() {
      searchQuery = value.toLowerCase();
    });
  },
  decoration: InputDecoration(
    hintText: 'Search',
    prefixIcon: Icon(Icons.search),
    suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    if (_isListening) {
                      _stopListening();
                    } else {
                      _startListening();
                    }
                  },
                ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
),

            ),
            // Carousel section
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: PageView(
                      controller: pageController,
                      children: [
                        Image.asset('assets/news1.png'),
                        Image.asset('assets/news2.png'),
                        Image.asset('assets/news3.png'),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                          border: Border.all(color: Colors.grey),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMinumanSelected = true; // Set Minuman aktif
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Minuman",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:
                                isMinumanSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        if (isMinumanSelected)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            height: 2,
                            width: 60,
                            color: Colors.teal,
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMinumanSelected = false; // Set Bubuk Kopi aktif
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Bubuk Kopi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:
                                !isMinumanSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                        if (!isMinumanSelected)
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            height: 2,
                            width: 60,
                            color: Colors.teal,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Kartu Minuman atau Bubuk Kopi
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isMinumanSelected
                  ? buildMinumanCards()
                  : buildBubukKopiCards(),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Color(0xFF495048), // Same color as the second example
                  ),
                  width: 50,
                  height: 50,
                ),
                IconButton(
                  onPressed: () {
                    // Show a dialog when the home icon is pressed
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content:
                              const Text('Anda sudah berada di halaman home'),
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
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  tooltip: 'Home',
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                navigateToCart(); // Change to Cart route
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.grey,
              ),
              tooltip: 'Cart',
            ),
            IconButton(
              onPressed: () {
               Get.toNamed(Routes.GETCONNECT);
              },
              icon: Icon(
                Icons.article, // Use a suitable icon for News
                color: Colors.grey,
              ),
              tooltip: 'News',
            ),
            IconButton(
              onPressed: () {
                navigateToProfile(); // Change to Profile route
              },
              icon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              tooltip: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMinumanCards() {
  return StreamBuilder<QuerySnapshot>(
    stream: firestore.collection('minuman').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      final documents = snapshot.data!.docs;

      final filteredDocuments = documents.where((doc) {
  final data = doc.data() as Map<String, dynamic>;
  final name = data['name'].toString().toLowerCase();
  return data['status'] == true &&
      data['location'] == selectedLocation &&
      (searchQuery.isEmpty || name.contains(searchQuery));
}).toList();


      if (filteredDocuments.isEmpty) {
        return Center(
          child: Text(
            'Tidak ada minuman tersedia di lokasi ini.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredDocuments.length,
        itemBuilder: (context, index) {
          final data = filteredDocuments[index].data() as Map<String, dynamic>;
          return Container(
            height: 250,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: Image(
    image: (data['imageUrl'] ?? '').startsWith('http')
        ? NetworkImage(data['imageUrl']) // Gunakan NetworkImage untuk URL
        : AssetImage('assets/default.png') as ImageProvider, // Gunakan AssetImage jika bukan URL
    height: 140,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset('assets/default.png'); // Fallback image jika gagal
    },
  ),
),
                SizedBox(height: 8),
                Text(
                  data['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => navigateToDetailMinuman(data),
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  label: Icon(Icons.arrow_forward, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
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

Widget buildBubukKopiCards() {
  return StreamBuilder<QuerySnapshot>(
    stream: firestore.collection('bubukkopi').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      final documents = snapshot.data!.docs;

final filteredDocuments = documents.where((doc) {
  final data = doc.data() as Map<String, dynamic>;
  final name = data['name'].toString().toLowerCase();
  return data['status'] == true &&
      data['location'] == selectedLocation &&
      (searchQuery.isEmpty || name.contains(searchQuery));
}).toList();

      if (filteredDocuments.isEmpty) {
        return Center(
          child: Text(
            'Tidak ada bubuk kopi tersedia di lokasi ini.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredDocuments.length,
        itemBuilder: (context, index) {
          final data = filteredDocuments[index].data() as Map<String, dynamic>;
          return Container(
            height: 250,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: Image(
    image: (data['imageUrl'] ?? '').startsWith('http')
        ? NetworkImage(data['imageUrl']) // Gunakan NetworkImage untuk URL
        : AssetImage('assets/default.png') as ImageProvider, // Gunakan AssetImage jika bukan URL
    height: 140,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset('assets/default.png'); // Fallback image jika gagal
    },
  ),
),
                SizedBox(height: 8),
                Text(
                  data['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => navigateToDetailBubuk(data),
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  label: Icon(Icons.arrow_forward, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
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


//AS A GUEST
 void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: EdgeInsets.all(20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attention',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.redAccent),
              onPressed: () {
                Get.back(); // Close dialog
              },
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.block, // Restricted icon
              color: Colors.redAccent,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              'You must log in first to access this page.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                },
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.LOGIN); // Navigate to login page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}


  void navigateToCart() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Get.toNamed(Routes.CART);
    } else {
      showLoginDialog(context);
    }
  }

  void navigateToProfile() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Get.toNamed(Routes.MAINPROFILE);
    } else {
      showLoginDialog(context);
    }
  }

  void navigateToDetailMinuman(Map<String, dynamic> data) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailMinumanView(
            description: data['description'],
            hargalarge: data['hargalarge'],
            hargasmall: data['hargasmall'],
            imageUrl: data['imageUrl'],
            location: data['location'],
            name: data['name'],
            status: data['status'],
          ),
        ),
      );
    } else {
      showLoginDialog(context);
    }
  }

  void navigateToDetailBubuk(Map<String, dynamic> data) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBubukView(
            description: data['description'],
            harga1000gr: data['harga1000gr'],
            harga100gr: data['harga100gr'],
            harga200gr: data['harga200gr'],
            harga300gr: data['harga300gr'],
            harga500gr: data['harga500gr'],
            imageUrl: data['imageUrl'],
            location: data['location'],
            name: data['name'],
            status: data['status'],
          ),
        ),
      );
    } else {
      showLoginDialog(context);
    }
  }
}
