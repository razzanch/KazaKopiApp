import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:myapp/app/routes/app_pages.dart';

class DetailMinumanView extends StatefulWidget {
  final String description;
  final num hargalarge;
  final num hargasmall;
  final String imageUrl;
  final String location;
  final String name;
  final bool status;

  DetailMinumanView({
    required this.description,
    required this.hargalarge,
    required this.hargasmall,
    required this.imageUrl,
    required this.location,
    required this.name,
    required this.status,
  });

  @override
  _DetailMinumanViewState createState() => _DetailMinumanViewState();
}

class _DetailMinumanViewState extends State<DetailMinumanView> {
  int quantitySmall = 0;
  int quantityLarge = 0;
  num totalCalculatePrice = 0;
  bool isFavorited = false;

void initState() {
  super.initState();
  _checkIfFavorited();
}
  void _calculateTotalPrice() {
    setState(() {
      totalCalculatePrice = (quantitySmall * widget.hargasmall) +
          (quantityLarge * widget.hargalarge);
    });
  }

  void _checkIfFavorited() async {
  final String uid = FirebaseAuth.instance.currentUser?.uid ?? "unknown";

  try {
    // Mencari apakah sudah ada dokumen dengan UID dan nama menu yang sesuai
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('favminuman')
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
          .collection('favminuman')
          .where('uid', isEqualTo: uid)
          .where('name', isEqualTo: widget.name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Jika dokumen sudah ada, update dokumen tersebut
        await querySnapshot.docs.first.reference.update({
          'description': widget.description,
          'hargalarge': widget.hargalarge,
          'hargasmall': widget.hargasmall,
          'imageUrl': widget.imageUrl,
          'location': widget.location,
          'status': widget.status,
          'isFavorited': isFavorited, // Update status favorit
        });
      } else {
        // Jika dokumen belum ada, tambah dokumen baru
        await FirebaseFirestore.instance.collection('favminuman').add({
          'uid': uid,
          'description': widget.description,
          'hargalarge': widget.hargalarge,
          'hargasmall': widget.hargasmall,
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
          .collection('favminuman')
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
                      "COFFEE DRINK SIZE",
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
                  _buildPriceRow("Small", widget.hargasmall, quantitySmall, (newQuantity) {
                    setState(() => quantitySmall = newQuantity);
                    _calculateTotalPrice();
                  }),
                  SizedBox(height: 15.0),
                  _buildPriceRow("Large", widget.hargalarge, quantityLarge, (newQuantity) {
                    setState(() => quantityLarge = newQuantity);
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
                 onPressed: () async {
  // Check if at least one quantity is greater than zero
  if (quantityLarge <= 0 && quantitySmall <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select at least one quantity.'),
        backgroundColor: Colors.red, // Set to red for failure
      ),
    );
    return; // Exit the function
  }

  try {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "unknown";
    CollectionReference cartMinuman = FirebaseFirestore.instance.collection('cartminuman');
    CollectionReference cartBubuk = FirebaseFirestore.instance.collection('cartbubuk');

    // First check if the 'cartminuman' and 'cartbubuk' collections are empty
    QuerySnapshot cartMinumanSnapshot = await cartMinuman.get();
    QuerySnapshot cartBubukSnapshot = await cartBubuk.get();

    if (cartMinumanSnapshot.docs.isEmpty && cartBubukSnapshot.docs.isEmpty) {
      // Both collections are empty, proceed with adding the item
      await cartMinuman.add({
        'uid': uid,
        'imageUrl': widget.imageUrl,
        'hargalarge': widget.hargalarge,
        'hargasmall': widget.hargasmall,
        'location': widget.location,
        'name': widget.name,
        'quantitylarge': quantityLarge,
        'quantitysmall': quantitySmall,
        'total': totalCalculatePrice,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart!'),
          backgroundColor: Colors.green, // Set to green for success
        ),
      );
      Get.offAllNamed(Routes.CART);
      return;
    }

    // Check if the location matches the existing cart items in both collections
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
          backgroundColor: Colors.red, // Set to red for failure
        ),
      );
      return;
    }

    // Now check if the item with the same name already exists in cartminuman
    bool isItemExist = false;
    DocumentSnapshot? existingDoc;

    for (var doc in cartMinumanSnapshot.docs) {
      if (doc['name'] == widget.name && doc['location'] == widget.location) {
        isItemExist = true;
        existingDoc = doc;
        break;
      }
    }

    if (isItemExist) {
      // Item exists, update the existing document
      await cartMinuman.doc(existingDoc!.id).update({
        'quantitylarge': FieldValue.increment(quantityLarge),
        'quantitysmall': FieldValue.increment(quantitySmall),
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
      // Item does not exist, add new item to cartminuman
      await cartMinuman.add({
        'uid': uid,
        'imageUrl': widget.imageUrl,
        'hargalarge': widget.hargalarge,
        'hargasmall': widget.hargasmall,
        'location': widget.location,
        'name': widget.name,
        'quantitylarge': quantityLarge,
        'quantitysmall': quantitySmall,
        'total': totalCalculatePrice,
      });

      // Show success message for new item addition
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart!'),
          backgroundColor: Colors.green, // Set to green for success
        ),
      );
    }

    // Navigate to cart after item is added or updated
    Get.offAllNamed(Routes.CART);

  } catch (e) {
    // Show failure message if adding to cart fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to add to cart: $e'),
        backgroundColor: Colors.red, // Set to red for failure
      ),
    );
  }
},




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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(right: 8.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "$label",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(20, 0), // Move the price text 10 pixels to the right
          child: Text(
            "Rp $price",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Spacer(),
        _buildCircleButton(Icons.remove, () {
          if (quantity > 0) onQuantityChanged(quantity - 1);
        }),
        SizedBox(width: 8),
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal,
          ),
          child: Text(
            '$quantity',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        SizedBox(width: 8),
        _buildCircleButton(Icons.add, () {
          onQuantityChanged(quantity + 1);
        }),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF5D0437), // Button color
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
