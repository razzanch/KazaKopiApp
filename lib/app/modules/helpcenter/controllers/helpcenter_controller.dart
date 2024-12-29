import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HelpcenterController extends GetxController {
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
    final querySnapshot = await _firestore.collection('helpcenter').get();
    final List<Map<String, String>> data = querySnapshot.docs.map((doc) {
      final docData = doc.data(); // Tipe Map<String, dynamic>
      return {
        'title': docData['title']?.toString() ?? 'No Title',
        'content': docData['content']?.toString() ?? 'No Content',
      };
    }).toList();
    faqData.value = data;
  } catch (e) {
    print('Error fetching FAQ data: $e');
    faqData.value = []; // Reset jika terjadi error
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
