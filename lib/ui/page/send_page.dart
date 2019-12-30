import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

/// 编辑文章、回复文章
@FFRoute(
    name: "/send_page",
    routeName: "SendPage",
    showStatusBar: true,
    pageRouteType: PageRouteType.transparent)
class SendPage extends StatefulWidget {
  SendPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${UIData.appName} Send Page',
            ),
          ],
        ),
      ),
    );
  }
}
