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

  final WpSource wpSource;

  WpUserHeader({
    Key key,
    this.userId,
    this.wpSource,
  }) : super(key: key);

  @override
  _WpUserHeaderState createState() => _WpUserHeaderState(userId, wpSource);
}

class _WpUserHeaderState extends State<WpUserHeader> {
  final int _userId;
  final WpSource _wpSource;

  _WpUserHeaderState(this._userId,
      this._wpSource,) : super();

  @override
  Widget build(BuildContext context) {
    final double margin = ScreenUtil.instance.setWidth(22);

    var tempUser = CacheCenter.getUser(_userId);

    if (tempUser == null) {
      NetTools.getWpUserInfo(WordPressRep.getWpLink(_wpSource), _userId)
          .then((user) {
        CacheCenter.putUser(_userId, user);
        setState(() {});
      });
    }

    var widget = Row(
      children: <Widget>[
        // 头像
        Stack(
          children: <Widget>[
            CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                    (tempUser == null || tempUser.avatarUrls == null) ? WpUserHeader.defaultIcon : tempUser.avatarUrls.s96
                )),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, UIData.profile);
                  },
                  customBorder: CircleBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: margin,
        ),
        // TODO: 超出屏幕宽度
        // 用户名
        Text(tempUser == null ? "User" : tempUser.name),
      ],
    );
    return widget;
  }
}
