import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/config/cache_center.dart';
import 'package:shared/util/dialog_util.dart';
import 'package:social_project/ui/page/debug_page.dart';
import 'package:social_project/utils/uidata.dart';

/// Drawer
class CommonDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonDrawerState();
  }
}

/// 显示用户账户的 Drawer
class _CommonDrawerState extends State<CommonDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme
              .of(context)
              .backgroundColor,
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
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setWidth(40),
                  ),
                  ExtendedImage.asset(
                    "assets/images/logo.jpg",
                    height: 80,
                  ),
//                Padding(
//                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      Text(
//                        UIData.appNameFull,
//                        style: TextStyle(
//                            fontSize: ScreenUtil().setSp(45),
//                            color: Theme.of(context).textTheme.subtitle.color,
//                            fontWeight: FontWeight.bold),
//                      )
//                    ],
//                  ),
//                ),
                  ClipRect(
                    child: WpCacheCenter.tokenCache == null
                        ? Container()
                        : Column(
                      children: <Widget>[
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text('登出'),
                          onTap: () {
                            DialogUtil.showLogoutDialog(context, () {
                              WpCacheCenter.tokenCache = null;
                              setState(() {});
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Divider(),
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
                  ClipRect(
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Debug'),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                              return DebugPage();
                            }));
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
