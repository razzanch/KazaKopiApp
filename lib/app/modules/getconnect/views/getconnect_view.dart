import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

import '../../../data/services/getconnect_controller.dart';
import '../../components/card_article.dart';

class GetconnectView extends GetView<GetConnectController> {
  const GetconnectView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Track the current page using a local variable (1-based index for display)
    RxInt currentPage = 1.obs;
    const int articlesPerPage = 10; // Define articles per page
    final ScrollController scrollController = ScrollController();

    void scrollToTop() {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Function to show the information dialog
    void _showInfoDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.teal,
            title: const Text(
              'API Information',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'This API provides coffee-related news articles.',
                  style: TextStyle(color: Colors.white),
                ),
                const Divider(color: Colors.white, height: 20),
                Text(
                  'Currently, there are ${controller.articles.length} articles available.',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coffee News',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          // Information Icon Button
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showInfoDialog, // Show the dialog when pressed
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.secondary,
              ),
            ),
          );
        } else {
          // Calculate the range of articles to display based on currentPage
          final startIndex = (currentPage.value - 1) * articlesPerPage;
          final endIndex = (startIndex + articlesPerPage) > controller.articles.length
              ? controller.articles.length
              : startIndex + articlesPerPage;
          final visibleArticles = controller.articles.sublist(startIndex, endIndex);

          return Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Expanded ListView for articles
                Expanded(
                  child: ListView.builder(
                    controller: scrollController, // Attach ScrollController
                    itemCount: visibleArticles.length,
                    itemBuilder: (context, index) {
                      var article = visibleArticles[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CardArticle(article: article),
                      );
                    },
                  ),
                ),
                // Row with navigation buttons and current page display
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous Page Button
                      ElevatedButton(
                        onPressed: currentPage.value > 1
                            ? () {
                                currentPage.value--;
                                scrollToTop();
                              }
                            : null, // Disable if on the first page
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.teal, // Text color
                          backgroundColor: Colors.white, // Button background color
                        ),
                        child: const Text('Previous Page'),
                      ),
                      // Current Page Indicator
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          currentPage.value.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // Next Page Button
                      ElevatedButton(
                        onPressed: endIndex < controller.articles.length
                            ? () {
                                currentPage.value++;
                                scrollToTop();
                              }
                            : null, // Disable if on the last page
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.teal, // Text color
                          backgroundColor: Colors.white, // Button background color
                        ),
                        child: const Text('Next Page'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      }),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home Icon
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.HOME); // Navigate to the home page
              },
              icon: Icon(Icons.home, color: Colors.grey),
              tooltip: 'Home',
            ),
            // Cart Icon
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CART); // Navigate to the cart page
              },
              icon: Icon(Icons.shopping_cart, color: Colors.grey),
              tooltip: 'Cart',
            ),
            // News Icon (empty onPressed logic)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF495048), // Gray highlight color
              ),
             child: IconButton(
              onPressed: () {
                 showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Warning'),
                        content:
                            const Text('You are already on the news page'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                
              }, // Leave empty for News section
              icon: Icon(Icons.article, color: Colors.white),
              tooltip: 'News',
            ),
            ),
            // Profile Icon with highlight background
            IconButton(
                onPressed: () {
                 Get.toNamed(Routes.MAINPROFILE);
                },
                icon: Icon(Icons.person, color: Colors.grey),
                tooltip: 'Profile',
              ),
          ],
        ),
      ),
    );
  }
}
