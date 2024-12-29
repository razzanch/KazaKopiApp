import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminfaqController extends GetxController {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable list to store FAQ data from Firestore
  RxList<Map<String, String>> faqData = <Map<String, String>>[].obs;

  // Accordion state
  final isAccordionOpen = false.obs;
  final openedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqData(); // Fetch data from Firestore when controller is initialized
  }

Future<void> fetchFaqData() async {
  try {
    FirebaseFirestore.instance.collection('faqtemp').snapshots().listen((querySnapshot) {
      final List<Map<String, String>> data = querySnapshot.docs.map((doc) {
        final docData = doc.data();
        return {
          'id': doc.id,  // Include the document ID
          'title': (docData['title']?.toString() ?? 'No Title') as String,
          'content': (docData['content']?.toString() ?? 'No Content') as String,
        };
      }).toList();
      faqData.value = data;
    });
  } catch (e) {
    print('Error fetching FAQ data: $e');
    faqData.value = []; // Reset jika terjadi error
  }
}




// Delete FAQ document from Firestore
  Future<void> deleteFaq(String docId) async {
    try {
      await _firestore.collection('faqtemp').doc(docId).delete();
      fetchFaqData();  // Refresh the data after deletion
    } catch (e) {
      print('Error deleting FAQ: $e');
      throw Exception('Failed to delete FAQ');
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
