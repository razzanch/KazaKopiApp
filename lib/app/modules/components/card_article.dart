import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/article_detail/views/article_detail_view.dart';
import '../../data/models/article.dart';

class CardArticle extends StatelessWidget {
  final ArticleElement article;

  const CardArticle({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal, // Background color
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(
        onTap: () {
          Get.to(() => ArticleDetailView(article: article));
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display image from article.urlToImage or a placeholder
              article.urlToImage.isNotEmpty
                  ? Image.network(
                      article.urlToImage,
                      fit: BoxFit.cover,
                      height: 200, // Adjust image height as needed
                      width: double.infinity,
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey,
                      child: const Center(
                        child: Text(
                          'No Image Available',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              // Article title
              Text(
                article.title,
                style: const TextStyle(
                  color: Colors.white, // White text color for title
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              // Article description
              Text(
                article.description,
                style: const TextStyle(
                  color: Colors.white70, // Grey text color for description
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              // Article publication date
              Text(
                'Published on: ${article.publishedAt}',
                style: const TextStyle(
                  color: Colors.white60, // Faded white text for date
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
