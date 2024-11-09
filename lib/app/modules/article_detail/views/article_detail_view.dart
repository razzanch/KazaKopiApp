import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/data/models/article.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ArticleDetailView extends StatelessWidget {
  final ArticleElement article;
  const ArticleDetailView({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Coffee Detail News',
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

      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[400], // Set background to grey[500]
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero widget for image transition animation
              Hero(
                tag: article.urlToImage.isNotEmpty
                    ? '${article.urlToImage}${article.title}' // Make tag unique by combining urlToImage and title
                    : article.title + article.publishedAt.toIso8601String(),
                child: article.urlToImage.isNotEmpty
                    ? Image.network(
                        article.urlToImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      )
                    : Container(
                        color: Colors.grey,
                        child: const Center(
                          child: Text(
                            'No Image Available',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              // Article details
              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Description of the article
    Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        article.description.isNotEmpty
            ? article.description
            : "No Description Available",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic, // Italicize the description for emphasis
            ),
      ),
    ),
    const Divider(color: Colors.grey),
    
    // Title of the article
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        article.title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
      ),
    ),
    const Divider(color: Colors.grey),
    
    // Publication date of the article
    Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        'Published on: ${article.publishedAt.toLocal()}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600], // Grey color for date
            ),
      ),
    ),
    
    // Author of the article
    Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        'Author: ${article.author.isNotEmpty ? article.author : "Unknown"}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600], // Grey color for author
            ),
      ),
    ),
    const Divider(color: Colors.grey),
    
    // Article content
    Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        article.content.isNotEmpty
            ? article.content
            : "No Content Available",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.5, // Adjust line height for better readability
            ),
      ),
    ),
    
    // Button to navigate to the full article in WebView
    Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ElevatedButton(
        child: const Text('Read more'),
        onPressed: () {
          Get.toNamed(Routes.ARTICLE_DETAIL_WEBVIEW, arguments: article);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[800], // Darker button background color
          foregroundColor: Colors.white, // White button text color
          minimumSize: Size(double.infinity, 48), // Make button as wide as the container
          padding: const EdgeInsets.symmetric(vertical: 16), // Make button taller
        ),
      ),
    ),
  ],
),

            ],
          ),
        ),
      ),
    );
  }
}
