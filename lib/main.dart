import 'package:flutter/material.dart';
import 'package:social_project/temp/overflowmenu.dart';
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

//void main() {
//  runApp(BasicAppBarSample());
//}

class App extends StatelessWidget {
  static String _pkg = "gooey_edge";

  static String get pkg => Env.getPackage(_pkg);

  /// 亮色主题
  static var themeData = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.grey.shade50,
    scaffoldBackgroundColor: Colors.grey.shade50,
    backgroundColor: Colors.grey.shade50,
    appBarTheme: AppBarTheme(elevation: 0.0),
    textTheme: TextTheme(
      title: ThemeUtil.textLight,
      body1: ThemeUtil.textLight,
      subhead: ThemeUtil.textLight,
      // 用于 Drawer 中选项文字
      body2: ThemeUtil.textLight,
      subtitle: ThemeUtil.subtitle,
      button: ThemeUtil.textLight,
      // for [AboutListTile]
      headline: ThemeUtil.textLight,
    ),
    cardTheme: CardTheme(color: Colors.grey.shade50),
    canvasColor: Colors.grey.shade50,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade50,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.grey.shade50,
    ),
  );

  /// 深色主题
  static var darkThemeData = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.grey.shade900,
    scaffoldBackgroundColor: Colors.grey.shade900,
    backgroundColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(elevation: 0.0),
    textTheme: TextTheme(
      title: ThemeUtil.textDark,
      subhead: ThemeUtil.textDark,
      body1: ThemeUtil.textDark,
      body2: ThemeUtil.textDark,
      subtitle: ThemeUtil.subtitle,
      button: ThemeUtil.textDark,
      // for [AboutListTile]
      headline: ThemeUtil.textDark,
    ),
    cardTheme: CardTheme(color: Colors.grey.shade900),
    canvasColor: Colors.grey.shade900,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade900,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.grey.shade900,
    ),
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
