import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class WpDetailPage extends StatefulWidget {
  WpDetailPage(this.title, this.content);

  final String content;
  final String title;

  @override
  _WpPageState createState() => _WpPageState(title, content);
}

class _WpPageState extends State<WpDetailPage> {
  final String _content;
  final String _title;

  _WpPageState(this._title, this._content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Html(
            data: _content,
            onLinkTap: (url) {
              launch(url);
            },
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          ),
        ),
      ),
    );
  }
}
