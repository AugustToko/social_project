import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared/login_sys/cache_center.dart';
import 'package:shared/model/wordpress/wp_user.dart';
import 'package:shared/rep/wp_rep.dart';
import 'package:shared/ui/widget/widget_default.dart';
import 'package:shared/util/net_util.dart';

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
  final bool canClick;

  /// 是否专门用于已登录用户的头像展示
  final bool forUser;

  final loginRouteName;

  WpUserHeader(
      {Key key,
      this.userId = -1,
      this.wpSource = WordPressRep.wpSource,
      this.radius = 25.0,
      this.canClick = true,
      this.showUserName = true,
      this.forUser = false,
      @required this.loginRouteName})
      : super(key: key);

  @override
  _WpUserHeaderState createState() => _WpUserHeaderState();
}

class _WpUserHeaderState extends State<WpUserHeader> {
  var _wpUser = WpUser.defaultUser;
  final double margin = ScreenUtil().setWidth(22);

  @override
  void initState() {
    super.initState();

    // 检查 userId
    if (widget.userId != -1) {
      // 检查缓存
      _wpUser = CacheCenter.getUser(widget.userId);
      if (_wpUser.id == -1) {
        NetTools.getWpUserInfo(
                WordPressRep.getWpLink(widget.wpSource), widget.userId)
            .then((user) {
          if (user != null) {
            _wpUser = user;
            setState(() {});
          } else {
            showToast("未找到相关 WpUser.");
            Navigator.pop(context);
          }
        });
      }
    }
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
      children: <Widget>[stack],
    );

    if (widget.canClick) {
      stack.children.add(Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              if (widget.forUser && CacheCenter.tokenCache == null) {
                Navigator.pushNamed(context, widget.loginRouteName)
                    .then((result) {
                  if (result == NavState.LoginDone) {
                    setState(() {
                      _wpUser =
                          CacheCenter.getUser(CacheCenter.tokenCache.userId);
                    });
                    goToProfilePage(CacheCenter.tokenCache.userId);
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
        Text(_wpUser.name),
      ]);
    }

    return myWidget;
  }

  void goToProfilePage(final int userId) {
    Navigator.pushNamed(context, widget.loginRouteName,
        arguments: {"wpUserId": userId});
  }
}
