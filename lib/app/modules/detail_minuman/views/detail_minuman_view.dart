import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _calculateTotalPrice() {
    setState(() {
      totalCalculatePrice = (quantitySmall * widget.hargasmall) +
          (quantityLarge * widget.hargalarge);
    });
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
                      CollectionReference cartMinuman = FirebaseFirestore.instance.collection('cartminuman');

                      await cartMinuman.add({
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
                    } catch (e) {
                      // Show failure message
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
