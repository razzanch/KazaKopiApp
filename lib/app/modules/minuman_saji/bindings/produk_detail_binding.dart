// app/modules/product_detail/bindings/product_detail_binding.dart
import 'package:get/get.dart';
import '../../minuman_saji/controllers/produk_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(),
    );
  }
}