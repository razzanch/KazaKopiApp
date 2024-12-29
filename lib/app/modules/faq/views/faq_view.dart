import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/faq/controllers/faq_controller.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class FaqView extends StatefulWidget {
  @override
  _FaqViewState createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  final FaqController controller = Get.put(FaqController());
  final TextEditingController searchController = TextEditingController();
  RxList<Map<String, String>> filteredFaqData = <Map<String, String>>[].obs;
  final ProfileController profileController = Get.put(ProfileController());

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
          Get.toNamed(Routes.HELPCENTER);
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
                    'Explore [FAQ] to Assist You Better!',
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
                          answer: item['answer'] ?? '',
                          isOpen: controller.openedIndex.value ==
                                  filteredFaqData.indexOf(item) &&
                              controller.isAccordionOpen.value,
                          onTap: () =>
                              controller.toggleAccordion(filteredFaqData.indexOf(item)),
                        );
                      }).toList(),
                    );
                  }),
                  // Add the "Ask a Question" Button
                  SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      showQuestionDialog(); // Show the dialog when clicked
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minimumSize: Size(double.infinity, 48),
                    ),
                    icon: Icon(Icons.question_answer, color: Colors.black),
                    label: Text('Ask a Question', style: TextStyle(color: Colors.black)),
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
void showQuestionDialog() {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners for dialog
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Ask a New Question',
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
          constraints: BoxConstraints(maxHeight: 400), // Adjust max height for larger content area
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title Input Field with rounded border and padding
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter Title',
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
              
              // Content TextBox (larger input area)
              TextField(
                controller: contentController,
                maxLines: 6,  // Increased number of lines to make it a textbox
                decoration: InputDecoration(
                  hintText: 'Enter detailed question',
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
              SizedBox(height: 20),
              
              Divider(),
              SizedBox(height: 10),
              
              // Informative Note Text
              Text(
                'Please ensure your question contains only valid characters such as letters, numbers, spaces, and punctuation.',
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
            String title = titleController.text.trim();
            String content = contentController.text.trim();

            // Validate input
            if (title.isEmpty ||
                content.isEmpty ||
                !RegExp(r'^[a-zA-Z0-9\s.,!?]*$').hasMatch(title) ||
                !RegExp(r'^[a-zA-Z0-9\s.,!?]*$').hasMatch(content)) {
              Get.snackbar('Error', 'Invalid input. Please use only letters, numbers, spaces, and punctuation.');
            } else {
              // Call method to save to Firestore
              controller.saveFaqToTemp(title, content);
              Navigator.pop(context); 
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



}

class Accordion extends StatelessWidget {
  final String title;
  final String content;
  final String answer;
  final bool isOpen;
  final VoidCallback onTap;

  Accordion({
    required this.title,
    required this.content,
    required this.answer,
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
                Text(
                  answer,
                  style: TextStyle(color: Colors.blue),
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
