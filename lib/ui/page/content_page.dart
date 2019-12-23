import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/ui/page/empty_page.dart';
import 'package:social_project/ui/page/home_page.dart';
import 'package:social_project/ui/page/timeline_page.dart';
import 'package:social_project/ui/widgets/tab_bar_widget.dart';
import 'package:social_project/ui/widgets/user_account_drawer.dart';

/// 用于 [HomePage], 装载着数个 Page
class ContentPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //初始化标签
    List<Widget> tabs = [
      // TODO: 国际化
      _renderTab(new Text("Time Line")),
      _renderTab(new Text("Tab 2")),
      _renderTab(new Text("Tab 3"))
    ];
    //一个控件，可以监听返回键
    return new WillPopScope(
      child: new TabBarWidgetPage(
        drawer: UserAccountDrawer(),
        title: Text("Social Project"),
        type: TabBarWidgetPage.TOP_TAB,
        tabItems: tabs,
        tabViews: [
          TimelineTwoPage(),
          EmptyPage(),
          EmptyPage(),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        indicatorColor: Theme.of(context).indicatorColor,
      ), onWillPop: () {

    },
    );
  }

  _renderTab(text) {
    //返回一个标签
    return new Tab(
        child: new Container(
      //设置paddingTop为6
      padding: new EdgeInsets.only(top: 6),
      //一个列控件
      child: new Column(
        //竖直方向居中
        mainAxisAlignment: MainAxisAlignment.center,
        //水平方向居中
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[text],
      ),
    ));
  }
}
