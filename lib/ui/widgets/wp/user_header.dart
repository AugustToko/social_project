import 'package:flutter/material.dart' hide CircularProgressIndicator;
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/uidata.dart';

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
  var tempUser = WpUser.defaultUser;
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
      tempUser = CacheCenter.getUser(_userId);
      if (tempUser == null) {
        NetTools.getWpUserInfo(WordPressRep.getWpLink(_wpSource), _userId)
            .then((user) {
          if (user != null && _userId >= 0) {
            CacheCenter.putUser(_userId, user);
            setState(() {});
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var stack = Stack(
      children: <Widget>[
        // 头像
        CircleAvatar(
            radius: _radius,
            backgroundImage: NetworkImage(
                (tempUser == null || tempUser.avatarUrls == null)
                    ? WpUserHeader.defaultIcon
                    : tempUser.avatarUrls.s96)),
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
        Text(tempUser.name),
      ]);
    }

    return widget;
  }
}
