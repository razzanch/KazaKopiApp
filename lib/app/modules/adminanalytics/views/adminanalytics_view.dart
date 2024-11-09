import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminanalyticsView extends StatefulWidget {
  const AdminanalyticsView({super.key});

  @override
  _AdminanalyticsViewState createState() => _AdminanalyticsViewState();
}

class _AdminanalyticsViewState extends State<AdminanalyticsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics Order History',
          style: TextStyle(
            fontSize: 24, // Increase the font size of the title
            fontWeight: FontWeight.bold, // Make the font bold
          ),
        ),
        backgroundColor: Colors.teal, // App bar color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        titleTextStyle: TextStyle(color: Colors.white), // Set the AppBar text to white
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () {
            Get.toNamed(Routes.ADMINHISTORY); // Navigate to ADMINHISTORY route
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('historyorder')
              .where('username', isNotEqualTo: '') // Filter data with non-empty username
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var totalOrders = snapshot.data!.docs.length;
            num totalIncome = 0;
            num pickedUpCount = 0;
            num cancelledCount = 0;

            // Process each document in the snapshot
            for (var doc in snapshot.data!.docs) {
              var orderData = doc.data() as Map<String, dynamic>;

              // Calculate total income, picked up, and cancelled counts
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

            // Prepare data for the chart (order statistics)
            List<Map<String, dynamic>> orderData = [
              {'status': 'Order Received', 'count': totalOrders}, 
              {'status': 'Picked Up', 'count': pickedUpCount}, 
              {'status': 'Cancelled', 'count': cancelledCount},
            ];

            return SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    // Stats Section - Limiting width with Expanded or Flexible
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatsCard(
                          title: 'Total Pesanan',
                          value: totalOrders.toString(),
                          icon: Icons.receipt,
                          color: Colors.blue,
                        ),
                        _buildStatsCard(
                          title: 'Total Pemasukan',
                          value: 'Rp $totalIncome',
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatsCard(
                          title: 'Pesanan Selesai',
                          value: pickedUpCount.toString(),
                          icon: Icons.check_circle,
                          color: Colors.black,
                        ),
                        _buildStatsCard(
                          title: 'Pesanan Dibatalkan',
                          value: cancelledCount.toString(),
                          icon: Icons.cancel,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Graph Section - Keeping it full height
                    Container(
                      height: 300, // Fixed height for the graph
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          labelStyle: TextStyle(color: Colors.white), // Change axis label color to white
                        ),
                        primaryYAxis: NumericAxis(
                          labelStyle: TextStyle(color: Colors.white), // Set Y-axis label color to white
                        ),
                        title: ChartTitle(
                          text: 'Order Statistics',
                          textStyle: TextStyle(color: Colors.white), // Change title color to white
                        ),
                        series: <ChartSeries>[
                          ColumnSeries<Map<String, dynamic>, String>(
                            dataSource: orderData,
                            xValueMapper: (Map<String, dynamic> order, _) => order['status'] as String,
                            yValueMapper: (Map<String, dynamic> order, _) => (order['count'] as int).toDouble(),
                            pointColorMapper: (Map<String, dynamic> order, _) {
                              // Set different colors for each status
                              switch (order['status']) {
                                case 'Order Received':
                                  return Colors.blue; // Grey for "Order Received"
                                case 'Picked Up':
                                  return Colors.black; // Black for "Picked Up"
                                case 'Cancelled':
                                  return Colors.red; // Red for "Cancelled"
                                default:
                                  return Colors.blue; // Default fallback color
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: SizedBox(
        height: 180, // Increased height for each card to prevent overflow
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 30),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13, // Adjusted font size for better readability
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15, // Adjusted font size for consistency
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
