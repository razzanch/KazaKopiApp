import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FaqController extends GetxController {
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

  // Fetch FAQ data from Firestore
  Future<void> fetchFaqData() async {
    try {
      FirebaseFirestore.instance.collection('faq').snapshots().listen((querySnapshot) {
        final List<Map<String, String>> data = querySnapshot.docs.map((doc) {
          final docData = doc.data();
          return {
            'id': doc.id,  // Include the document ID
            'title': (docData['title']?.toString() ?? 'No Title') as String,
            'content': (docData['content']?.toString() ?? 'No Content') as String,
            'answer': (docData['answer']?.toString() ?? 'No Answer') as String,
          };
        }).toList();
        faqData.value = data;
      });
    } catch (e) {
      print('Error fetching FAQ data: $e');
      faqData.value = []; // Reset jika terjadi error
    }
  }

  // Method to save FAQ to Firestore in faqtemp collection
Future<void> saveFaqToTemp(String title, String content) async {
  try {
    await _firestore.collection('faqtemp').add({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
    Get.snackbar('Success', 'Your question has been saved.');
    fetchFaqData();  // Refresh FAQ data after saving
  } catch (e) {
    print('Error saving FAQ: $e');
    Get.snackbar('Error', 'Failed to save question.');
  }
}


  // Toggle accordion state
  void toggleAccordion(int index) {
    if (openedIndex.value == index) {
      isAccordionOpen.value = !isAccordionOpen.value;
    } else {
      isAccordionOpen.value = true;
      openedIndex.value = index;
    }
  }
}
