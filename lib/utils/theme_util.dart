import 'package:flutter/material.dart';
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/ui/page/wordpress/send_page.dart';
import 'package:social_project/ui/widgets/navbar/navbar.dart';
import 'package:social_project/ui/widgets/wp/user_header.dart';

/// 主题工具
class ThemeUtil {
  static EdgeInsets cardPaddingEdgeInsets = EdgeInsets.fromLTRB(8, 8, 8, 0);

  static Card materialCard(final Widget widget) => Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        margin: cardPaddingEdgeInsets,
        child: widget,
      );

  static Card materialPostCard(final Widget widget, final WpPost item, final double margin) => Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        margin: cardPaddingEdgeInsets,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(margin),
              child: Row(
                children: <Widget>[
                  // 头像
                  WpUserHeader(
                    userId: item.author,
                    radius: 20,
                  ),
                  SizedBox(
                    width: margin,
                  ),
                  // TODO: 超出屏幕宽度
                  RichText(
                    maxLines: 1,
                    text: TextSpan(children: [
                      TextSpan(text: "${item.date}", style: ThemeUtil.subtitle)
                    ]),
                  )
                ],
              ),
            ),
            widget
          ],
        ),
      );

  /// 获取用于放在 [AppBar] 上的方形按钮
  static Widget squareOutLineButtonOnAppBar(
      String text, final Function() onTap, final Color color) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(width: 1.5, color: color)),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }

  static var textDark = TextStyle(color: Colors.grey.shade50);
  static var textLight = TextStyle(color: Colors.grey.shade900);
  static var subtitle = TextStyle(color: Colors.grey);
  static var iconCommonColor = Colors.grey;

  @Deprecated("null")
  static var appBarTheme = AppBarTheme(elevation: 0.0);

  @Deprecated("Use [Colors.grey.shade900]")
  static var backgroundDarkColor = Colors.grey.shade900;
  @Deprecated("Use [Colors.grey.shade50]")
  static var backgroundLightColor = Colors.grey.shade50;

  static var clipRRectBorderRadius = BorderRadius.circular(8.0);

  static InputBorder getUnderlineFocusedBorderBorder(
          final BuildContext context) =>
      UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).textTheme.title.color),
      );

  static InputBorder getUnderlineEnabledBorderBorder() =>
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey));

  /// [NavBar]
  static double navBarHeight = 64;

  /// 文章顶部图像
  /// [SendPage]
  static double headerImageHeight = 100;
}
