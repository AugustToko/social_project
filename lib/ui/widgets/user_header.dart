import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/login_sys/cache_center.dart';
import 'package:shared/model/wordpress/wp_user.dart';
import 'package:shared/rep/wp_rep.dart';
import 'package:shared/ui/widget/widget_default.dart';
import 'package:shared/util/net_util.dart';
import 'package:shared/util/theme_util.dart';

/// 根据 wp 所给 userId 获取 user 头像、用户名
class WpUserHeader extends StatefulWidget {
  static String defaultIcon = "";

  /// 用户ID
  final int userId;

  /// 选择 Wordpress 源
  final WpSource wpSource;

  /// 是否显示用户名
  final bool showUserName;

  /// 图像半径
  final double radius;

  /// 是否有点击事件
  final bool clickable;

  final loginRouteName;

  final profileRouteName;

  final bool needLogin;

  WpUserHeader(
      {Key key,
      this.userId = -1,
      this.wpSource = WordPressRep.wpSource,
      this.radius = 25.0,
      this.clickable = true,
      this.showUserName = true,
      @required this.loginRouteName,
      @required this.profileRouteName,
      this.needLogin = false})
      : super(key: key);

  @override
  _WpUserHeaderState createState() => _WpUserHeaderState();
}

class _WpUserHeaderState extends State<WpUserHeader> {
  var _wpUser = WpUser.defaultUser;
  final double margin = ScreenUtil().setWidth(22);
  var clickable;

  @override
  void initState() {
    super.initState();

    // 避免 Null 参数
    if (widget.profileRouteName != null && widget.loginRouteName != null) {
      clickable = false;
    } else {
      clickable = widget.clickable;
    }

    NetTools.getWpUser(widget.userId).then((user) {
      if (user != null) {
        setState(() {
          _wpUser = user;
        });
      } else {
        clickable = false;
//        showErrorToast(context, "未找到相关 WpUser.");
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    var stack = Stack(
      children: <Widget>[
        // 头像
        _wpUser.id == -1
            ? WidgetDefault.defaultCircleAvatar(context,
                size: widget.radius * 2)
            : CircleAvatar(
                radius: widget.radius,
                backgroundImage: NetworkImage(_wpUser.avatarUrls.s96)),
      ],
    );

    var myWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[stack],
    );

    if (widget.clickable) {
      stack.children.add(Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              if (WpCacheCenter.tokenCache == null && widget.needLogin) {
                Navigator.pushNamed(context, widget.loginRouteName)
                    .then((result) {
                  if (result == NavState.LoginDone) {
                    setState(() {
                      _wpUser = WpCacheCenter.getUser(
                          WpCacheCenter.tokenCache.userId);
                    });
                    goToProfilePage(WpCacheCenter.tokenCache.userId);
                  }
                });
              } else {
                goToProfilePage(_wpUser.id);
              }
            },
            customBorder: CircleBorder(),
          ),
        ),
      ));
    }

    if (widget.showUserName) {
      myWidget.children.addAll([
        SizedBox(
          width: margin,
        ),
        // TODO: 超出屏幕宽度
        // 用户名
        Text(
          _wpUser.name,
          style: TextStyle(fontSize: ThemeUtil.wpUserHeaderTextSize),
        ),
      ]);
    }

    return myWidget;
  }

  void goToProfilePage(final int userId) {
    if (widget.profileRouteName == null || widget.profileRouteName == '')
      return;
    debugPrint("GotoLogin...");
    Navigator.pushNamed(context, widget.profileRouteName,
        arguments: {"wpUserId": userId});
  }
}
