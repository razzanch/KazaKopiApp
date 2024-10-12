import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final PageController pageController =
      PageController(); // PageController untuk mengontrol scroll position

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        automaticallyImplyLeading: false, // Menyembunyikan tombol Back
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 0.8), // Mengurangi line-height
            ),
            Obx(() => DropdownButton<String>(
                  value: controller.selectedLocation.value,
                  dropdownColor: Colors.teal,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  underline: SizedBox(),
                  isDense: true, // Memperpendek jarak dropdown
                  onChanged: (newLocation) {
                    controller.selectedLocation.value = newLocation!;
                  },
                  items: controller.locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                )),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/LOGO.png', height: 40),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Scrollable Banner dengan border dan page indicator
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  height: 150,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      controller.currentPage.value = index;
                    },
                    children: [
                      Image.asset('assets/news1.png'),
                      Image.asset('assets/news2.png'),
                      Image.asset('assets/news3.png'),
                    ],
                  ),
                ),
                // Page indicator
                SizedBox(height: 8),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.currentPage.value == index
                                ? Colors.teal
                                : Colors.grey,
                            border: Border.all(color: Colors.grey),
                          ),
                        );
                      }),
                    )),
              ],
            ),
          ),
          // Menu Tab dengan garis di bawah teks yang dipilih
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => controller.isMinumanSelected.value = true,
                  child: Obx(() => Column(
                        children: [
                          Text(
                            "Minuman",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: controller.isMinumanSelected.value
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          if (controller.isMinumanSelected.value)
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              height: 2,
                              width: 60,
                              color: Colors.teal,
                            ),
                        ],
                      )),
                ),
                GestureDetector(
                  onTap: () => controller.isMinumanSelected.value = false,
                  child: Obx(() => Column(
                        children: [
                          Text(
                            "Bubuk Kopi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: !controller.isMinumanSelected.value
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                          if (!controller.isMinumanSelected.value)
                            Container(
                              margin: EdgeInsets.only(top: 4),
                              height: 2,
                              width: 60,
                              color: Colors.teal,
                            ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          SizedBox(height: 16), // Jarak antara tulisan dan daftar card
          Expanded(
            child: Obx(() {
              final menuList = controller.isMinumanSelected.value
                  ? controller.minumanMenu
                  : controller.bubukKopiMenu;
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: menuList.length,
                itemBuilder: (context, index) {
                  final menu = menuList[index];
                  return Card(
                    color: Colors.grey[300],
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          menu.imageAsset,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Text(
                          menu.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF495048),
                          ),
                          onPressed: () {
                            // Periksa apakah tab Minuman atau Bubuk Kopi yang aktif
                            if (controller.isMinumanSelected.value) {
                              Get.toNamed(
                                  Routes.MINUMANSAJI); // Rute ke MinumanSaji
                            } else {
                              Get.toNamed(
                                  Routes.DETAILBUBUK); // Rute ke BubukKopi
                            }
                          },
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF495048),
                  ),
                  width: 50,
                  height: 50,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Warning'),
                          content:
                              const Text('Anda sudah berada di halaman home'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Get.back(); // Menutup dialog
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  tooltip: 'Home',
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CART); // Rute ke Cart
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.grey,
              ),
              tooltip: 'Cart',
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.PROFILE); // Rute ke Profil
              },
              icon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              tooltip: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
