import 'package:flutter/material.dart';

import 'article_content.dart';

class NetArticlePage extends StatelessWidget {
  const NetArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('网络请求测试'),
      ),
      body: const ArticleContent(),
    );
  }
}
