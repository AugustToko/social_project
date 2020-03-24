import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/model/wordpress/wp_user.dart';
import 'package:shared/ui/widget/widget_default.dart';
import 'package:shared/util/net_util.dart';
import 'package:shared/util/theme_util.dart';

/// 根据 wp 所给 userId 获取 user 头像、用户名
class WpUserHeader extends StatefulWidget {
  /// 用户ID
  final int userId;

  /// 是否显示用户名
  final bool showUserName;

  /// 图像半径
  final double radius;

  final Function() onClick;

  WpUserHeader(
      {Key key,
      this.userId = -1,
      this.radius = 25.0,
      this.showUserName = true,
        this.onClick})
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

    if (widget.onClick == null) clickable = false;

    NetTools.getAndSaveWpUser(widget.userId).then((user) {
      if (user != null) {
        setState(() {
          _wpUser = user;
        });
      } else {
        clickable = false;
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

    if (widget.onClick != null) {
      stack.children.add(Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onClick,
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
}
