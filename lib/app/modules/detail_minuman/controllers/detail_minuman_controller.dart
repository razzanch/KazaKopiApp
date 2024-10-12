import 'package:get/get.dart';
import 'package:myapp/app/modules/detail_minuman/models/minuman_model.dart';

class DetailMinumanController extends GetxController {
  final product = Rx<Product?>(null);
  final selectedSize = 'SMALL'.obs;
  final products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Ambil produk dari argument yang diberikan
    final arg = Get.arguments;
    if (arg is Product) {
      product.value = arg;  // Set produk jika argumen valid
    } else {
      // Jika tidak ada argumen yang valid, Anda dapat mengatur produk default atau lainnya
      // Misalnya:
      fetchProducts(); // Panggil untuk mengisi daftar produk
      product.value = products.isNotEmpty ? products[0] : null; // Set produk default jika daftar tidak kosong
    }
  }

  // Method untuk mengambil daftar produk
  void fetchProducts() {
    // Simulasi pengambilan produk dari API
    products.assignAll([
      Product(
        name: 'Kopi Susu Reguler',
        image: 'assets/M1.png',
        price: 18500,
        rating: 4.9,
        description: 'Meskipun bukan kopi, minuman cokelat ini tak kalah istimewa. Dengan perpaduan cokelat terbaik dan green bean coffee sebagai dasar penyeduhan, Chocolate kami memberikan rasa yang kaya dan mendalam, serta sedikit aroma kopi segar yang melengkapi cita rasa cokelat manis yang lezat.',
      ),
      Product(
        name: 'Kopi Susu Gula Aren',
        image: 'assets/M2.png',
        price: 18500,
        rating: 4.7,
        description: 'Kelembutan susu berpadu sempurna dengan green bean coffee yang ringan namun beraroma kuat. Creamy Signature memberikan tekstur yang lembut dengan cita rasa yang kaya, menawarkan pengalaman kopi yang lebih segar namun tetap memanjakan. Cocok bagi kamu yang ingin menikmati kopi dengan sentuhan krim yang memukau.',
      ),
      Product(
        name: 'Creamy Signature',
        image: 'assets/M3.png',
        price: 18500,
        rating: 4.7,
        description: 'Kelembutan susu berpadu sempurna dengan green bean coffee yang ringan namun beraroma kuat. Creamy Signature memberikan tekstur yang lembut dengan cita rasa yang kaya, menawarkan pengalaman kopi yang lebih segar namun tetap memanjakan. Cocok bagi kamu yang ingin menikmati kopi dengan sentuhan krim yang memukau.',
      ),
      Product(
        name: 'Chocolate',
        image: 'assets/M4.png',
        price: 18500,
        rating: 4.7,
        description: 'Kelembutan susu berpadu sempurna dengan green bean coffee yang ringan namun beraroma kuat. Creamy Signature memberikan tekstur yang lembut dengan cita rasa yang kaya, menawarkan pengalaman kopi yang lebih segar namun tetap memanjakan. Cocok bagi kamu yang ingin menikmati kopi dengan sentuhan krim yang memukau.',
      ),
      // Tambahkan produk lain di sini
    ]);
  }

  void setSize(String size) {
    selectedSize.value = size;
  }

  void addToCart() {
    // Implementasikan fungsi menambahkan ke keranjang
    if (product.value != null) {
      Get.snackbar(
        'Added to Cart',
        '${product.value!.name} (${selectedSize.value}) added to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'No product selected.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
