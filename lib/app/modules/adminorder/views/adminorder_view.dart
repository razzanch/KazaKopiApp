import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/modules/login/controllers/login_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class AdminorderView extends StatelessWidget{
   final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.teal,
  elevation: 0,
  shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
  automaticallyImplyLeading: false, // Disable default back button
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Order Management",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
      ),
    ],
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.logout, color: Colors.red), // Icon logout berwarna merah
      onPressed: () {
        // Memanggil metode logout dari LoginController
        loginController.logout();
      },
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
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('order')
                    .where('username', isNotEqualTo: '')
                    .snapshots(), // No UID filter here
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
                      var orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order ID: ${orderData['idorder'] ?? 'N/A'}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showOrderItemsDialog(orderData['items']),
                                    child: Icon(Icons.receipt, color: Colors.teal),
                                  ),
                                ],
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.payment, color: Colors.teal),
                                title: Text('Payment Method'),
                                subtitle: Text(orderData['paymentMethod'] ?? 'N/A'),
                              ),
                              ListTile(
                                leading: Icon(Icons.attach_money, color: Colors.teal),
                                title: Text('Total Amount'),
                                subtitle: Text(
                                  orderData['totalAmount'] != null
                                      ? "Rp " + orderData['totalAmount'].toString()
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
                                subtitle: Text(orderData['phoneNumber'] ?? 'N/A'),
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
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: Column(
    children: [
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor(orderData['status']),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          orderData['status'] ?? 'N/A',
          style: TextStyle(color: Colors.white),
        ),
      ),
      if (orderData['status'] == 'Order Received') ...[
        Row(
          children: [
            Expanded(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      padding: EdgeInsets.symmetric(vertical: 8), // Mengurangi tinggi tombol
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Mengatur border radius
      ),
    ),
    onPressed: () async {
      // Ambil dokumen order berdasarkan idorder
      DocumentSnapshot orderDoc = await FirebaseFirestore.instance
          .collection('order')
          .doc(orderData['idorder'])
          .get();

      if (orderDoc.exists) {
        // Pindahkan data ke koleksi historyorder
        await FirebaseFirestore.instance.collection('historyorder').doc(orderData['idorder']).set(orderDoc.data() as Map<String, dynamic>);

        // Hapus dokumen dari koleksi order
        await FirebaseFirestore.instance.collection('order').doc(orderData['idorder']).delete();
        
        // Memperbarui status menjadi 'Cancelled' pada koleksi historyorder
        await FirebaseFirestore.instance.collection('historyorder').doc(orderData['idorder']).update({'status': 'Cancelled'});
      }
    },
    child: Text(
      'Cancel',
      style: TextStyle(color: Colors.white),
    ),
  ),
),

            SizedBox(width: 8), // Jarak antara tombol Cancel dan Accept
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 107, 235, 111),
                  padding: EdgeInsets.symmetric(vertical: 8), // Mengurangi tinggi tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Mengatur border radius
                  ),
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('order')
                      .doc(orderData['idorder'])
                      .update({'status': 'Being Prepared'});
                },
                child: Text(
                  'Accept',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ] else if (orderData['status'] == 'Being Prepared') ...[
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: EdgeInsets.symmetric(vertical: 8), // Mengurangi tinggi tombol
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Mengatur border radius
              ),
            ),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('order')
                  .doc(orderData['idorder'])
                  .update({'status': 'Ready for Pickup'});
            },
            child: Text(
              'Ready for Pickup',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ] else if (orderData['status'] == 'Ready for Pickup') ...[
  SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(vertical: 4), // Mengurangi tinggi tombol
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Mengatur border radius
        ),
      ),
      onPressed: () async {
        // Ambil dokumen order berdasarkan idorder
        DocumentSnapshot orderDoc = await FirebaseFirestore.instance
            .collection('order')
            .doc(orderData['idorder'])
            .get();

        if (orderDoc.exists) {
          // Pindahkan data ke koleksi historyorder
          await FirebaseFirestore.instance.collection('historyorder').doc(orderData['idorder']).set(orderDoc.data() as Map<String, dynamic>);

          // Hapus dokumen dari koleksi order
          await FirebaseFirestore.instance.collection('order').doc(orderData['idorder']).delete();
          
          // Memperbarui status menjadi 'Picked Up' pada koleksi historyorder
          await FirebaseFirestore.instance.collection('historyorder').doc(orderData['idorder']).update({'status': 'Picked Up'});
        }
      },
      child: Text(
        'Picked Up',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
],

    ],
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
                  Get.toNamed(Routes.ADMINHISTORY);
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
      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Ikon Home untuk navigasi ke halaman admin home
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADMINHOME); // Rute ke halaman AdminHome
              },
              icon: Icon(
                Icons.home,
                color: Colors.grey[800],
              ),
              tooltip: 'Home',
            ),
            // Ikon untuk menambah menu minuman
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CREATEMINUMAN); // Rute ke halaman CreateMinuman
              },
              icon: Icon(
                Icons.local_cafe, // Ikon untuk menambah menu minuman
                color: Colors.grey[800],
              ),
              tooltip: 'Add Minuman Menu',
            ),
            // Ikon untuk menambah menu bubuk kopi
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CREATEBUBUK); // Rute ke halaman CreateBubuk
              },
              icon: Icon(
                Icons.grain
, // Ikon untuk menambah menu bubuk kopi
                color: Colors.grey[800],
              ),
              tooltip: 'Add Bubuk Menu',
            ),
            // Ikon Management Order dengan dialog peringatan
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
                          content: const Text('Anda sudah berada di halaman Order Management'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Get.back(); // Menutup dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.assignment, // Ikon untuk management order
                    color: Colors.white,
                  ),
                  tooltip: 'Management Order',
                ),
              ],
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
    // Default image if not available
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
  borderRadius: BorderRadius.circular(15),
  child: Image(
    image: (data['imageUrl'] ?? '').startsWith('http')
        ? NetworkImage(data['imageUrl']) // Gunakan NetworkImage untuk URL
        : AssetImage('assets/default.png') as ImageProvider, // Gunakan AssetImage jika bukan URL
    height: 150,
    width: 250,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset('assets/default.png'); // Fallback image jika gagal
    },
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
