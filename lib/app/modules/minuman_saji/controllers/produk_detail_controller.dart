import 'package:get/get.dart';
import '../../minuman_saji/models/product_model.dart';

class ProductDetailController extends GetxController {
  final product = Rx<Product?>(null);
  final selectedSize = 'SMALL'.obs;

  @override
  void onInit() {
    super.onInit();
    product.value = Get.arguments as Product;
  }

  void setSize(String size) {
    selectedSize.value = size;
  }

  void addToCart() {
    // Implement add to cart functionality
    Get.snackbar(
      'Added to Cart',
      '${product.value!.name} (${selectedSize.value}) added to cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
