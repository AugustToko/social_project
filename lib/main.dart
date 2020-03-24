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
import 'package:shared/config/global_settings.dart';
import 'package:social_project/rebuild/app_module.dart';
import 'package:social_project/rebuild/view/page/login_page.dart';
import 'package:social_project/rebuild/view/page/profile_coolapk_page.dart';
import 'package:social_project/ui/page/no_route.dart';
import 'package:social_project/ui/page/splash_page.dart';
import 'package:social_project/utils/route/app_route.dart';
import 'package:social_project/utils/route/example_route_helper.dart';
import 'package:social_project/utils/uidata.dart';

import 'env.dart';

void main() async {

  GlobalSettings.profileRouteName = ProfileCoolApkPage.profile;
  GlobalSettings.loginRouteName = LoginPage.loginPage;

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
      title: ThemeUtil.textOnLight,
      body1: ThemeUtil.textOnLight,
      subhead: ThemeUtil.textOnLight,
      // 用于 Drawer 中选项文字
      body2: ThemeUtil.textOnLight,
      subtitle: ThemeUtil.subtitle,
      button: ThemeUtil.textOnLight,
      // for [AboutListTile]
      headline: ThemeUtil.textOnLight,
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
        title: ThemeUtil.textOnDark,
        subhead: ThemeUtil.textOnDark,
        body1: ThemeUtil.textOnDark,
        body2: ThemeUtil.textOnDark,
        subtitle: ThemeUtil.subtitle,
        button: ThemeUtil.textOnDark,
        // for [AboutListTile]
        headline: ThemeUtil.textOnDark,
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
        supportedLocales: [
          const Locale("en", "US"),
          const Locale("zh", "CN"),
        ],
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

          return Platform.isIOS
              ? CupertinoPageRoute(settings: settings, builder: (c) => page)
              : MaterialPageRoute(settings: settings, builder: (c) => page);
        },
      ),
    );
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

    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(data));

    return result != null && result != "";
  }
}
