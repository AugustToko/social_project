import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/ui/page/no_route.dart';
import 'package:social_project/ui/page/splash_page.dart';
import 'package:social_project/utils/route/example_route.dart';
import 'package:social_project/utils/route/example_route_helper.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/shared_prefs.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';

import 'env.dart';
import 'misc/shared_prefs_key.dart';

void main() => runApp(App());

//void main() {
//  runApp(BasicAppBarSample());
//}

class App extends StatelessWidget {
  static String _pkg = "gooey_edge";

  static String get pkg => Env.getPackage(_pkg);

  static bool login = false;

  /// 亮色主题
  static var themeData = ThemeData(
      primarySwatch: Colors.blue,
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
//    canvasColor: Colors.grey.shade50,
      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey.shade50,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.grey.shade50,
      ),
      iconTheme: IconThemeData(color: Colors.white));

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
//    canvasColor: Colors.grey.shade900,
      dialogTheme: DialogTheme(
        backgroundColor: Colors.grey.shade900,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.grey.shade900,
      ),
      iconTheme: IconThemeData(color: Colors.black));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: UIData.appName,
        // 调试横幅
        debugShowCheckedModeBanner: true,
        // 主题
        theme: getTheme(),
        // 暗色主题
        darkTheme: getTheme(isDark: true),
//        themeMode: ThemeMode.system,
//        supportedLocales: [
//          const Locale("en", "US"),
//          const Locale("hi", "IN"),
//          const Locale("hi", "IN"),
//        ],
        builder: (c, w) {
          ScreenUtil.instance =
              ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
                ..init(c);
          var data = MediaQuery.of(c);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: w,
          );
        },
        home: SplashPage(),
        onGenerateRoute: (RouteSettings settings) {
          var routeResult = getRouteResult(
              name: settings.name, arguments: settings.arguments);

          if (routeResult.showStatusBar != null ||
              routeResult.routeName != null) {
            settings = FFRouteSettings(
                arguments: settings.arguments,
                name: settings.name,
                isInitialRoute: settings.isInitialRoute,
                routeName: routeResult.routeName,
                showStatusBar: routeResult.showStatusBar);
          }

          var page = routeResult.widget ?? NoRoute();

          switch (routeResult.pageRouteType) {
            case PageRouteType.material:
              return MaterialPageRoute(
                  settings: settings, builder: (c) => page);
            case PageRouteType.cupertino:
              return CupertinoPageRoute(
                  settings: settings, builder: (c) => page);
            case PageRouteType.transparent:
              return Platform.isIOS
                  ? TransparentCupertinoPageRoute(
                      settings: settings, builder: (c) => page)
                  : TransparentMaterialPageRoute(
                      settings: settings, builder: (c) => page);
//            return FFTransparentPageRoute(
//                settings: settings,
//                pageBuilder: (BuildContext context, Animation<double> animation,
//                        Animation<double> secondaryAnimation) =>
//                    page);
            default:
              return Platform.isIOS
                  ? CupertinoPageRoute(settings: settings, builder: (c) => page)
                  : MaterialPageRoute(settings: settings, builder: (c) => page);
          }
        },
      ),
    );
  }

  static getTheme({bool isDark = false}) {
    return isDark ? darkThemeData : themeData;
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// 退出 APP
  static Future<void> exitApp() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  ///save netwrok image to photo
  static Future<bool> saveNetworkImageToPhoto(String url,
      {bool useCache: true}) async {
    var data = await getNetworkImageData(url, useCache: useCache);
    var filePath = await ImagePickerSaver.saveFile(fileData: data);
    return filePath != null && filePath != "";
  }
}
