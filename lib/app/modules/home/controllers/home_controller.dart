import 'package:get/get.dart';
import 'package:myapp/app/modules/home/models/menu_model.dart';

class HomeController extends GetxController {
  var isMinumanSelected = true.obs; // Observable untuk mengatur tab

  var currentPage = 0.obs; // Obx untuk melacak halaman aktif
  var selectedLocation = 'Pasar Tambak Rejo, Surabaya'.obs; // Obx untuk melacak lokasi yang dipilih

  final List<String> locations = [
    'Pasar Tambak Rejo, Surabaya',
    'CitraLand CBD Boulevard, Surabaya'
  ];

  // Daftar menu minuman
  final minumanMenu = [
    MenuModel(name: 'Kopi Susu Reguler', imageAsset: 'assets/M1.png', route: '/detailKopiSusuReguler'),
    MenuModel(name: 'Kopi Susu Gula Aren', imageAsset: 'assets/M2.png', route: '/detailKopiSusuGulaAren'),
    MenuModel(name: 'Creamy Signature', imageAsset: 'assets/M3.png', route: '/detailCreamySignature'),
    MenuModel(name: 'Chocolate', imageAsset: 'assets/M4.png', route: '/detailChocolate'),
  ];

  // Daftar menu bubuk kopi
  final bubukKopiMenu = [
    MenuModel(name: 'Robusta Dampit Fine Medium', imageAsset: 'assets/BK1.png'),
    MenuModel(name: 'Robusta Dampit Dark Profile', imageAsset: 'assets/BK2.png'),
    MenuModel(name: 'Robusta Dampit Super Dark Profile', imageAsset: 'assets/BK3.png'),
    MenuModel(name: 'Robusta Gunung Kawi', imageAsset: 'assets/BK4.png'),
    MenuModel(name: 'Robusta Peaberry Banyuwangi', imageAsset: 'assets/BK5.png'),
    MenuModel(name: 'Robusta Bali Pupuan', imageAsset: 'assets/BK6.png'),
    MenuModel(name: 'Robusta Bali Madenan', imageAsset: 'assets/BK7.png'),
    MenuModel(name: 'Robusta Jember & Sumbawa', imageAsset: 'assets/BK8.png'),
    MenuModel(name: 'Robusta Lampung Natural', imageAsset: 'assets/BK9.png'),
    MenuModel(name: 'Robusta Temanggung Natural', imageAsset: 'assets/BK10.png'),
    MenuModel(name: 'Robusta Sumbawa Natural', imageAsset: 'assets/BK11.png'),
    MenuModel(name: 'Arabica Fine Semeru', imageAsset: 'assets/BK12.png'),
    MenuModel(name: 'Arabica Fine Pranger', imageAsset: 'assets/BK13.png'),
    MenuModel(name: 'Arabica Fine Kayumas', imageAsset: 'assets/BK14.png'),
    MenuModel(name: 'Arabica Fine Bali Kintamani', imageAsset: 'assets/BK15.png'),
    MenuModel(name: 'Arabica Fine Jember', imageAsset: 'assets/BK16.png'),
    MenuModel(name: 'Arabica Fine Flores Bejawa', imageAsset: 'assets/BK17.png'),
    MenuModel(name: 'Arabica Fine Gayo Aceh', imageAsset: 'assets/BK18.png'),
    MenuModel(name: 'Arabica Fine Kayu Aro', imageAsset: 'assets/BK19.png'),
    MenuModel(name: 'Arabica Fine Solok Sumbar', imageAsset: 'assets/BK20.png'),
    MenuModel(name: 'Arabica Fine Mandailing', imageAsset: 'assets/BK21.png'),
  ];

  // Navigasi ke detail view
  void navigateToDetail(MenuModel menu) {
    Get.toNamed('/detailView', arguments: menu);
  }
}
