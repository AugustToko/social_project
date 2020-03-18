import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared/rep/wp_rep.dart';
import 'package:shared/util/net_util.dart';
import 'package:shared/util/shared_prefs.dart';
import 'package:shared/util/urls.dart';
import 'package:social_project/misc/shared_prefs_key.dart';
import 'package:social_project/misc/wordpress_config_center.dart';
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

    NetTools.getWpCategories(WordPressRep.getWpLink(WpSource.BlogGeek))
        .then((val) {
      if (val.list.length == 0) return;
      WordPressConfigCenter.wpCategories = val;

      isFirst.then((val) {
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
