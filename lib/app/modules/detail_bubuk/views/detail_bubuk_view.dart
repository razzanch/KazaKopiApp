import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/app/routes/app_pages.dart';

class DetailBubukView extends StatefulWidget {
  final String description;
  final num harga1000gr;
  final num harga100gr;
  final num harga200gr;
  final num harga300gr;
  final num harga500gr;
  final String imageUrl;
  final String location;
  final String name;
  final bool status;

  DetailBubukView({
    required this.description,
    required this.harga1000gr,
    required this.harga100gr,
    required this.harga200gr,
    required this.harga300gr,
    required this.harga500gr,
    required this.imageUrl,
    required this.location,
    required this.name,
    required this.status,
  });

  @override
  _DetailBubukViewState createState() => _DetailBubukViewState();
}

class _DetailBubukViewState extends State<DetailBubukView> {
  int quantity100gr = 0;
  int quantity200gr = 0;
  int quantity300gr = 0;
  int quantity500gr = 0;
  int quantity1000gr = 0;

  // Variable to hold the total calculated price
  num totalCalculatePrice = 0;
  bool isFavorited = false;


  void initState() {
  super.initState();
  _checkIfFavorited();
}

  // Method to calculate the total price based on quantities and prices
  void _calculateTotalPrice() {
    setState(() {
      totalCalculatePrice = (quantity100gr * widget.harga100gr) +
          (quantity200gr * widget.harga200gr) +
          (quantity300gr * widget.harga300gr) +
          (quantity500gr * widget.harga500gr) +
          (quantity1000gr * widget.harga1000gr);
    });
  }

  void _checkIfFavorited() async {
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "unknown";

  try {
    // Mencari apakah sudah ada dokumen dengan UID dan nama menu yang sesuai
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('favbubuk')
        .where('uid', isEqualTo: uid)
        .where('name', isEqualTo: widget.name)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Jika sudah ada, set isFavorited menjadi true
      setState(() {
        isFavorited = true;
      });
    } else {
      // Jika tidak ada, set isFavorited menjadi false
      setState(() {
        isFavorited = false;
      });
    }
  } catch (e) {
    // Jika terjadi error, anggap belum difavoritkan
    setState(() {
      isFavorited = false;
    });
  }
}

  void _toggleFavorite() async {
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "unknown";

  setState(() {
    isFavorited = !isFavorited; // Toggle state
  });

  // Jika isFavorited bernilai true, simpan ke Firebase
  if (isFavorited) {
    try {
      // Cek apakah sudah ada dokumen dengan UID dan nama menu yang sesuai
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('favbubuk')
          .where('uid', isEqualTo: uid)
          .where('name', isEqualTo: widget.name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Jika dokumen sudah ada, update dokumen tersebut
        await querySnapshot.docs.first.reference.update({
          'description': widget.description,
          'harga1000gr': widget.harga1000gr,
          'harga100gr': widget.harga100gr,
          'harga200gr': widget.harga200gr,
          'harga300gr': widget.harga300gr,
          'harga500gr': widget.harga500gr,
          'imageUrl': widget.imageUrl,
          'location': widget.location,
          'status': widget.status,
          'isFavorited': isFavorited, // Update status favorit
        });
      } else {
        // Jika dokumen belum ada, tambah dokumen baru
        await FirebaseFirestore.instance.collection('favbubuk').add({
          'uid': uid,
          'description': widget.description,
          'harga1000gr': widget.harga1000gr,
          'harga100gr': widget.harga100gr,
          'harga200gr': widget.harga200gr,
          'harga300gr': widget.harga300gr,
          'harga500gr': widget.harga500gr,
          'imageUrl': widget.imageUrl,
          'location': widget.location,
          'name': widget.name,
          'status': widget.status,
          'isFavorited': isFavorited, // Menyimpan status favorit
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to My Favorites!'),
          backgroundColor: Colors.green, // Set to green for success
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to favorites: $e'),
          backgroundColor: Colors.red, // Set to red for failure
        ),
      );
    }
  } else {
    // Jika isFavorited bernilai false, hapus dokumen dari Firebase
    try {
      // Mencari dokumen dengan UID dan nama menu yang sesuai
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('favbubuk')
          .where('uid', isEqualTo: uid)
          .where('name', isEqualTo: widget.name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Hapus dokumen dari koleksi
        await querySnapshot.docs.first.reference.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from My Favorites.'),
            backgroundColor: Colors.red, // Set to red for removal
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove from favorites: $e'),
          backgroundColor: Colors.red, // Set to red for failure
        ),
      );
    }
  }
}

