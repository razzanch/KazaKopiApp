import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/modules/detail_bubuk/views/detail_bubuk_view.dart';
import 'package:myapp/app/modules/detail_minuman/views/detail_minuman_view.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class MyfavView extends StatefulWidget {
  @override
  _MyfavViewState createState() => _MyfavViewState();
}

class _MyfavViewState extends State<MyfavView> {
  final PageController pageController = PageController();
  bool isMinumanSelected = true; // Menentukan tab yang aktif
  String selectedLocation =
      'Pasar Tambak Rejo, Surabaya'; // Variabel untuk lokasi yang dipilih
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? urlImage; // Variabel untuk menyimpan URL gambar pengguna
  final String defaultImage = 'assets/LOGO.png';
  final currentUser = FirebaseAuth.instance.currentUser;
  final ProfileController profileController = Get.put(ProfileController());

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
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
      Get.toNamed(Routes.MAINPROFILE); // Navigate to MAINPROFILE route
    },
  ),
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "My Favourite",
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          height: 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: currentUser == null
          ? ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.LOGIN); // Navigate to login route
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                minimumSize: Size(60, 30),
                padding: EdgeInsets.symmetric(horizontal: 10),
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
  child: Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Margin around container
    padding: EdgeInsets.all(8), // Padding inside the container
    decoration: BoxDecoration(
      color: Colors.grey[300], // Background color
      borderRadius: BorderRadius.circular(12), // Rounded corners
    ),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: EdgeInsets.all(8), // Inner margin for spacing
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12), // Rounded corners
            border: Border.all(color: Colors.grey[600]!), // Optional border color
          ),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.teal), // Location icon
              SizedBox(width: 5), // Space between icon and dropdown
              Expanded( // To make dropdown expand to full width within container
                child: DropdownButton<String>(
                  value: selectedLocation,
                  dropdownColor: Colors.teal,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey[800]),
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  underline: SizedBox(), // Remove default underline
                  isExpanded: true, // Make dropdown take full width
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
              ),
            ],
          ),
        ),
        // Carousel section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMinumanSelected = true; // Set Minuman active
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "Minuman",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isMinumanSelected ? Colors.black : Colors.grey,
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
                    isMinumanSelected = false; // Set Bubuk Kopi active
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "Bubuk Kopi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: !isMinumanSelected ? Colors.black : Colors.grey,
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
),

    );
  }

Widget buildMinumanCards() {
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "unknown";

  return StreamBuilder<QuerySnapshot>(
    stream: firestore.collection('favminuman').where('uid', isEqualTo: uid).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      final documents = snapshot.data!.docs;

      // Filter documents by location and status
      final filteredDocuments = documents.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == true && data['location'] == selectedLocation;
      }).toList();

      if (filteredDocuments.isEmpty) {
        return Center(
          child: Text(
            'Tidak ada minuman favorit tersedia di lokasi ini.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredDocuments.length,
        itemBuilder: (context, index) {
          final data = filteredDocuments[index].data() as Map<String, dynamic>;
          return Container(
            height: 300, // Increase height of the card
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
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
                    Positioned(
                      top: -5,
                      right: -5,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // Handle the favorite action here
                        },
                      ),
                    ),
                  ],
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
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "unknown";

  return StreamBuilder<QuerySnapshot>(
    stream: firestore.collection('favbubuk').where('uid', isEqualTo: uid).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      final documents = snapshot.data!.docs;

      // Filter documents by location and status
      final filteredDocuments = documents.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == true && data['location'] == selectedLocation;
      }).toList();

      if (filteredDocuments.isEmpty) {
        return Center(
          child: Text(
            'Tidak ada bubuk kopi favorit di lokasi ini.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredDocuments.length,
        itemBuilder: (context, index) {
          final data = filteredDocuments[index].data() as Map<String, dynamic>;
          return Container(
            height: 300, // Increase height of the card
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
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
                    Positioned(
                      top: -5,
                      right: -5,
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // Handle the favorite action here
                        },
                      ),
                    ),
                  ],
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
