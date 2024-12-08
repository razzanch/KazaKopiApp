import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';

import 'package:myapp/app/routes/app_pages.dart';

class MyhistoryView extends StatefulWidget {
  @override
  _MyhistoryViewState createState() => _MyhistoryViewState();
}

class _MyhistoryViewState extends State<MyhistoryView> {
  DateTime? selectedDate; // Store the selected date
  final String userUid = FirebaseAuth.instance.currentUser!.uid;
   String? urlImage; // Variabel untuk menyimpan URL gambar pengguna
  final String defaultImage = 'assets/LOGO.png';
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
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.toNamed(Routes.MYORDER);
              },
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order History",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () async {
                  await _showDateSelectionDialog();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null
                            ? 'All Date'
                            : DateFormat('MMMM d, yyyy').format(selectedDate!),
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.date_range, color: Colors.teal),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: selectedDate == null
    ? FirebaseFirestore.instance
        .collection('historyorder')
        .where('uid', isEqualTo: userUid) // Filter UID pengguna
        .snapshots()
    : FirebaseFirestore.instance
        .collection('historyorder')
        .where('uid', isEqualTo: userUid) // Filter UID pengguna
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(
          DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
          ),
        ))
        .where('date', isLessThan: Timestamp.fromDate(
          DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day + 1,
          ),
        ))
        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'No orders found',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var orderData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order ID: ${orderData['idorder'] ?? 'N/A'}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showOrderItemsDialog(
                                        orderData['items']),
                                    child:
                                        Icon(Icons.receipt, color: Colors.teal),
                                  ),
                                ],
                              ),
                              Divider(),
                              ListTile(
                                leading:
                                    Icon(Icons.payment, color: Colors.teal),
                                title: Text('Payment Method'),
                                subtitle:
                                    Text(orderData['paymentMethod'] ?? 'N/A'),
                              ),
                              ListTile(
                                leading: Icon(Icons.attach_money,
                                    color: Colors.teal),
                                title: Text('Total Amount'),
                                subtitle: Text(
                                  orderData['totalAmount'] != null
                                      ? "Rp " +
                                          orderData['totalAmount'].toString()
                                      : 'N/A',
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.person, color: Colors.teal),
                                title: Text('Name'),
                                subtitle: Text(orderData['username'] ?? 'N/A'),
                              ),
                              ListTile(
                                leading: Icon(Icons.phone, color: Colors.teal),
                                title: Text('Phone'),
                                subtitle:
                                    Text(orderData['phoneNumber'] ?? 'N/A'),
                              ),
                              ListTile(
                                leading: Icon(Icons.calendar_today, color: Colors.teal),
                                title: Text('Order Date'),
                                subtitle: Text(
                                  orderData['date'] != null
                                      ? DateFormat.yMMMd().add_j().format(
                                          (orderData['date'] as Timestamp).toDate())
                                      : 'N/A',
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  alignment: Alignment
                                      .center, // Center the text within the container
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(orderData['status']),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    orderData['status'] ?? 'N/A',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
  padding: const EdgeInsets.all(16.0),
  child: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('historyorder')
        .where('uid', isEqualTo: userUid) // Only include records matching the user's UID
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      var totalOrders = snapshot.data!.docs.length;
      num totalIncome = 0;
      num pickedUpCount = 0;
      num cancelledCount = 0;

      for (var doc in snapshot.data!.docs) {
        var orderData = doc.data() as Map<String, dynamic>;

        // Calculate total income if status is not 'Cancelled'
        if (orderData['status'] != 'Cancelled') {
          totalIncome += orderData['totalAmount'] ?? 0;
        }

        switch (orderData['status']) {
          case 'Picked Up':
            pickedUpCount++;
            break;
          case 'Cancelled':
            cancelledCount++;
            break;
        }
      }

      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.ADMINANALYTICS);
        },
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Riwayat Pemesanan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.receipt_long, color: Colors.white),
                  title: Text(
                    'Total Pesanan',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    '$totalOrders',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.attach_money, color: Colors.green),
                  title: Text(
                    'Total Pembelian',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    'Rp $totalIncome',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.black),
                  title: Text(
                    'Pesanan Selesai (Picked Up)',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    '$pickedUpCount',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.cancel, color: Colors.red),
                  title: Text(
                    'Pesanan Dibatalkan (Cancelled)',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    '$cancelledCount',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.MYANALITICS);
                    },
                    child: Text(
                      "TAP HERE TO SEE DETAIL",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
),



          ],
        ),
      ),
    );
  }


   Future<void> _showDateSelectionDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Date Option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.all_inclusive, color: Colors.teal),
              title: Text('All Date'),
              onTap: () {
                setState(() {
                  selectedDate = null;
                });
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.teal),
              title: Text('Choose Date'),
              onTap: () async {
                Navigator.of(context).pop();
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Picked Up':
        return Colors.black;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.teal; // Default color if status is unrecognized
    }
  }

  void _showOrderItemsDialog(List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      Get.defaultDialog(
        title: 'No Items',
        middleText: 'There are no items in this order.',
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.teal, // Set dialog background color to teal
        title: Text(
          'Order Items',
          style: TextStyle(color: Colors.white), // Title text color
        ),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            // Make the dialog content scrollable
            child: ListView.builder(
              physics:
                  NeverScrollableScrollPhysics(), // Disable ListView scrolling to enable SingleChildScrollView
              shrinkWrap: true, // Use the minimum size for ListView
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index] as Map<String, dynamic>;
                return GestureDetector(
                  // Wrap Card with GestureDetector
                  onTap: () {
                    // Show detailed item dialog
                    _showItemDetailDialog(context, item);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.teal[300], // Card color
                    child: Padding(
                      padding:
                          const EdgeInsets.all(8.0), // Padding inside the card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Align children to the start
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Space between the two widgets
                            children: [
                              Expanded(
                                child: Text(
                                  item['name'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Title text color
                                  ),
                                ),
                              ),
                              // Text for "Tap to see details"
                              Text(
                                "Tap to see details",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12), // Description text color
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Location: ${item['location'] ?? 'N/A'}',
                            style: TextStyle(
                                color: Colors.white), // Subtitle text color
                          ),
                          SizedBox(
                              height: 4), // Spacing between location and total
                          Text(
                            'Total: Rp ${item['total']?.toString() ?? 'N/A'}',
                            style: TextStyle(
                                color: Colors.white), // Total text color
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        actions: [
          Divider(
              color: Colors.white), // Add a white divider before the actions
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white), // Close button text color
            ),
          ),
        ],
      ),
    );
  }

// This is your existing function to show item details
  void _showItemDetailDialog(BuildContext context, Map<String, dynamic> data) {
    String imageUrl = data['imageUrl'] ??
        'assets/default.png'; // Default image if not available

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.teal,
          title: Center(
            child: Text(
              data['name'] ?? 'Item Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
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
                Text(
                  "Location: ${data['location'] ?? 'N/A'}",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Divider(color: Colors.white),
                SizedBox(height: 10),
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
                SizedBox(height: 10),
                Divider(color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Total: ${data['total'] ?? 'N/A'}",
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
                style: TextStyle(color: Colors.white),
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
          SizedBox(height: 5),
        ],
      );
    }
    return SizedBox(); // Return empty space if not applicable
  }
}
