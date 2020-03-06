import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/login_sys/cache_center.dart';
import 'package:shared/model/wordpress/wp_user.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';
import 'package:social_project/utils/uidata.dart';

class CommonDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonDrawerState();
  }
}

/// 显示用户账户的 Drawer
class _CommonDrawerState extends State<CommonDrawer> {
  WpUser _wpUser = WpUser.defaultUser;

  @override
  void initState() {
    super.initState();
    if (WpCacheCenter.tokenCache != null) {
      _wpUser = WpCacheCenter.getUser(WpCacheCenter.tokenCache.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Theme.of(context).backgroundColor,
      ),
      child: Drawer(
        child: Stack(
          children: <Widget>[
//            ClipRect(
//              child: BackdropFilter(
//                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//                child: Container(
//                  decoration: BoxDecoration(
//                      color:
//                          Theme.of(context).backgroundColor.withOpacity(0.7)),
//                ),
//              ),
//            ),
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: ScreenUtil().setWidth(80),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                  child: Row(
                    children: <Widget>[
                      FlutterLogo(
                        size: 35,
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(20),
                      ),
                      Text(
                        UIData.appName + "  Step By Step.",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(45),
                            color: Theme.of(context).textTheme.subtitle.color,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Divider(),
                ClipRect(
                  child: WpCacheCenter.tokenCache == null
                      ? Container()
                      : ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text('登出'),
                          onTap: () {
                            DialogUtil.showLogoutDialog(context, () {
                              WpCacheCenter.tokenCache = null;
                              _wpUser = WpUser.defaultUser;
                              setState(() {});
                            });
                          },
                        ),
                ),
                ClipRect(
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('设置'),
                    onTap: () {
                      Navigator.pushNamed(context, UIData.settingsPage);
                    },
                  ),
                ),
                Divider(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
