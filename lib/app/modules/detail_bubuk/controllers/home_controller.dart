import 'package:get/get.dart';

class CoffeeMenu {
  final String name;
  final String imagePath;
  final double rating;

  CoffeeMenu(
      {required this.name, required this.imagePath, required this.rating});
}

class HomeController extends GetxController {
  final coffeeMenus = <CoffeeMenu>[
    CoffeeMenu(
        name: 'Robusta Dampit Fine Medium',
        imagePath: 'assets/1.png',
        rating: 4.8),
    CoffeeMenu(
        name: 'Robusta Dampit Dark Profile',
        imagePath: 'assets/2.png',
        rating: 4.8),
    CoffeeMenu(
        name: "Robusta Dampit Super Dark Profile",
        imagePath: 'assets/3.png',
        rating: 4.2),
    CoffeeMenu(
        name: "Robusta Gunung Kawi", imagePath: 'assets/4.png', rating: 4.9)
    // Add more coffee menus here
  ].obs;

  final currentMenuIndex = 0.obs;
  final isFavorite = false.obs;
  final totalPrice = 0.obs;

  final Map<int, int> coffeePrices = {
    100: 25000,
    200: 35000,
    300: 45000,
    500: 65000,
    1000: 100000,
  };

  final quantities = {
    100: 0,
    200: 0,
    300: 0,
    500: 0,
    1000: 0,
  }.obs;

  void updatePrice() {
    totalPrice.value = 0;
    quantities.forEach((size, qty) {
      totalPrice.value += qty * coffeePrices[size]!;
    });
  }

  void previousMenu() {
    if (currentMenuIndex.value > 0) {
      currentMenuIndex.value--;
    } else {
      currentMenuIndex.value = coffeeMenus.length - 1;
    }
    resetQuantities();
  }

  void nextMenu() {
    if (currentMenuIndex.value < coffeeMenus.length - 1) {
      currentMenuIndex.value++;
    } else {
      currentMenuIndex.value = 0;
    }
    resetQuantities();
  }

  void resetQuantities() {
    quantities.updateAll((key, value) => 0);
    totalPrice.value = 0;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void incrementQuantity(int size) {
    quantities[size] = quantities[size]! + 1;
    updatePrice();
  }

  void decrementQuantity(int size) {
    if (quantities[size]! > 0) {
      quantities[size] = quantities[size]! - 1;
      updatePrice();
    }
  }
}
