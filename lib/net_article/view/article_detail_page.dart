import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/article.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(widget.article.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.article.title)),
      body: WebViewWidget(controller: controller),
    );
  }
}
