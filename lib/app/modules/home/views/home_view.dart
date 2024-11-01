import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/modules/createbubuk/views/createbubuk_view.dart';
import 'package:myapp/app/modules/createminuman/views/createminuman_view.dart';
import 'package:myapp/app/modules/detail_bubuk/views/detail_bubuk_view.dart';
import 'package:myapp/app/modules/detail_minuman/views/detail_minuman_view.dart';
import 'package:myapp/app/routes/app_pages.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController pageController = PageController();
  bool isMinumanSelected = true; // Menentukan tab yang aktif
  String selectedLocation = 'Pasar Tambak Rejo, Surabaya'; // Variabel untuk lokasi yang dipilih
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
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
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
            child: Image.asset('assets/LOGO.png', height: 40),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
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
              child: isMinumanSelected ? buildMinumanCards() : buildBubukKopiCards(),
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
              color: Color(0xFF495048), // Same color as the second example
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
                    content: const Text('Anda sudah berada di halaman home'),
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
          Get.toNamed(Routes.CART); // Change to Cart route
        },
        icon: Icon(
          Icons.shopping_cart,
          color: Colors.grey,
        ),
        tooltip: 'Cart',
      ),
      IconButton(
        onPressed: () {
          // Logic for News icon can be added later
        },
        icon: Icon(
          Icons.article, // Use a suitable icon for News
          color: Colors.grey,
        ),
        tooltip: 'News',
      ),
      IconButton(
        onPressed: () {
          Get.toNamed(Routes.MAINPROFILE); // Change to Profile route
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

      // Filter documents where status is true
      final filteredDocuments = documents.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == true; // Only include documents where status is true
      }).toList();

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
                  child: Image.asset(
                    data['imageUrl'],
                    height: 140,
                    fit: BoxFit.cover,
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
                  onPressed: () {
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
                  },
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

      // Filter documents where status is true
      final filteredDocuments = documents.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['status'] == true; // Only include documents where status is true
      }).toList();

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
                  child: Image.asset(
                    data['imageUrl'],
                    height: 140,
                    fit: BoxFit.cover,
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
                  onPressed: () {
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
                  },
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


}
