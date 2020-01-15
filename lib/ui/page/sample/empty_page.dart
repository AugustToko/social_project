import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/utils/uidata.dart';

class EmptyPage extends StatefulWidget {
  EmptyPage({Key key}) : super(key: key);

  @override
  _EmptyPageState createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${UIData.appName} Empty Page',
            ),
          ],
        ),
      ),
    );
  }
}