Future<void> _addToCart() async {
  // Check if at least one quantity is greater than zero
  if (quantity1000gr <= 0 &&
      quantity100gr <= 0 &&
      quantity200gr <= 0 &&
      quantity300gr <= 0 &&
      quantity500gr <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select at least one quantity.'),
        backgroundColor: Colors.red,
      ),
    );
    return; // Exit the function if no quantity is selected
  }

  try {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "unknown";
    // Reference to the Firestore collections
    CollectionReference cartMinuman = FirebaseFirestore.instance.collection('cartminuman');
    CollectionReference cartBubuk = FirebaseFirestore.instance.collection('cartbubuk');

    // First, check if the 'cartminuman' and 'cartbubuk' collections are empty
    QuerySnapshot cartMinumanSnapshot = await cartMinuman.get();
    QuerySnapshot cartBubukSnapshot = await cartBubuk.get();

    if (cartMinumanSnapshot.docs.isEmpty && cartBubukSnapshot.docs.isEmpty) {
      // Both collections are empty, proceed with adding the item to cartbubuk
      await cartBubuk.add({
        'uid': uid,
        'imageUrl': widget.imageUrl,
        'harga1000gram': widget.harga1000gr,
        'harga100gram': widget.harga100gr,
        'harga200gram': widget.harga200gr,
        'harga300gram': widget.harga300gr,
        'harga500gram': widget.harga500gr,
        'location': widget.location,
        'name': widget.name,
        'quantity1000gram': quantity1000gr,
        'quantity100gram': quantity100gr,
        'quantity200gram': quantity200gr,
        'quantity300gram': quantity300gr,
        'quantity500gram': quantity500gr,
        'total': totalCalculatePrice,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart!'),
          backgroundColor: Colors.green,
        ),
      );
      Get.offAllNamed(Routes.CART);
      return;
    }

    // Check if the location matches the existing items in both collections
    bool isLocationValid = false;

    // Check cartminuman collection
    for (var doc in cartMinumanSnapshot.docs) {
      if (doc['location'] == widget.location) {
        isLocationValid = true;
        break;
      }
    }

    // If location is not valid in cartminuman, check cartbubuk collection
    if (!isLocationValid) {
      for (var doc in cartBubukSnapshot.docs) {
        if (doc['location'] == widget.location) {
          isLocationValid = true;
          break;
        }
      }
    }

    if (!isLocationValid) {
      // Show error message if location doesn't match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: Different location.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Now check if the item with the same name already exists in cartbubuk
    bool isItemExist = false;
    DocumentSnapshot? existingDoc;

    for (var doc in cartBubukSnapshot.docs) {
      if (doc['name'] == widget.name && doc['location'] == widget.location) {
        isItemExist = true;
        existingDoc = doc;
        break;
      }
    }

    if (isItemExist) {
      // Item exists, update the existing document
      await cartBubuk.doc(existingDoc!.id).update({
        'quantity1000gram': FieldValue.increment(quantity1000gr),
        'quantity100gram': FieldValue.increment(quantity100gr),
        'quantity200gram': FieldValue.increment(quantity200gr),
        'quantity300gram': FieldValue.increment(quantity300gr),
        'quantity500gram': FieldValue.increment(quantity500gr),
        'total': FieldValue.increment(totalCalculatePrice),
      });

      // Show success message for update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item updated in cart!'),
          backgroundColor: Colors.green, // Set to green for success
        ),
      );
    } else {
      // Item does not exist, add new item to cartbubuk
      await cartBubuk.add({
        'uid': uid,
        'imageUrl': widget.imageUrl,
        'harga1000gram': widget.harga1000gr,
        'harga100gram': widget.harga100gr,
        'harga200gram': widget.harga200gr,
        'harga300gram': widget.harga300gr,
        'harga500gram': widget.harga500gr,
        'location': widget.location,
        'name': widget.name,
        'quantity1000gram': quantity1000gr,
        'quantity100gram': quantity100gr,
        'quantity200gram': quantity200gr,
        'quantity300gram': quantity300gr,
        'quantity500gram': quantity500gr,
        'total': totalCalculatePrice,
      });

      // Show success message for new item addition
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    // Navigate to cart after item is added or updated
    Get.offAllNamed(Routes.CART);

  } catch (e) {
    // Show error message if adding to cart fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to add to cart: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  leading: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  ),
  actions: [
    GestureDetector(
      onTap: _toggleFavorite,
      child: Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        color: isFavorited ? Colors.red : Colors.white,
        size: 40, // Ukuran ikon
      ),
    ),
    SizedBox(width: 16), // Menambahkan sedikit jarak ke kanan
  ],
),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 420,
                  child: Image.asset(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Center(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "DESCRIPTION",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      widget.description,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      "COFFEE POWDER SIZE",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceRow("100 G", widget.harga100gr, quantity100gr, (newQuantity) {
                    setState(() => quantity100gr = newQuantity);
                    _calculateTotalPrice();
                  }),
                  SizedBox(height: 15.0),
                  _buildPriceRow("200 G", widget.harga200gr, quantity200gr, (newQuantity) {
                    setState(() => quantity200gr = newQuantity);
                    _calculateTotalPrice();
                  }),
                  SizedBox(height: 15.0),
                  _buildPriceRow("300 G", widget.harga300gr, quantity300gr, (newQuantity) {
                    setState(() => quantity300gr = newQuantity);
                    _calculateTotalPrice();
                  }),
                  SizedBox(height: 15.0),
                  _buildPriceRow("500 G", widget.harga500gr, quantity500gr, (newQuantity) {
                    setState(() => quantity500gr = newQuantity);
                    _calculateTotalPrice();
                  }),
                  SizedBox(height: 15.0),
                  _buildPriceRow("1000 G", widget.harga1000gr, quantity1000gr, (newQuantity) {
                    setState(() => quantity1000gr = newQuantity);
                    _calculateTotalPrice();
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                  onPressed: _addToCart, // Call the add to cart method
                  child: Text(
                    "Add to Cart | Rp$totalCalculatePrice",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build price row with quantity selector
  Widget _buildPriceRow(String label, num price, int quantity, Function(int) onQuantityChanged) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Spacer(),
        Transform.translate(
          offset: Offset(-20, 0),
          child: Text(
            "Rp$price",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(width: 8),
        _buildCircleButton(Icons.remove, () {
          if (quantity > 0) {
            onQuantityChanged(quantity - 1);
          }
        }),
        SizedBox(width: 8),
        Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.teal, // Background color teal for quantity number
    
  ),
  padding: EdgeInsets.all(16),
   // Adjust padding for circular shape
  child: Text(
    quantity.toString(),
    style: TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  ),
),

        SizedBox(width: 8),
        _buildCircleButton(Icons.add, () {
          onQuantityChanged(quantity + 1);
        }),
      ],
    );
  }

  // Helper method to create circular buttons
  Widget _buildCircleButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF5D0437),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
