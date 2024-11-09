import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/helpcenter_controller.dart';

class HelpcenterView extends StatefulWidget {
  @override
  _HelpcenterViewState createState() => _HelpcenterViewState();
}

class _HelpcenterViewState extends State<HelpcenterView> {
  String? urlImage; 
  final String defaultImage = 'assets/LOGO.png';
  final HelpcenterController controller = Get.put(HelpcenterController());
  final TextEditingController searchController = TextEditingController();
  RxList<Map<String, String>> filteredFaqData = <Map<String, String>>[].obs;

  @override
  void initState() {
    super.initState();
    fetchUserImage(); 
    filteredFaqData.value = controller.faqData; // Initialize with full FAQ data

    // Listen for changes in search input and update filtered FAQ data
    searchController.addListener(() {
      filterFaqData();
    });
  }

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

  // Function to filter FAQ data based on search input
  void filterFaqData() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredFaqData.value = controller.faqData;
    } else {
      filteredFaqData.value = controller.faqData
          .where((item) => item['title']!.toLowerCase().contains(query))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Help Center",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.toNamed(Routes.MAINPROFILE);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage:
                  AssetImage(urlImage ?? defaultImage),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(
                      'How can we assist you today?',
                      style:
                          TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search help',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Obx(
                      () => Column(
                        children: filteredFaqData.asMap().entries.map((e) {
                          final index = e.key;
                          final item = e.value;
                          return Accordion(
                            title: item['title'] ?? '',
                            content: item['content'] ?? '',
                            isOpen: controller.openedIndex.value == index &&
                                controller.isAccordionOpen.value,
                            onTap: () => controller.toggleAccordion(index),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle "Send a message" action here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                        ),
                        child: Text('Report Your Issue'),
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
  }
}


class Accordion extends StatelessWidget {
  final String title;
  final String content;
  final bool isOpen;
  final VoidCallback onTap;

  Accordion({
    required this.title,
    required this.content,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox.shrink(),
          secondChild: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: Text(
              content,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
          crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
