import 'package:flutter/material.dart' hide CircularProgressIndicator;
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/uidata.dart';

/// 根据 wp 所给 userId 获取 user 头像
class WpUserIcon extends StatefulWidget {
  static String defaultIcon = "";

  //抽屉widget
  final int userId;

  WpUserIcon({
    Key key,
    this.userId,
  }) : super(key: key);

  @override
  _WpUserIconState createState() => _WpUserIconState(userId);
}

class _WpUserIconState extends State<WpUserIcon> {
  int userId;

  _WpUserIconState(
    this.userId,
  ) : super();

  @override
  Widget build(BuildContext context) {
    var tempUser = CacheCenter.getUser(userId);

    final double margin = ScreenUtil.instance.setWidth(22);

    var widget = Row(
      children: <Widget>[
        // 头像
        Stack(
          children: <Widget>[
            CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  tempUser == null
                      ? WpUserIcon.defaultIcon
                      : tempUser.avatarUrls.s96,
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
        Text(tempUser.name),
      ],
    );

    if (tempUser.avatarUrls.s96 == WpUserIcon.defaultIcon) {
      NetTools.getWpUserInfo(NetTools.weiranSite, userId).then((user) {
        CacheCenter.putUser(userId, user);
        setState(() {});
      });
    }

    return widget;
  }
}
