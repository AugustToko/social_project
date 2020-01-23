import 'package:flutter/material.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/route/app_route.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:social_project/utils/widget_default.dart';

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

  final bool forUser;

  WpUserHeader(
      {Key key,
      this.userId = -1,
      this.wpSource = WordPressRep.wpSource,
      this.radius = 25.0,
      this.canClick = true,
      this.showUserName = true,
      this.forUser = false})
      : super(key: key);

  @override
  _WpUserHeaderState createState() => _WpUserHeaderState();
}

class _WpUserHeaderState extends State<WpUserHeader> {
  var _wpUser = WpUser.defaultUser;
  final double margin = ScreenUtil.instance.setWidth(22);

  @override
  void initState() {
    super.initState();
    if (widget.userId != -1) {
      _wpUser = CacheCenter.getUser(widget.userId);
      if (_wpUser.id == -1) {
        NetTools.getWpUserInfo(
                WordPressRep.getWpLink(widget.wpSource), widget.userId)
            .then((user) {
          // 检查
          if (user != null && user.id >= 0) {
            CacheCenter.putUser(widget.userId, user);
            _wpUser = user;
            setState(() {});
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
                Navigator.pushNamed(context, UIData.loginPage).then((result) {
                  if (result == NavState.LoginDone) {
                    setState(() {
                      _wpUser =
                          CacheCenter.getUser(CacheCenter.tokenCache.userId);
                    });
                  }
                });
              } else {
                Navigator.pushNamed(context, UIData.profile,
                    arguments: {"wpUserId": widget.userId});
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
}
