import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/ui/page/home_page.dart';
import 'package:social_project/ui/widgets/tab_bar_widget.dart';
import 'package:social_project/ui/widgets/user_account_drawer.dart';

import '../../main.dart';

/// 用于 [HomePage], 装载着数个 Page
class ContentPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //一个控件，可以监听返回键
    return WillPopScope(
      child: TabBarWidgetPage(
        drawer: UserAccountDrawer(),
      ),
      onWillPop: () => showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit Social Project'),
          content: Text("Sure?"),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () async {
                await App.pop();
              },
              child: Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
