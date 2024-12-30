import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:rxdart/rxdart.dart' as rxdart; // Add prefix for rxdart

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

int? selectedPaymentMethod;

num totalAmount = 0;

class _CartViewState extends State<CartView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int? selectedPaymentMethod;
  String? urlImage; // Variabel untuk menyimpan URL gambar pengguna
  final String defaultImage = 'assets/LOGO.png';

  // Fetch the current user's UID
  String? get currentUserId => _auth.currentUser?.uid;

  // Firestore reference for cart collections
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _calculateTotalAmount(); // Initial calculation of total amount
  }

  TextEditingController voucherController = TextEditingController();

void _showVoucherDialog() async {
  final vouchersSnapshot = await FirebaseFirestore.instance.collection('voucher').get();
  final vouchers = vouchersSnapshot.docs.where((doc) {
    final data = doc.data();
    final minPurchase = data['minPurchase'] ?? 0; // Default to 0 if minPurchase is not found
    final expiryDateString = data['expiryDate']; // Expiry date from the voucher data
    final expiryDate = DateTime.tryParse(expiryDateString ?? '');

    // Filter vouchers based on minPurchase and expiryDate
    return minPurchase <= totalAmount &&
        expiryDate != null &&
        expiryDate.isAfter(DateTime.now());
  }).toList(); // Convert to List after filtering

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 20,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: SingleChildScrollView( // Enable scrolling for the dialog
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.teal[200]!, Colors.teal[600]!],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Select a Voucher",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (voucherController.text.isNotEmpty)
                      Center(
                        child: Text(
                          "You have already selected a voucher.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 320,
                        child: vouchers.isNotEmpty
                            ? ListView.builder(
                                itemCount: vouchers.length,
                                itemBuilder: (context, index) {
                                  final data = vouchers[index].data();
                                  final voucherName = data['voucherName'];
                                  final voucherValue = data['voucherValue'];
                                  final minPurchase = data['minPurchase'];
                                  final expiryDate = data['expiryDate'];
                                  final imageUrl = data['imageUrl'];

                                  return GestureDetector(
                                    onTap: () {
                                      final parsedValue =
                                          (voucherValue * 100).toInt().toString() + '%';
                                      voucherController.text = parsedValue;
                                      _calculateTotalAmount();
                                      Navigator.pop(context);
                                    },
                                    child: Card(
                                      elevation: 8,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      color: Colors.white.withOpacity(0.9),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.teal.withOpacity(0.2),
                                                    blurRadius: 12,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Image.network(
                                                imageUrl,
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    voucherName,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.teal[800],
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    "Value: ${(voucherValue * 100).toInt()}%",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.teal[600],
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    "Min Purchase: Rp${minPurchase}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    "Expiry: ${expiryDate.split('T')[0]}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  "No vouchers available for this amount.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          voucherController.clear();
                          _calculateTotalAmount();
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.teal[800],
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            "Reset Voucher",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}





  void _calculateTotalAmount() async {
    totalAmount = 0; // Reset the total amount
    // Get totals from 'cartminuman'
    final minumanSnapshot = await _firestore
        .collection('cartminuman')
        .where('uid', isEqualTo: currentUserId)
        .get();
    for (var doc in minumanSnapshot.docs) {
      totalAmount += doc['total'];
    }
    // Get totals from 'cartbubuk'
    final bubukSnapshot = await _firestore
        .collection('cartbubuk')
        .where('uid', isEqualTo: currentUserId)
        .get();
    for (var doc in bubukSnapshot.docs) {
      totalAmount += doc['total'];
    }
      String voucherText = voucherController.text; // Get the text value from the TextField
  
  // Add condition: if voucherText is empty or 0, set it to 1 (no discount)
  double voucherValue = 1; // Default to 1 (no discount)
  if (voucherText.isNotEmpty && voucherText != '0') {
    // Parse the voucher text to get the percentage discount
    voucherValue = double.tryParse(voucherText.replaceAll('%', '')) ?? 1; // Default to 1 if parsing fails
    voucherValue = voucherValue / 100; // Convert to decimal (e.g., 40% -> 0.40)
     // Apply the voucher discount to the total amount
  totalAmount = totalAmount - (totalAmount * voucherValue);
  }
    setState(() {}); // Update the state to refresh UI
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
              "My Cart",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ],
        ),
        actions: [
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Obx(() {
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Colors.grey[800], thickness: 1),
              SizedBox(height: 10),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Use StreamBuilder to listen for changes in both Firestore collections
                    StreamBuilder<List<QuerySnapshot>>(
                      stream: rxdart.Rx.combineLatest2<QuerySnapshot,
                          QuerySnapshot, List<QuerySnapshot>>(
                        _firestore
                            .collection('cartminuman')
                            .where('uid', isEqualTo: currentUserId)
                            .snapshots(),
                        _firestore
                            .collection('cartbubuk')
                            .where('uid', isEqualTo: currentUserId)
                            .snapshots(),
                        (QuerySnapshot minumanSnapshot,
                                QuerySnapshot bubukSnapshot) =>
                            [minumanSnapshot, bubukSnapshot],
                      ),
                      builder: (context,
                          AsyncSnapshot<List<QuerySnapshot>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (!snapshot.hasData ||
                            (snapshot.data![0].docs.isEmpty &&
                                snapshot.data![1].docs.isEmpty)) {
                          return Text("No items found in cart.");
                        }

                        List<Widget> cartItems = [];
                        // Add items from 'cartminuman'
                        cartItems.addAll(snapshot.data![0].docs
                            .map((doc) => _buildCartItem(doc))
                            .toList());
                        // Add items from 'cartbubuk'
                        cartItems.addAll(snapshot.data![1].docs
                            .map((doc) => _buildCartItem(doc))
                            .toList());

                        return Column(
                          children: cartItems,
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

// Button to add items
              GestureDetector(
                onTap: () {
                  // Navigate to Home page when button is pressed
                  Navigator.pushNamed(context, Routes.HOME);
                },
                child: Container(
                  width: double.infinity, // Make the button take the full width
                  height: 40,
                  padding:
                      EdgeInsets.symmetric(vertical: 0), // Add vertical padding
                  decoration: BoxDecoration(
                    color: Colors.teal, // Button background color
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "+ Add Items",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

// Payment Method Section
              Text(
                'Payment method:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),

              SizedBox(height: 20),
              _buildPaymentMethod(0, 'assets/tf.png', 'Bank Transfer'),
              _buildPaymentMethod(1, 'assets/cash.png', 'In-Store Cash'),
              SizedBox(height: 10),

               SizedBox(height: 10),
            TextField(
              controller: voucherController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Voucher",
                labelStyle: TextStyle(color: Colors.grey[900]),
                suffixIcon: Icon(Icons.local_offer, color: Colors.grey[900]),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              onTap: _showVoucherDialog,
            ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

// Builds each cart item card with Info and Cancel buttons
  Widget _buildCartItem(QueryDocumentSnapshot doc) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying item image and name with info button
            Row(
              children: [
                // Item image
               ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: (doc['imageUrl'] ?? '').startsWith('http')
      ? Image.network(
          doc['imageUrl'], // Jika URL valid
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/default.png', // Fallback jika gagal memuat URL
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            );
          },
        )
      : Image.asset(
          'assets/default.png', // Gunakan aset jika bukan URL
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
),

                SizedBox(width: 12),
                // Name and Info button in a Row
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name text
                      Expanded(
                        child: Text(
                          doc['name'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          overflow:
                              TextOverflow.ellipsis, // Truncate long names
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.info, color: Colors.blue),
                        onPressed: () => _showItemDetailDialog(context, doc),
                        padding:
                            EdgeInsets.zero, // Remove padding for closer fit
                        constraints:
                            BoxConstraints(), // Remove default constraints
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Spacing between image/name and location

            // Structured info display using ListTiles
            ListTile(
              contentPadding: EdgeInsets.zero, // Remove default padding
              leading: Icon(Icons.location_on, color: Colors.teal),
              title: Text('Location'),
              subtitle: Text(doc['location'] ?? 'N/A'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero, // Remove default padding
              leading: Icon(Icons.attach_money, color: Colors.teal),
              title: Text('Total'),
              subtitle: Text('Rp ${doc['total']?.toString() ?? 'N/A'}'),
            ),

            // Align Cancel button to bottom right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
  icon: Icon(Icons.cancel, color: Colors.red),
  onPressed: () {
    voucherController.clear(); // Menghapus teks di TextField voucher
    _showDeleteConfirmationDialog(context, doc); // Memanggil dialog konfirmasi
  },
),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetailDialog(BuildContext context, QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Cast the data to a map

    // Get the imageUrl from the data
    String imageUrl = data['imageUrl'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              Colors.teal, // Set a lighter teal for better contrast
          title: Center(
            child: Text(
              data['name'],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align items
              children: [
                // Display the image
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10), // Spacing around the image
                  child: ClipRRect(
  borderRadius: BorderRadius.circular(10), // Rounded corners for the image
  child: (imageUrl).startsWith('http')
      ? Image.network(
          imageUrl, // Jika URL valid
          width: 250,
          height: 150,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/default.png', // Fallback jika gagal memuat URL
              width: 250,
              height: 150,
              fit: BoxFit.cover,
            );
          },
        )
      : Image.asset(
          imageUrl.isNotEmpty ? imageUrl : 'assets/default.png', // Gunakan aset lokal jika bukan URL
          width: 250,
          height: 150,
          fit: BoxFit.cover,
        ),
),

                ),
                // Display location
                Text(
                  "Location: ${data['location']}",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center, // Center align text
                ),
                SizedBox(height: 10), // Add spacing
                Divider(color: Colors.white), // Add a divider line
                SizedBox(height: 10), // Add spacing
                // Display price and quantity information
                _buildPriceInfo(data, 'Large', 'hargalarge', 'quantitylarge'),
                _buildPriceInfo(data, 'Small', 'hargasmall', 'quantitysmall'),
                _buildPriceInfo(
                    data, '1000 gram', 'harga1000gram', 'quantity1000gram'),
                _buildPriceInfo(
                    data, '100 gram', 'harga100gram', 'quantity100gram'),
                _buildPriceInfo(
                    data, '200 gram', 'harga200gram', 'quantity200gram'),
                _buildPriceInfo(
                    data, '300 gram', 'harga300gram', 'quantity300gram'),
                _buildPriceInfo(
                    data, '500 gram', 'harga500gram', 'quantity500gram'),
                SizedBox(height: 10), // Add spacing
                Divider(color: Colors.white), // Add a divider line
                SizedBox(height: 10), // Add spacing
                Text(
                  "Total: ${data['total']}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white), // Close button color
              ),
            ),
          ],
        );
      },
    );
  }

// Helper method to build price and quantity info
  Widget _buildPriceInfo(Map<String, dynamic> data, String label,
      String priceKey, String quantityKey) {
    if (data.containsKey(priceKey) && data.containsKey(quantityKey)) {
      return Column(
        children: [
          Text(
            "$label: ${data[priceKey]} (Qty: ${data[quantityKey]})",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 5), // Spacing between items
        ],
      );
    }
    return SizedBox(); // Return empty space if not applicable
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(
      BuildContext context, QueryDocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Item"),
          content:
              Text("Are you sure you want to remove this item from the cart?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await doc.reference.delete();
                Navigator.pop(context);
                _calculateTotalAmount();
                Get.snackbar(
                    "Deleted", "The item has been removed from your cart.");
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Payment method selection
  Widget _buildPaymentMethod(int index, String imagePath, String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selectedPaymentMethod == index
              ? Colors.blue[100]
              : Colors.transparent,
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 30,
              height: 30,
            ),
            SizedBox(width: 10),
            Text(method, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Metode Pembayaran'),
          content: Text('Silakan pilih metode pembayaran terlebih dahulu.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showFullScreenDialog(BuildContext context) {
    bool isCanceled = false;
    int countdown = 5; // Initial countdown value

    // Countdown function with delay
    Future<void> startCountdown(Function updateUI, Function onComplete) async {
      for (int i = countdown; i > 0; i--) {
        if (isCanceled) return; // Stop countdown if canceled
        await Future.delayed(Duration(seconds: 1));
        updateUI(i - 1); // Update countdown value in UI
      }
      if (!isCanceled) {
        onComplete(); // Complete action only once after countdown
      }
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return StatefulBuilder(
          builder: (context, setState) {
            void updateUI(int newCountdown) {
              setState(() {
                countdown = newCountdown;
              });
            }

            void onComplete() {
              _createOrder();
              setState(() {
                countdown = 0; // To trigger "My Order" button display
              });
            }

            // Start countdown on dialog display
            if (countdown == 5) startCountdown(updateUI, onComplete);

            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_shipping,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        countdown == 0
                            ? 'Thank You For Your Order!'
                            : 'Preparing your order...',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        countdown == 0
                            ? 'We will accept your order soon'
                            : 'Order will proceed automatically',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 20),
                      if (countdown > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.teal),
                                ),
                                Text(
                                  '$countdown', // Display countdown in the center
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                isCanceled = true; // Set cancel flag
                                Navigator.pop(context); // Close dialog
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      if (countdown == 0)
                        ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed(Routes.MYORDER);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          child: Text(
                            'My Order',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      isCanceled = true; // Ensure countdown stops if dialog is closed
    });
  }

// Modified Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Create Order button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                // Check if the user's cart is empty
                final minumanSnapshot = await _firestore
                    .collection('cartminuman')
                    .where('uid', isEqualTo: currentUserId)
                    .get();
                final bubukSnapshot = await _firestore
                    .collection('cartbubuk')
                    .where('uid', isEqualTo: currentUserId)
                    .get();

                // If both collections are empty
                if (minumanSnapshot.docs.isEmpty &&
                    bubukSnapshot.docs.isEmpty) {
                  _showEmptyCartDialog(context); // Show warning dialog
                } else if (selectedPaymentMethod == null) {
                  _showPaymentMethodDialog(context);
                } else {
                  _showFullScreenDialog(
                      context); // Show full screen dialog with timer
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Order | Total: Rp $totalAmount', // Display updated total
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),

          Divider(height: 1, color: Colors.grey[300]), // Optional divider

          // Bottom navigation icons
          Container(
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.HOME);
                  },
                  icon: Icon(Icons.home, color: Colors.grey),
                  tooltip: 'Home',
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF495048),
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
                              content: const Text(
                                  'Anda sudah berada di halaman cart'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      tooltip: 'Cart',
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.GETCONNECT);
                  },
                  icon: Icon(Icons.article, color: Colors.grey),
                  tooltip: 'News',
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.MAINPROFILE);
                  },
                  icon: Icon(Icons.person, color: Colors.grey),
                  tooltip: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEmptyCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(
              'Your cart is empty. Please add items to your cart before creating an order.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _createOrder() async {
    if (selectedPaymentMethod == null) {
      _showPaymentMethodDialog(context);
      return;
    }

    // Map payment method index to actual payment method name
    String paymentMethod;
    switch (selectedPaymentMethod) {
      case 0:
        paymentMethod = 'Bank Transfer';
        break;
      case 1:
        paymentMethod = 'COD';
        break;
      default:
        paymentMethod = 'Unknown';
    }

    try {
      // Generate a unique order ID
      final orderId = _firestore.collection('order').doc().id;

      // Fetch user data from 'users' collection
      final userDoc =
          await _firestore.collection('users').doc(currentUserId).get();
      final userData = userDoc.data();
      final username = userData?['username'] ?? 'Unknown';
      final email = userData?['email'] ?? 'Unknown';
      final phoneNumber = userData?['phoneNumber'] ?? 'Unknown';

      // Fetch items from cartminuman
      final cartMinuman = await _firestore
          .collection('cartminuman')
          .where('uid', isEqualTo: currentUserId)
          .get();

      // Fetch items from cartbubuk
      final cartBubuk = await _firestore
          .collection('cartbubuk')
          .where('uid', isEqualTo: currentUserId)
          .get();

      // Combine items from both collections into one list
      final List<Map<String, dynamic>> orderItems = [];

      // Add items from cartminuman to orderItems list
      for (var doc in cartMinuman.docs) {
        var data = doc.data();
        data['idorder'] = orderId; // Add idorder to each item
        orderItems.add(data);
      }

      // Add items from cartbubuk to orderItems list
      for (var doc in cartBubuk.docs) {
        var data = doc.data();
        data['idorder'] = orderId; // Add idorder to each item
        orderItems.add(data);
      }

      // Save all items to the order collection as a single document
DateTime now = DateTime.now();
DateTime dateWithHour = DateTime(now.year, now.month, now.day, now.hour); // Hanya tanggal dan jam

await _firestore.collection('order').doc(orderId).set({
  'idorder': orderId,
  'items': orderItems,
  'uid': currentUserId,
  'username': username,
  'email': email,
  'phoneNumber': phoneNumber,
  'paymentMethod': paymentMethod,
  'totalAmount': totalAmount,
  'date': dateWithHour, // Simpan tanggal dan jam
  'status': 'Order Received'
});



      // Delete documents from cartminuman and cartbubuk
      for (var doc in cartMinuman.docs) {
        await doc.reference.delete();
      }
      for (var doc in cartBubuk.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      // Handle errors if any occur
      Get.snackbar("Error", "Failed to create order: $e");
    }
  }
}
