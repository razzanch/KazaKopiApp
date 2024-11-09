import 'dart:convert';

// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

Article articleFromJson(String str) => Article.fromJson(json.decode(str));

String articleToJson(Article data) => json.encode(data.toJson());

class Article {
  String status;
  int totalResults;
  List<ArticleElement> articles;

  Article({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<ArticleElement>.from(
            json["articles"].map((x) => ArticleElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class ArticleElement {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  ArticleElement({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory ArticleElement.fromJson(Map<String, dynamic> json) => ArticleElement(
        source: Source.fromJson(json["source"] ?? {}),
        author: json["author"] ?? "Unknown",  // Handling null
        title: json["title"] ?? "No Title",  // Handling null
        description: json["description"] ?? "No Description",  // Handling null
        url: json["url"] ?? "",  // Handling null
        urlToImage: json["urlToImage"] ?? "",  // Handling null
        publishedAt: DateTime.parse(json["publishedAt"] ?? DateTime.now().toIso8601String()),  // Default to current time if null
        content: json["content"] ?? "No Content",  // Handling null
      );

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
      };
}

class Source {
  String? id;
  String name;

  Source({
    this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],  // Could be null, that's fine
        name: json["name"] ?? "Unknown Source",  // Handle null case
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

