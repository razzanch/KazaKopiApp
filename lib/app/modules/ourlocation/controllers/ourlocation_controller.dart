import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OurlocationController extends GetxController {
  //TODO: Implement OurlocationController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  WebViewController webViewController(String uri) { 
   return WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..loadRequest(Uri.parse(uri));
  }
}
