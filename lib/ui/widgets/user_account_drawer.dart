import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared/config/cache_center.dart';
import 'package:shared/model/wordpress/wp_user.dart';
import 'package:shared/ui/widget/about_tile.dart';
import 'package:shared/ui/widget/widget_default.dart';
import 'package:shared/util/alert_dialog_util.dart';
import 'package:shared/util/net_util.dart';
import 'package:social_project/rebuild/view/page/login_page.dart';
import 'package:social_project/rebuild/view/page/profile_coolapk_page.dart';
import 'package:social_project/utils/uidata.dart';

class UserAccountDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserAccountDrawerState();
  }
}

/// 显示用户账户的 Drawer
class _UserAccountDrawerState extends State<UserAccountDrawer> {
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
                InkWell(
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/timeline.jpeg",
                        fit: BoxFit.cover,
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          "assets/images/timeline.jpeg",
                          fit: BoxFit.cover,
                          color: Colors.black,
                        ),
                      ),
                      UserAccountsDrawerHeader(
                        decoration: BoxDecoration(color: Colors.transparent),
//                  decoration: BoxDecoration(
//                    image: DecorationImage(
//                      image: AssetImage("assets/images/timeline.jpeg"),
//                      fit: BoxFit.cover,
//                    ),
////                    gradient: LinearGradient(colors: UIData.kitGradients),
//                  ),
                        accountName: Text(
                          _wpUser.name,
                          style: TextStyle(color: Colors.white),
                        ),
                        accountEmail: Text(
                          // TODO: mail
                          "Building...",
                          style: TextStyle(color: Colors.white),
                        ),
                        currentAccountPicture: Stack(
                          children: <Widget>[
                            Positioned.fill(
                                child: WpCacheCenter.tokenCache == null
                                    ? WidgetDefault.defaultCircleAvatar(context,
                                        color: Colors.white)
                                    : CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            _wpUser.avatarUrls.s96),
                                      )),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    if (WpCacheCenter.tokenCache == null) {
                                      Navigator.pushNamed(
                                          context, LoginPage.loginPage,
                                          arguments: {
                                            "wpUserId": _wpUser.id
                                          }).then((result) {
                                        print(result);
                                        if (result == NavState.LoginDone) {
                                          setState(() {
                                            _wpUser = WpCacheCenter.getUser(
                                                WpCacheCenter
                                                    .tokenCache.userId);
                                          });
                                        }
                                      });
                                    } else {
                                      Navigator.pushNamed(
                                          context, ProfileCoolApkPage.profile,
                                          arguments: {"wpUserId": _wpUser.id});
                                    }
                                  },
                                  customBorder: CircleBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // 箭头同标题颜色
                        arrowColor: Colors.white,
                        onDetailsPressed: () {
                          showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(0, 0, 0, 0),
                            items: [
                              PopupMenuItem(child: Text("Menu")),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                  onTap: () {
                    DialogUtil.showAlertDialog(
                        context, "更换背景图", "是否需要更换背景图片?", [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("取消"),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("是"),
                      ),
                    ]);
                  },
                ),
                ClipRect(
                  child: WpCacheCenter.tokenCache == null
                      ? Container()
                      : ListTile(
                          leading: CircleAvatar(child: Icon(Icons.exit_to_app)),
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
                    leading: CircleAvatar(child: Icon(Icons.settings)),
                    title: Text('设置'),
                    onTap: () {
                      Navigator.pushNamed(context, UIData.settingsPage);
                    },
                  ),
                ),
//              ListTile(
//                title: Text(
//                  "Opt 4",
//                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
//                ),
//                leading: Icon(
//                  Icons.timeline,
//                  color: Colors.cyan,
//                ),
//                onTap: () {},
//              ),
//              Divider(),
//              ListTile(
//                title: Text(
//                  "Opt 5",
//                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
//                ),
//                leading: Icon(
//                  Icons.settings,
//                  color: Colors.brown,
//                ),
//                onTap: () {},
//              ),
                Divider(),
                MyAboutTile()
              ],
            )
          ],
        ),
      ),
    );
  }
}
