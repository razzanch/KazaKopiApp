import 'package:get/get.dart';
import 'package:myapp/app/modules/home/models/menu_model.dart'; // Import model menu

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
    MenuModel(name: 'Robusta Dampit Fine Medium', imageAsset: 'assets/BK1.png', route: '/detailRobustaDampitFineMedium'),
    MenuModel(name: 'Robusta Dampit Dark Profile', imageAsset: 'assets/BK2.png', route: '/detailRobustaDampitDarkProfile'),
    MenuModel(name: 'Robusta Dampit Super Dark Profile', imageAsset: 'assets/BK3.png', route: '/detailRobustaDampitSuperDarkProfile'),
    MenuModel(name: 'Robusta Gunung Kawi', imageAsset: 'assets/BK4.png', route: '/detailRobustaGunungKawi'),
    MenuModel(name: 'Robusta Peaberry Banyuwangi', imageAsset: 'assets/BK5.png', route: '/detailRobustaPeaberryBanyuwangi'),
    MenuModel(name: 'Robusta Bali Pupuan', imageAsset: 'assets/BK6.png', route: '/detailRobustaBaliPupuan'),
    MenuModel(name: 'Robusta Bali Madenan', imageAsset: 'assets/BK7.png', route: '/detailRobustaBaliMadenan'),
    MenuModel(name: 'Robusta Jember & Sumbawa', imageAsset: 'assets/BK8.png', route: '/detailRobustaJemberSumbawa'),
    MenuModel(name: 'Robusta Lampung Natural', imageAsset: 'assets/BK9.png', route: '/detailRobustaLampungNatural'),
    MenuModel(name: 'Robusta Temanggung Natural', imageAsset: 'assets/BK10.png', route: '/detailRobustaTemanggungNatural'),
    MenuModel(name: 'Robusta Sumbawa Natural', imageAsset: 'assets/BK11.png', route: '/detailRobustaSumbawaNatural'),
    MenuModel(name: 'Arabica Fine Semeru', imageAsset: 'assets/BK12.png', route: '/detailArabicaFineSemeru'),
    MenuModel(name: 'Arabica Fine Pranger', imageAsset: 'assets/BK13.png', route: '/detailArabicaFinePranger'),
    MenuModel(name: 'Arabica Fine Kayumas', imageAsset: 'assets/BK14.png', route: '/detailArabicaFineKayumas'),
    MenuModel(name: 'Arabica Fine Bali Kintamani', imageAsset: 'assets/BK15.png', route: '/detailArabicaFineBaliKintamani'),
    MenuModel(name: 'Arabica Fine Jember', imageAsset: 'assets/BK16.png', route: '/detailArabicaFineJember'),
    MenuModel(name: 'Arabica Fine Flores Bejawa', imageAsset: 'assets/BK17.png', route: '/detailArabicaFineFloresBejawa'),
    MenuModel(name: 'Arabica Fine Gayo Aceh', imageAsset: 'assets/BK18.png', route: '/detailArabicaFineGayoAceh'),
    MenuModel(name: 'Arabica Fine Kayu Aro', imageAsset: 'assets/BK19.png', route: '/detailArabicaFineKayuAro'),
    MenuModel(name: 'Arabica Fine Solok Sumbar', imageAsset: 'assets/BK20.png', route: '/detailArabicaFineSolokSumbar'),
    MenuModel(name: 'Arabica Fine Mandailing', imageAsset: 'assets/BK21.png', route: '/detailArabicaFineMandailing'),
  ];
}
