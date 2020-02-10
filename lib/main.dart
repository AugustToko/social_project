import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared/util/theme_util.dart';
import 'package:social_project/ui/page/no_route.dart';
import 'package:social_project/ui/page/splash_page.dart';
import 'package:social_project/utils/route/app_route.dart';
import 'package:social_project/utils/route/example_route_helper.dart';
import 'package:social_project/utils/uidata.dart';

import 'file:///C:/Users/chenlongcould/AndroidStudioProjects/social_project/lib/rebuild/app_module.dart';

import 'env.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // wait init
  await init();
  Provider.debugCheckInvalidValueType = null;
  runApp(App());
}

class App extends StatelessWidget {
  static String _pkg = "gooey_edge";

  static String get pkg => Env.getPackage(_pkg);

  static bool login = false;

  /// 亮色主题
  static var themeData = ThemeData(
    primarySwatch: Colors.green,
    primaryColor: Colors.green.shade200,
    scaffoldBackgroundColor: Colors.grey.shade200,
    backgroundColor: Colors.white,
    appBarTheme: AppBarTheme(elevation: 0.0, color: Colors.white),
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
    tabBarTheme: TabBarTheme(
        labelColor: Color(0xff01b87d),
        unselectedLabelColor: Colors.grey.shade700),
    cardTheme: CardTheme(color: Colors.white, elevation: 0),
//    canvasColor: Colors.grey.shade50,
    dialogTheme: DialogTheme(
      backgroundColor: Colors.grey.shade50,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.grey.shade50,
    ),
    // icon
    iconTheme: IconThemeData(color: Colors.grey.shade900),
    primaryIconTheme: IconThemeData(color: Colors.grey.shade900),
    accentIconTheme: IconThemeData(color: Colors.grey.shade900),
    // 分割线
    dividerTheme: DividerThemeData(
        color: Colors.grey.shade400.withOpacity(0.2), thickness: 1),
  );

  /// 深色主题
  static var darkThemeData = ThemeData(
      primarySwatch: Colors.grey,
      primaryColor: Colors.grey.shade900,
      scaffoldBackgroundColor: Colors.grey.shade900,
      backgroundColor: Colors.grey.shade900,
      appBarTheme: AppBarTheme(elevation: 0.0, color: Colors.grey.shade900),
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
      iconTheme: IconThemeData(color: Colors.grey.shade400),
      dividerTheme: DividerThemeData(
          color: Colors.grey.shade800.withOpacity(0.2), thickness: 1));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: UIData.appName,
        themeMode: ThemeMode.system,
        // 调试横幅
        debugShowCheckedModeBanner: true,
        // 主题
        theme: themeData,
        // 暗色主题
        darkTheme: darkThemeData,
//        supportedLocales: [
//          const Locale("en", "US"),
//          const Locale("hi", "IN"),
//          const Locale("hi", "IN"),
//        ],
        builder: (context, widget) {
          ScreenUtil.init(context,
              width: 1080, height: 1920, allowFontScaling: true);
          var data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: widget,
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

  /// save NetWork image to photo
  static Future<bool> saveNetworkImageToPhoto(final String url,
      {bool useCache: true}) async {
    var data = await getNetworkImageData(url, useCache: useCache);

//    var response = await Dio().get("/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg", options: Options(responseType: ResponseType.bytes));

    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(data));

    debugPrint(result);

    return result != null && result != "";
  }
}
