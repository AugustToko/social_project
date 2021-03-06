import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared/misc/shared_prefs_key.dart';
import 'package:shared/util/shared_prefs.dart';
import 'package:social_project/misc/wordpress_config_center.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:wpmodel/rep/wp_rep.dart';
import 'package:wpmodel/util/wp_net_utils.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();


  static Widget newLogo(final BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Image.asset(
            "assets/images/logo-alpha.png",
            color: Theme
                .of(context)
                .accentColor,
            height: 100,
          ),
        ),
        Text(" - Ling Yun Social Project - "),
      ],
    );
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) async {
      // 是否第一次进入APP
      var isFirst =
          SharedPreferenceUtil.getBool(SharedPrefsKeys.IS_FIRST_ENTER_APP);

      var wpCategories = await WpNetTools.getWpCategories(
          WordPressRep.getWpLink(WpSource.BlogGeek));
      if (wpCategories.list.length != 0) {
        WordPressConfigCenter.wpCategories = wpCategories;
      }

      var wpPages = await WpNetTools.getPages();
      if (wpPages.pageList.length != 0) {
        WordPressConfigCenter.pages = wpPages;
      }

      isFirst.then((val) {
        Navigator.pushReplacementNamed(
            context, val == null || val ? UIData.gooeyEdge : UIData.homeRoute);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10, top: 10),
              child: SplashPage.newLogo(context),
            ),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
    );
  }

}
