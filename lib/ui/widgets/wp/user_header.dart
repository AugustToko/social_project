import 'package:flutter/material.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:social_project/utils/widget_default.dart';

/// 根据 wp 所给 userId 获取 user 头像、用户名
class WpUserHeader extends StatefulWidget {
  static String defaultIcon = "";

  final int userId;

  /// 选择 Wordpress 源
  final WpSource wpSource;

  final bool showUserName;

  final double radius;

  final bool canClick;

  WpUserHeader(
      {Key key,
      this.userId = -1,
      this.wpSource = WordPressRep.defaultWpSource,
      this.radius = 25.0,
      this.canClick = true,
      this.showUserName = true})
      : super(key: key);

  @override
  _WpUserHeaderState createState() =>
      _WpUserHeaderState();
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
        NetTools.getWpUserInfo(WordPressRep.getWpLink(widget.wpSource), widget.userId)
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
            ? WidgetDefault.defaultCircleAvatar(context)
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
            onTap: () {
              Navigator.pushNamed(context, UIData.profile,
                  arguments: {"wpUserId": widget.userId});
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
