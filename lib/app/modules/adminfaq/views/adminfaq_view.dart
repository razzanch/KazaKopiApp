import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk Firestore
import 'package:myapp/app/modules/adminfaq/controllers/adminfaq_controller.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class AdminfaqView extends StatefulWidget {
  @override
  _AdminfaqViewState createState() => _AdminfaqViewState();
}

class _AdminfaqViewState extends State<AdminfaqView> {
  final AdminfaqController controller = Get.put(AdminfaqController());
  final TextEditingController searchController = TextEditingController();
  final ProfileController profileController = Get.put(ProfileController());

  RxList<Map<String, String>> filteredFaqData = <Map<String, String>>[].obs;

  @override
  void initState() {
    super.initState();

    controller.fetchFaqData();  

    // Listen for changes in search input and update filtered FAQ data
    searchController.addListener(() {
      filterFaqData();
    });

    // Initialize filtered data
    controller.faqData.listen((data) {
      filteredFaqData.value = data;
    });
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

  // Function to handle delete action
  void handleDelete(String docId) async {
    try {
      await controller.deleteFaq(docId); // Call delete function in controller
      Get.snackbar('Success', 'FAQ deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete FAQ');
    }
  }

void showInfoDialog(String title, String content, String docId) {
  TextEditingController answerController = TextEditingController();

  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners for dialog
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          // Close button (X) at the top right
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              Navigator.pop(context); 
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300), // Atur tinggi maksimum sesuai kebutuhan
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Answer TextField with rounded border and padding
              TextField(
                controller: answerController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Answer customer questions here',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.1),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
              SizedBox(height: 16.0),

              Divider(),
              SizedBox(height: 10),

              // Informative Note Text
              Text(
                'Please be careful when answering customer questions.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Upload Button styled with rounded corners
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.teal,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners for button
            ),
          ),
          onPressed: () async {
            String answer = answerController.text.trim();

            // Validate input
            if (answer.isEmpty || !RegExp(r'^[a-zA-Z0-9\s.,!?]*$').hasMatch(answer)) {
              Get.snackbar('Error', 'Invalid answer. Please use only letters, numbers, spaces, and punctuation.');
            } else {
              // Check if docId is not empty before proceeding
              // ignore: unnecessary_null_comparison
              if (docId.isEmpty || docId == null) {
                Get.snackbar('Error', 'Invalid document ID. Please try again.');
                return;  // Prevent uploading if docId is invalid
              }

              try {
                // Save the answer to FAQ collection
                await FirebaseFirestore.instance.collection('faq').add({
                  'title': title,
                  'content': content,
                  'answer': answer,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                // Delete from FAQTemp collection if docId is valid
                await FirebaseFirestore.instance.collection('faqtemp').doc(docId).delete();

                // Show success message
                Get.snackbar('Success', 'Answer uploaded successfully!');
                
                // Refresh FAQ data after uploading answer
                controller.fetchFaqData(); // Trigger the refresh

                // Close the dialog using Navigator.pop()
                Navigator.pop(context); 
              } catch (e) {
                print('Error: $e');
                Get.snackbar('Error', 'Failed to upload answer.');
              }
            }
          },
          child: Text(
            'Upload',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
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
            bottomRight: Radius.circular(20),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          "FAQ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.toNamed(Routes.ADMINHELPCENTER);
          },
        ),
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
                    Text(
                      'Let\'s Help Your Customers Today!',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Find a Question',
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
                   Obx(() {
  return Column(
    children: filteredFaqData.map((item) {
      return Accordion(
        title: item['title'] ?? '',
        content: item['content'] ?? '',
        isOpen: controller.openedIndex.value == 
                filteredFaqData.indexOf(item) &&
            controller.isAccordionOpen.value,
        onTap: () => controller.toggleAccordion(filteredFaqData.indexOf(item)),
        onDelete: () {
          String docId = item['id'] ?? '';
          if (docId.isEmpty) {
            Get.snackbar('Error', 'Invalid document ID for deletion');
          } else {
            handleDelete(docId); // Pass ID to delete
          }
        },
        onInfo: () {
          String docId = item['id'] ?? '';
          showInfoDialog(
            item['title'] ?? '',
            item['content'] ?? '',
            docId,  // Pass docId
          );
        },
      );
    }).toList(),
  );
}),

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
  final VoidCallback onDelete;
  final VoidCallback onInfo;

  Accordion({
    required this.title,
    required this.content,
    required this.isOpen,
    required this.onTap,
    required this.onDelete,
    required this.onInfo,
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
                Icon(Icons.keyboard_arrow_down),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: TextStyle(color: Colors.grey[800]),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.question_answer, color: Colors.blue),
                      onPressed: onInfo,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
          crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
