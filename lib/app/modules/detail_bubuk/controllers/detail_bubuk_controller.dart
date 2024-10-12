import 'package:get/get.dart';

class CoffeeMenu {
  final String name;
  final String imagePath;
  final double rating;

  CoffeeMenu({
    required this.name,
    required this.imagePath,
    required this.rating,
  });
}

class DetailBubukController extends GetxController {
  final coffeeMenus = <CoffeeMenu>[
    CoffeeMenu(
        name: 'Robusta Dampit Fine Medium',
        imagePath: 'assets/BK1.png',
        rating: 4.8),
    CoffeeMenu(
        name: 'Robusta Dampit Dark Profile',
        imagePath: 'assets/BK2.png',
        rating: 4.8),
    CoffeeMenu(
        name: 'Robusta Dampit Super Dark Profile',
        imagePath: 'assets/BK3.png',
        rating: 4.2),
    CoffeeMenu(
        name: 'Robusta Gunung Kawi',
        imagePath: 'assets/BK4.png',
        rating: 4.9),
    CoffeeMenu(
        name: 'Robusta Peaberry Banyuwangi',
        imagePath: 'assets/BK5.png',
        rating: 4.7),
    CoffeeMenu(
        name: 'Robusta Bali Pupuan',
        imagePath: 'assets/BK6.png',
        rating: 4.5),
    CoffeeMenu(
        name: 'Robusta Bali Madenan',
        imagePath: 'assets/BK7.png',
        rating: 4.6),
    CoffeeMenu(
        name: 'Robusta Jember & Sumbawa',
        imagePath: 'assets/BK8.png',
        rating: 4.3),
    CoffeeMenu(
        name: 'Robusta Lampung Natural',
        imagePath: 'assets/BK9.png',
        rating: 4.4),
    CoffeeMenu(
        name: 'Robusta Temanggung Natural',
        imagePath: 'assets/BK10.png',
        rating: 4.8),
    CoffeeMenu(
        name: 'Robusta Sumbawa Natural',
        imagePath: 'assets/BK11.png',
        rating: 4.6),
    CoffeeMenu(
        name: 'Arabica Fine Semeru',
        imagePath: 'assets/BK12.png',
        rating: 4.7),
    CoffeeMenu(
        name: 'Arabica Fine Pranger',
        imagePath: 'assets/BK13.png',
        rating: 4.5),
    CoffeeMenu(
        name: 'Arabica Fine Kayumas',
        imagePath: 'assets/BK14.png',
        rating: 4.6),
    CoffeeMenu(
        name: 'Arabica Fine Bali Kintamani',
        imagePath: 'assets/BK15.png',
        rating: 4.9),
    CoffeeMenu(
        name: 'Arabica Fine Jember',
        imagePath: 'assets/BK16.png',
        rating: 4.5),
    CoffeeMenu(
        name: 'Arabica Fine Flores Bejawa',
        imagePath: 'assets/BK17.png',
        rating: 4.8),
    CoffeeMenu(
        name: 'Arabica Fine Gayo Aceh',
        imagePath: 'assets/BK18.png',
        rating: 4.7),
    CoffeeMenu(
        name: 'Arabica Fine Kayu Aro',
        imagePath: 'assets/BK19.png',
        rating: 4.6),
    CoffeeMenu(
        name: 'Arabica Fine Solok Sumbar',
        imagePath: 'assets/BK20.png',
        rating: 4.4),
    CoffeeMenu(
        name: 'Arabica Fine Mandailing',
        imagePath: 'assets/BK21.png',
        rating: 4.7),
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




