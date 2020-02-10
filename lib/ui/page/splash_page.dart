import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared/util/shared_prefs.dart';
import 'package:social_project/misc/shared_prefs_key.dart';
import 'package:social_project/utils/uidata.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    // 是否第一次进入APP
    var isFirst =
        SharedPreferenceUtil.getBool(SharedPrefsKeys.IS_FIRST_ENTER_APP);

    // 如果第一次进入APP，则跳转引导页，否则进入主页
    isFirst.then((val) {
      Future.delayed(Duration(seconds: 0), () {
        Navigator.pushReplacementNamed(
            context, val == null || val ? UIData.gooeyEdge : UIData.homeRoute);
      });
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${UIData.appName}',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
