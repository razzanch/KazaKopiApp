import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPageController extends GetxController {
  var isLoggedIn = false.obs;
  var isAdmin = false.obs;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? email = prefs.getString('email'); // Mengambil email dari SharedPreferences

    isLoggedIn.value = token != null; // Cek keberadaan token

    // Cek apakah user adalah admin
    if (isLoggedIn.value && email == 'admin123@gmail.com') {
      isAdmin.value = true;
    } else {
      isAdmin.value = false;
    }
  }
}
