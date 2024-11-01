import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/modules/createbubuk/views/createbubuk_view.dart';
import 'package:myapp/app/modules/createminuman/views/createminuman_view.dart';
import 'package:myapp/app/routes/app_pages.dart';

class AdminhomeView extends StatefulWidget {
  @override
  _AdminhomeViewState createState() => _AdminhomeViewState();
}

class _AdminhomeViewState extends State<AdminhomeView> {
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
                    color: Colors.grey[800],
                  ),
                  width: 50,
                  height: 50,
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.ADMINHOME);
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
                Get.toNamed(Routes.CREATEMINUMAN);
              },
              icon: Icon(
                Icons.local_cafe,
                color: Colors.grey[800],
              ),
              tooltip: 'Add Minuman',
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CREATEBUBUK);
              },
              icon: Icon(
                Icons.grain,
                color: Colors.grey[800],
              ),
              tooltip: 'Add Bubuk Kopi',
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADMINORDER);
              },
              icon: Icon(
                Icons.assignment,
                color: Colors.grey[800],
              ),
              tooltip: 'Management Order',
            ),
          ],
        ),
      ),
    );
  }

// Method untuk membangun kartu dari koleksi 'minuman'
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

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final data = documents[index].data() as Map<String, dynamic>;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.teal),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                             builder: (context) => CreateminumanView(isEdit: true, documentId: documents[index].id),
                          ),
                        );
                      },
                      iconSize: 30,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Confirmation dialog before deletion
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Konfirmasi Hapus'),
                              content: Text('Apakah Anda yakin ingin menghapus item ini?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Batal'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    // Delete the document
                                    firestore.collection('minuman').doc(documents[index].id).delete().then((_) {
                                      // Show success snackbar
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Berhasil menghapus item'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    });
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      iconSize: 30,
                    ),
                    IconButton(
                      icon: Icon(Icons.info, color: Colors.blue),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(data['name']),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text('Description: ${data['description'] ?? 'No description available.'}'),
                                    SizedBox(height: 10),
                                    Text('Price (Large): ${data['hargalarge'] ?? 'N/A'}'),
                                    Text('Price (Small): ${data['hargasmall'] ?? 'N/A'}'),
                                    SizedBox(height: 10),
                                    Text('Location: ${data['location'] ?? 'N/A'}'),
                                    SizedBox(height: 10),
                                    Text('Status: ${data['status'] ? 'Tersedia' : 'Habis'}'),
                                    SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        data['imageUrl'],
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      iconSize: 30,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// Method untuk membangun kartu dari koleksi 'bubukkopi'
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

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final data = documents[index].data() as Map<String, dynamic>;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.teal),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreatebubukView(isEdit: true, documentId: documents[index].id),
                          ),
                        );
                      },
                      iconSize: 30,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Confirmation dialog before deletion
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Konfirmasi Hapus'),
                              content: Text('Apakah Anda yakin ingin menghapus item ini?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Batal'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    // Delete the document
                                    firestore.collection('bubukkopi').doc(documents[index].id).delete().then((_) {
                                      // Show success snackbar
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Berhasil menghapus item'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    });
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      iconSize: 30,
                    ),
                    IconButton(
                      icon: Icon(Icons.info, color: Colors.blue),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(data['name']),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text('Description: ${data['description'] ?? 'No description available.'}'),
                                    SizedBox(height: 10),
                                    Text('Price (100g): ${data['harga100gr'] ?? 'N/A'}'),
                                    Text('Price (200g): ${data['harga200gr'] ?? 'N/A'}'),
                                    Text('Price (300g): ${data['harga300gr'] ?? 'N/A'}'),
                                    Text('Price (500g): ${data['harga500gr'] ?? 'N/A'}'),
                                    Text('Price (1000g): ${data['harga1000gr'] ?? 'N/A'}'),
                                    SizedBox(height: 10),
                                    Text('Location: ${data['location'] ?? 'N/A'}'),
                                    SizedBox(height: 10),
                                    Text('Status: ${data['status'] ? 'Tersedia' : 'Habis'}'),
                                    SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        data['imageUrl'],
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      iconSize: 30,
                    ),
                  ],
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
