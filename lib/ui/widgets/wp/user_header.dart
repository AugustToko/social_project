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
      _WpUserHeaderState(userId, wpSource, radius, showUserName, canClick);
}

class _WpUserHeaderState extends State<WpUserHeader> {
  final int _userId;
  final WpSource _wpSource;
  final bool showUserName;
  final double _radius;
  final bool _canClick;
  var _wpUser = WpUser.defaultUser;
  final double margin = ScreenUtil.instance.setWidth(22);

  _WpUserHeaderState(
    this._userId,
    this._wpSource,
    this._radius,
    this.showUserName,
    this._canClick,
  ) : super();

  @override
  void initState() {
    super.initState();
    if (_userId != -1) {
      _wpUser = CacheCenter.getUser(_userId);
      if (_wpUser.id == -1) {
        NetTools.getWpUserInfo(WordPressRep.getWpLink(_wpSource), _userId)
            .then((user) {
              // 检查
          if (user != null && user.id >= 0) {
            CacheCenter.putUser(_userId, user);
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
                radius: _radius,
                backgroundImage: NetworkImage(_wpUser.avatarUrls.s96)),
      ],
    );

    var widget = Row(
      children: <Widget>[stack],
    );

    if (_canClick) {
      stack.children.add(Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, UIData.profile,
                  arguments: {"wpUserId": _userId});
            },
            customBorder: CircleBorder(),
          ),
        ),
      ));
    }

    if (showUserName) {
      widget.children.addAll([
        SizedBox(
          width: margin,
        ),
        // TODO: 超出屏幕宽度
        // 用户名
        Text(_wpUser.name),
      ]);
    }

    return widget;
  }
}
