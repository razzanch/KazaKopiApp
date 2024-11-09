import 'package:get/get.dart';
import '../models/article.dart';

class GetConnectController extends GetConnect {
  static const String _baseUrl = 'https://newsapi.org/v2/everything';
  static const String _apiKey = '0047914f82b54b5a8711a784841e6d26'; // Ganti dengan API key yang sesuai
  static const String _query = 'coffee'; // Query pencarian

  RxBool isLoading = false.obs;
   RxList<ArticleElement> articles = <ArticleElement>[].obs;

  @override
  void onInit() {
    fetchArticles();
    super.onInit();
  }

 Future<void> fetchArticles() async {
  try {
    isLoading.value = true;
    final response = await get(
        '$_baseUrl?q=$_query&apiKey=$_apiKey');

    if (response.statusCode == 200) {
      // Check if the response body is not null or empty
      if (response.body != null && response.body.isNotEmpty) {
        final articlesResult = Article.fromJson(response.body); 
        articles.value = articlesResult.articles;
      } else {
        print("Empty response body");
      }
    } else {
      print("Request failed with status ${response.statusCode}");
    }
  } catch (e) {
    print('An error occurred: $e');
  } finally {
    isLoading.value = false;
  }
}

}
