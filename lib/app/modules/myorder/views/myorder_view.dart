import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/app/routes/app_pages.dart';

class MyorderView extends StatefulWidget {
  @override
  _MyorderViewState createState() => _MyorderViewState();
}


  
class _MyorderViewState extends State<MyorderView> {

  String? urlImage; // Variabel untuk menyimpan URL gambar pengguna
  final String defaultImage = 'assets/LOGO.png';
    
  
  @override
  void initState() {
    super.initState();
    fetchUserImage(); // Initial calculation of total amount
  }

  // Fungsi untuk mengambil data pengguna berdasarkan UID
  Future<void> fetchUserImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          urlImage = userDoc.data()?['urlImage'] ?? defaultImage;
        });
      } else {
        setState(() {
          urlImage = defaultImage;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());
    final currentUser = FirebaseAuth.instance.currentUser;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        automaticallyImplyLeading: false, // Disable default back button
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.toNamed(Routes.MAINPROFILE); // Navigate to MAINPROFILE
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Order",
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
    child: CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage(urlImage ?? defaultImage),
    ),
  ),
],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Today, ' + currentDate,
                style: TextStyle(fontSize: 16),
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
                stream: FirebaseFirestore.instance
                    .collection('order')
                    .where('uid', isEqualTo: currentUser?.uid)
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
                                          orderData['totalAmount']
                                              .toString() // Converts double to String
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
            (orderData['date'] is Timestamp
                ? (orderData['date'] as Timestamp).toDate()
                : orderData['date']) as DateTime)
        : 'N/A',
  ),
)
,
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
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.MYHISTORY);
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lihat Riwayat Pemesanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Klik ini untuk melihat aktivitas pemesanan yang telah selesai.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Order Received':
        return Colors.grey[800]!;
      case 'Being Prepared':
       return const Color.fromARGB(255, 199, 199, 32);
      case 'Ready for Pickup':
        return Colors.teal;
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
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(imageUrl,
                        width: 250, height: 150, fit: BoxFit.cover),
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
