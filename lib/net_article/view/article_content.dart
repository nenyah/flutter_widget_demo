import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/article_api.dart';
import '../model/article.dart';
import 'article_detail_page.dart';

class ArticleContent extends StatefulWidget {
  const ArticleContent({super.key});

  @override
  State<ArticleContent> createState() => _ArticleContentState();
}

class _ArticleContentState extends State<ArticleContent> {
  List<Article> _articles = [];
  ArticleApi api = ArticleApi();
  bool _loading = false;

  void _loadData() async {
    _loading = true;
    setState(() {});
    _articles = await api.loadArticles(0);
    _loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Wrap(
          spacing: 10,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CupertinoActivityIndicator(),
            Text(
              "数据加载中，请稍后...",
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      );
    }
    return EasyRefresh(
      header: const ClassicHeader(
        dragText: "下拉加载",
        armedText: "释放刷新",
        readyText: "开始加载",
        processingText: "正在加载",
        processedText: "刷新成功",
      ),
      onRefresh: _onRefresh,
      onLoad: _onLoad,
      child: ListView.builder(
        itemExtent: 80,
        itemCount: _articles.length,
        itemBuilder: _buildItemByIndex,
      ),
    );
  }

  Widget _buildItemByIndex(BuildContext context, int index) {
    return ArticleItem(
      article: _articles[index],
      onTap: _jumpToPage,
    );
  }

  void _jumpToPage(Article article) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ArticleDetailPage(article: article),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _articles = await api.loadArticles(0);
    setState(() {});
  }

  Future<void> _onLoad() async {
    int nextPage = _articles.length ~/ 20;
    List<Article> articles = await api.loadArticles(nextPage);
    _articles += articles;
    setState(() {});
  }
}

class ArticleItem extends StatelessWidget {
  final Article article;
  final ValueChanged<Article> onTap;

  const ArticleItem({Key? key, required this.article, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(article),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // Spacer(),
                  Text(
                    article.time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    article.url,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
