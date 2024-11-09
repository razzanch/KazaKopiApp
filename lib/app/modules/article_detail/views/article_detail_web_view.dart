import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/models/article.dart';
import '../controllers/article_detail_controller.dart';

// ignore: must_be_immutable
class ArticleDetailWebView extends GetView<ArticleDetailController> {
  final ArticleElement article;

  const ArticleDetailWebView({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    // Pastikan controller diinisialisasi di sini
    Get.put(ArticleDetailController());  // Inisialisasi controller secara manual

    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Coffee News Webview',
    style: TextStyle(color: Colors.white), // Title color
  ),
  centerTitle: true, // Center the title
  backgroundColor: Colors.teal, // Transparent background
  elevation: 4, // Slight shadow effect
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(20), // Rounded bottom-left corner
      bottomRight: Radius.circular(20), // Rounded bottom-right corner
    ),
  ),
  leading: Container(

    child: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button icon
      onPressed: () => Get.back(),
      splashRadius: 20, // Smaller splash effect
      padding: const EdgeInsets.all(10), // Smaller padding for the back button
      iconSize: 24, // Smaller icon size
      color: Colors.white, // White color for the icon
      splashColor: Colors.teal.withOpacity(0.3), // Splash color effect
    ),
  ),
),
      body: WebViewWidget(
        controller: controller.webViewController(article.url),
      ),
    );
  }
}