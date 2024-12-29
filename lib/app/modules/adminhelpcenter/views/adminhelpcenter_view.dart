import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firebase Firestore
import 'package:myapp/app/routes/app_pages.dart';

class AdminhelpcenterView extends StatefulWidget {
  const AdminhelpcenterView({super.key});

  @override
  _AdminhelpcenterViewState createState() => _AdminhelpcenterViewState();
}

class _AdminhelpcenterViewState extends State<AdminhelpcenterView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  // Function to validate and save report data
  Future<void> saveReportData() async {
  String title = titleController.text.trim();
  String content = contentController.text.trim();

  // Validation for empty fields
  if (title.isEmpty) {
    _showSnackBar('Title cannot be empty', Colors.red);
    return;
  }

  if (content.isEmpty) {
    _showSnackBar('Content cannot be empty', Colors.red);
    return;
  }

  // Validation for allowed characters (alphanumeric, . and ) and spaces
  RegExp validTitleRegExp = RegExp(r'^[a-zA-Z0-9.() ]+$');
  if (!validTitleRegExp.hasMatch(title)) {
    _showSnackBar('Title contains invalid characters', Colors.red);
    return;
  }

  RegExp validContentRegExp = RegExp(r'^[a-zA-Z0-9\s().]+$');  // Modified regex for content
  if (!validContentRegExp.hasMatch(content)) {
    _showSnackBar('Content contains invalid characters', Colors.red);
    return;
  }

  try {
    // If validation passes, save to Firestore
    await FirebaseFirestore.instance.collection('helpcenter').add({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // If saved successfully, show success SnackBar and clear fields
    _showSnackBar('Data saved successfully!', Colors.green);
    titleController.clear();
    contentController.clear();
  } catch (e) {
    // Handle error saving to Firestore
    _showSnackBar('Error saving data. Please try again.', Colors.red);
  }
}


  // Helper method to show SnackBar
  void _showSnackBar(String message, Color color) {
    Get.snackbar(
      '',
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
  }

Future<void> _showListOfInstructions() async {
  // Fetching the data from Firestore
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('helpcenter').get();
  List<DocumentSnapshot> documents = querySnapshot.docs;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.teal, // Set teal background color for dialog
        title: Text(
          'List of Instructions',
          style: TextStyle(color: Colors.white), // Title color
        ),
        content: SizedBox(
          height: 400,
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              children: documents.map((doc) {
                // Safely check if 'title' and 'content' exist
                Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
                String docId = doc.id; // Get document ID
                String title = data?['title'] ?? 'No Title'; // Default to 'No Title' if missing
                String content = data?['content'] ?? 'No Content'; // Default to 'No Content' if missing

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.article,
                      color: Colors.teal, // Icon for each card
                    ),
                    title: Text(
                      title,
                      style: TextStyle(color: Colors.teal[900]), // Title color
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          content,
                          style: TextStyle(color: Colors.grey[800]), // Content text color
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete, // Trash icon
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            // Confirmation before deleting
                            bool confirmDelete = await _confirmDelete();
                            if (confirmDelete) {
                              await FirebaseFirestore.instance
                                  .collection('helpcenter')
                                  .doc(docId)
                                  .delete();

                              Navigator.of(context).pop(); // Close dialog
                              _showSnackBar(
                                  'Document deleted successfully!', Colors.green);

                              // Reopen the dialog to refresh the list
                              _showListOfInstructions();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white), // Close button color
            ),
          ),
        ],
      );
    },
  );
}

// Helper function for confirmation dialog
Future<bool> _confirmDelete() async {
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content:
                const Text('Are you sure you want to delete this document?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel deletion
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Confirm deletion
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      ) ??
      false; // Default to false if dialog is dismissed
}




@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[300],
    appBar:AppBar(
  title: const Text(
    'Help Center',
    style: TextStyle(
      fontSize: 24, // Increase the font size of the title
      fontWeight: FontWeight.bold, // Make the font bold
    ),
  ),
  backgroundColor: Colors.teal, // App bar color
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  ),
  titleTextStyle: const TextStyle(color: Colors.white), // Set the AppBar text to white
  automaticallyImplyLeading: false, // Disable the default back button
),

    body: SingleChildScrollView( // Added SingleChildScrollView to avoid overflow
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Button "List of Instructions" above the container
          ElevatedButton(
            onPressed: _showListOfInstructions,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Button color
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Same border radius as text field
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between text and icon
                children: [
                  Text(
                    'List of Instructions',
                    style: TextStyle(
                      color: Colors.grey[700], // Set the text color to grey
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.list, // Icon for instructions
                    color: Colors.grey[700], // Icon color
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    hintText: 'Enter the title...',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                    hintText: 'Enter the content...',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: saveReportData, // Call the async method on button press
                  child: const Text(
                    'Upload',
                    style: TextStyle(color: Colors.white), // White text color
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                    minimumSize: Size(double.infinity, 50), // Button width takes full width
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(
                  color: Colors.grey, // Change the divider color to grey
                  thickness: 1,
                  height: 20,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Note: Be careful in giving instructions to customers.',
                  textAlign: TextAlign.center, // Center alignment
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                // Cards below the note text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // First card for FAQ
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.ADMINFAQ); // Navigate to FAQ page
                      },
                      child: Card(
                        color: Colors.blue[50], // Light blue color for FAQ
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: 150, // Fixed width for each card
                          child: Padding(  // Added Padding inside the card
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.question_answer,
                                  size: 40,
                                  color: Colors.blue[800],  // Darker blue for the icon
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'FAQ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],  // Darker blue for the text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Second card for Customer Report
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.ADMINREPORT); // Navigate to Customer Report page
                      },
                      child: Card(
                        color: Colors.orange[50], // Light orange color for Customer Report
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SizedBox(
                          width: 150, // Fixed width for each card
                          child: Padding(  // Added Padding inside the card
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.report_problem,
                                  size: 40,
                                  color: Colors.orange[800],  // Darker orange for the icon
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Report',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[800],  // Darker orange for the text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
                Icons.grain, // Ikon untuk menambah menu bubuk kopi
                color: Colors.grey[800],
              ),
              tooltip: 'Add Bubuk Menu',
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
                          content: const Text('Anda sudah berada di halaman Help Center'),
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
                    Icons.support_agent, // Ikon untuk management order
                    color: Colors.white,
                  ),
                  tooltip: 'Help Center',
                ),
              ],
            ),
            // Ikon Management Order dengan dialog peringatan
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADMINORDER); // Rute ke halaman CreateMinuman
              },
              icon: Icon(
                Icons.assignment, // Ikon untuk menambah menu minuman
                color: Colors.grey[800],
              ),
              tooltip: 'Order Management',
            ),
          ],
        ),
      ),
    );
  }
}
