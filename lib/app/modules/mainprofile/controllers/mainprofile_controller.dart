import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainprofileController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var uid = ''.obs;
  var profileImageUrl = ''.obs;
  var lastUpdate = ''.obs;  // Add lastUpdate observable

  @override
  void onInit() {
    super.onInit();
    _fetchUserData();
  }

  void _fetchUserData() {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          username.value = data['username'] ?? '';
          email.value = data['email'] ?? '';
          phoneNumber.value = data['phoneNumber'] ?? '';
          uid.value = data['uid'] ?? '';
          profileImageUrl.value = data['urlImage'] ?? '';

          // Fetch and format lastUpdate field
          if (data['lastUpdate'] != null) {
            Timestamp timestamp = data['lastUpdate'];
            lastUpdate.value = timestamp.toDate().toLocal().toString();
          } else {
            lastUpdate.value = 'Not updated yet';
          }
        } else {
          print("User not found");
        }
      });
    } else {
      print("No user is signed in");
    }
  }

  bool isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }
}
