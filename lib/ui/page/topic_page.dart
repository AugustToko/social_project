import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicPage extends StatefulWidget {
  TopicPage({Key key}) : super(key: key);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        margin: EdgeInsets.all(10),
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.code),
              title: Text("Android 开发"),
              subtitle: Text("Welcome to Android Dev"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.audiotrack),
              title: Text("音乐制作"),
              subtitle: Text("Welcome to Music Music production."),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.personal_video),
              title: Text("视频制作"),
              subtitle: Text("Welcome to Video production。"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.format_paint),
              title: Text("绘画交流"),
              subtitle: Text("Welcome to Painting production。"),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
