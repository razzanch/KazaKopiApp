import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // Method to handle adding the selected items to the cart
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
      // Reference to the Firestore collection
      CollectionReference cartBubuk = FirebaseFirestore.instance.collection('cartbubuk');

      // Adding the data to Firestore
      await cartBubuk.add({
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
        Text(
          quantity.toString(),
          style: TextStyle(fontSize: 20),
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
          color: Colors.teal,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
