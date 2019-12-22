import 'package:flutter/material.dart';
import 'package:social_project/ui/page/comment_deatil_page.dart';
import 'package:social_project/ui/page/gooey_edge_page.dart';
import 'package:social_project/ui/page/home_page.dart';
import 'package:social_project/ui/page/profile_one_page.dart';
import 'package:social_project/ui/page/profile_two_page.dart';
import 'package:social_project/ui/page/splash_page.dart';
import 'package:social_project/ui/page/timeline_page.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';

import 'env.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static String _pkg = "gooey_edge";

  static String get pkg => Env.getPackage(_pkg);

  /// 亮色主题
  static var themeData = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey.shade50,
    backgroundColor: Colors.grey.shade50,
    textTheme: TextTheme(
      // TextField输入文字颜色
      title: ThemeUtil.textLight,
      body1: ThemeUtil.textLight,
      subtitle: TextStyle(color: Colors.grey),
    ),
    cardTheme: CardTheme(color: Colors.grey.shade50),
  );

  /// 深色主题
  static var darkThemeData = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey.shade900,
    backgroundColor: Colors.grey.shade900,
    textTheme: TextTheme(
      // TextField输入文字颜色
      title: ThemeUtil.textDark,
      body1: ThemeUtil.textDark,
      subtitle: TextStyle(color: Colors.grey.shade800),
    ),
    cardTheme: CardTheme(color: Colors.grey.shade900),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: UIData.appName,
      theme: getTheme(),
      darkTheme: getTheme(isDark: true),
      home: SplashPage(),
      supportedLocales: [
        const Locale("en", "US"),
        const Locale("hi", "IN"),
      ],
      routes: {
        UIData.homeRoute: (BuildContext context) => new HomePage(),
        UIData.gooeyEdge: (BuildContext context) => new GooeyEdgePage(),
        UIData.timeLine: (BuildContext context) => new TimelineTwoPage(),
        UIData.profile: (BuildContext context) => new ProfileTwoPage(),
        UIData.commentDetail: (BuildContext context) => new CommentPage(),
      },
    );
  }

  static getTheme({bool isDark = false}) {
    return isDark ? darkThemeData : themeData;
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
