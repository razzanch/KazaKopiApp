import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminreportController extends GetxController {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list to store report data from Firestore
  RxList<Map<String, dynamic>> reportData = <Map<String, dynamic>>[].obs;

  // Accordion state
  final isAccordionOpen = false.obs;
  final openedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    fetchReportData(); // Fetch data from Firestore when controller is initialized
  }

  Future<void> fetchReportData() async {
    try {
      _firestore.collection('report').snapshots().listen((querySnapshot) {
        final List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) {
          final docData = doc.data();
          return {
            'id': doc.id,  // Include the document ID
            'username': docData['username']?.toString() ?? 'No Username',
            'email': docData['email']?.toString() ?? 'No Email',
            'uid': docData['uid']?.toString() ?? 'No UID',
            'title': docData['title']?.toString() ?? 'No Title',
            'content': docData['content']?.toString() ?? 'No Content',
            'imageUrl': docData['imageUrl']?.toString() ?? '', // Add imageUrl field
            'timestamp': docData['timestamp'],
          };
        }).toList();
        reportData.value = data;
      });
    } catch (e) {
      print('Error fetching report data: $e');
      reportData.value = []; // Reset if an error occurs
    }
  }

  // Delete report document from Firestore
  Future<void> deleteReport(String docId) async {
    try {
      await _firestore.collection('report').doc(docId).delete();
      fetchReportData();  // Refresh the data after deletion
    } catch (e) {
      print('Error deleting report: $e');
      throw Exception('Failed to delete report');
    }
  }

  void toggleAccordion(int index) {
    if (openedIndex.value == index) {
      isAccordionOpen.value = !isAccordionOpen.value;
    } else {
      isAccordionOpen.value = true;
      openedIndex.value = index;
    }
  }
}