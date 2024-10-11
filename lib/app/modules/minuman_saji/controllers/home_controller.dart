import 'package:get/get.dart';
import '../../minuman_saji/models/product_model.dart';

class HomeController extends GetxController {
  final products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() {
    // Simulate fetching products from an API
    products.assignAll([
      Product(
        name: 'CHOCOLATE',
        image: 'assets/KopsuReguler.png',
        price: 18500,
        rating: 4.9,
        description: 'Meskipun bukan kopi, minuman cokelat ini tak kalah istimewa. Dengan perpaduan cokelat terbaik dan green bean coffee sebagai dasar penyeduhan, Chocolate kami memberikan rasa yang kaya dan mendalam, serta sedikit aroma kopi segar yang melengkapi cita rasa cokelat manis yang lezat.',
      ),
      Product(
        name: 'CREAMY SIGNATURE',
        image: 'assets/coffee.jpg',
        price: 18500,
        rating: 4.7,
        description: 'Kelembutan susu berpadu sempurna dengan green bean coffee yang ringan namun beraroma kuat. Creamy Signature memberikan tekstur yang lembut dengan cita rasa yang kaya, menawarkan pengalaman kopi yang lebih segar namun tetap memanjakan. Cocok bagi kamu yang ingin menikmati kopi dengan sentuhan krim yang memukau.',
      ),
      // Add more products here
    ]);
  }
}

