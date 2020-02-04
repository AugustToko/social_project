import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/rebuild/helper/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// TODO：抽取到单独 flutter package 中
class WebPage extends StatefulWidget {
  final String title;
  final String url;

  WebPage({Key key, this.title, this.url}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState(title, url);
}

class _CommentPageState extends State<WebPage> {
  final String title;
  final String url;

  _CommentPageState(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "WebPage"),
      ),
      body: WebView(
        initialUrl: url ?? BLOG_GEEK_URL,
      ),
    );
  }
}
