import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/ui/widgets/wp/user_header.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/uidata.dart';

import 'about_tile.dart';

class UserAccountWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserAccountDrawer();
  }
}

/// 显示用户账户的 Drawer
class UserAccountDrawer extends State<UserAccountWidget> {
  WpUser _wpUser = WpUser.defaultUser;

  @override
  void initState() {
    super.initState();
    if (CacheCenter.tokenCache != null) {
      _wpUser = CacheCenter.getUser(CacheCenter.tokenCache.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).backgroundColor,
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  _wpUser.name,
                ),
                accountEmail: Text(
                  // TODO: mail
                  "Building...",
                ),
                currentAccountPicture: Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: WpUserHeader(
                      wpSource: WordPressRep.wpSource,
                      showUserName: false,
                      userId: _wpUser.id,
                      radius: 35,
                      canClick: false,
                    )),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                CacheCenter.tokenCache == null
                                    ? UIData.loginPage
                                    : UIData.profile,
                                arguments: {"wpUserId": _wpUser.id});
                          },
                          customBorder: CircleBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                // 箭头同标题颜色
                arrowColor: Theme.of(context).textTheme.title.color,
                onDetailsPressed: () {
                  showMenu<String>(
                      context: context,
                      position: RelativeRect.fromLTRB(0, 0, 0, 0),
                      items: [PopupMenuItem(child: Text("Menu"))]);
                },
//                otherAccountsPictures: <Widget>[
//                  Stack(
//                    children: <Widget>[
//                      Positioned.fill(
//                          child: CircleAvatar(
//                        backgroundImage: NetworkImage(
//                            "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4"),
//                      )),
//                      Positioned.fill(
//                        child: Material(
//                          color: Colors.transparent,
//                          child: InkWell(
//                            onTap: () {
//                              Navigator.pushNamed(context, UIData.profile);
//                            },
//                            customBorder: CircleBorder(),
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Stack(
//                    children: <Widget>[
//                      Positioned.fill(
//                          child: CircleAvatar(
//                        backgroundImage: NetworkImage(
//                            "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4"),
//                      )),
//                      Positioned.fill(
//                        child: Material(
//                          color: Colors.transparent,
//                          child: InkWell(
//                            onTap: () {
//                              Navigator.pushNamed(context, UIData.profile);
//                            },
//                            customBorder: CircleBorder(),
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Stack(
//                    children: <Widget>[
//                      Positioned.fill(
//                          child: CircleAvatar(
//                        backgroundImage: NetworkImage(
//                            "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4"),
//                      )),
//                      Positioned.fill(
//                        child: Material(
//                          color: Colors.transparent,
//                          child: InkWell(
//                            onTap: () {
//                              Navigator.pushNamed(context, UIData.profile);
//                            },
//                            customBorder: CircleBorder(),
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ],
              ),
              ClipRect(
                child: ListTile(
                  leading: CircleAvatar(child: Text("A")),
                  title: Text('Drawer item A'),
                  onTap: () => {},
                ),
              ),
              ClipRect(
                child: ListTile(
                  leading: CircleAvatar(child: Text("B")),
                  title: Text('Drawer item B'),
                  onTap: () => {},
                ),
              ),
              ClipRect(
                child: ListTile(
                  leading: CircleAvatar(child: Text("B")),
                  title: Text('Drawer item B'),
                  onTap: () => {},
                ),
              ),
              ClipRect(
                child: ListTile(
                  leading: CircleAvatar(child: Text("B")),
                  title: Text('Drawer item B'),
                  onTap: () => {},
                ),
              ),
              ClipRect(
                child: ListTile(
                  leading: CircleAvatar(child: Text("S")),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pushNamed(context, UIData.settingsPage);
                  },
                ),
              ),
              ListTile(
                title: Text(
                  "Opt 1",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Opt 2",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.green,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Opt 3",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.dashboard,
                  color: Colors.red,
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  "Opt 4",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.timeline,
                  color: Colors.cyan,
                ),
                onTap: () {},
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Opt 5",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.settings,
                  color: Colors.brown,
                ),
                onTap: () {},
              ),
              Divider(),
              MyAboutTile()
            ],
          ),
        ));
  }
}
