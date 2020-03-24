import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:share/share.dart';
import 'package:shared/login_sys/cache_center.dart';
import 'package:shared/model/wordpress/wp_user.dart';
import 'package:shared/rep/wp_rep.dart';
import 'package:shared/util/alert_dialog_util.dart';
import 'package:shared/util/net_util.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileContent extends StatefulWidget {
  final WpSource wpSource;

  ProfileContent(this.wpSource);

  @override
  _ProfileContentState createState() {
    return _ProfileContentState(wpSource);
  }
}

class _ProfileContentState extends State<ProfileContent> {
  final WpSource wpSource;

  var archiveCount = 50;

  _ProfileContentState(this.wpSource);

  WpUser _wpUser = WpUser.defaultUser;

  @override
  Widget build(BuildContext context) {
    if (WpCacheCenter.tokenCache != null) {
      _wpUser = WpCacheCenter.getUser(WpCacheCenter.tokenCache.userId);
    }

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("我的资料"),
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: _wpUser.id == -1
                    ? CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 25,
                        child: Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.grey,
                        ),
                      )
                    : CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(_wpUser.avatarUrls.s96)),
                title: buildText(context, _wpUser.name),
                trailing: buildArrowIcon(context, Icons.keyboard_arrow_right),
                onTap: () {
                  if (WpCacheCenter.tokenCache == null) {
                    Navigator.pushNamed(context, UIData.loginPage)
                        .then((result) {
                      if (result == NavState.LoginDone) {
                        setState(() {});
                      }
                    });
                  } else {
                    Navigator.of(context).pushNamed(UIData.profile,
                        arguments: {"wpUserId": WpCacheCenter.tokenCache.userId});
                  }
                },
                subtitle: Text(
                  "查看个人资料",
                  style:
                      TextStyle(color: Theme.of(context).textTheme.title.color),
                ),
              ),
              Divider(),
              WpCacheCenter.tokenCache == null
                  ? Container()
                  : Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.message,
                            color: Colors.green,
                          ),
                          title: buildText(context, "消息"),
                          trailing: buildArrowIcon(context, Icons.arrow_right),
                          onTap: () {
                            //TODO: 消息
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.archive,
                            color: Colors.purple,
                          ),
                          title: buildText(context, "草稿箱"),
                          trailing: buildArrowIcon(context, Icons.arrow_right),
                          onTap: () {
                            //TODO: 草稿箱
                            Navigator.pushNamed(context, UIData.draftBoxPage);
                          },
                        )
                      ],
                    ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.share,
                  color: Colors.cyan,
                ),
                title: Text('推荐给好友'),
                trailing: buildArrowIcon(context, Icons.arrow_right),
                onTap: () {
                  Share.share("https://blog.geek-cloud.top/");
                  //TODO: 推荐给好友
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.thumb_up,
                  color: Colors.blue,
                ),
                title: Text('给 ${UIData.appName} 一个好评'),
                trailing: buildArrowIcon(context, Icons.arrow_right),
                onTap: () {
                  //TODO: 给 ${UIData.appName} 一个好评
                  FlutterWebBrowser.openWebPage(
                      url: "http://www.coolapk.com/u/430423",
                      androidToolbarColor: Theme.of(context).primaryColor);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.mail,
                  color: Colors.orange,
                ),
                title: Text('联系我们'),
                trailing: buildArrowIcon(context, Icons.arrow_right),
                onTap: () {
                  launch("mailto:827266641@qq.com");
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
                title: Text('设置'),
                trailing: buildArrowIcon(context, Icons.arrow_right),
                onTap: () {
                  Navigator.pushNamed(context, UIData.settingsPage);
                },
              ),
              Divider(),
              WpCacheCenter.tokenCache == null
                  ? Container()
                  : Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                          ),
                          title: buildText(context, "登出"),
                          trailing: buildArrowIcon(context, Icons.arrow_right),
                          onTap: () {
                            DialogUtil.showLogoutDialog(context, () {
                              WpCacheCenter.tokenCache = null;
                              _wpUser = WpUser.defaultUser;
                              setState(() {});
                            });
                          },
                        )
                      ],
                    ),
            ],
          ),
        ));
  }

  Text buildText(BuildContext context, String content) {
    return Text(
      content,
      style: TextStyle(color: Theme.of(context).textTheme.title.color),
    );
  }

  Icon buildArrowIcon(BuildContext context, IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).textTheme.title.color,
    );
  }
}
