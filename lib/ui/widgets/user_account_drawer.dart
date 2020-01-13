import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/uidata.dart';

import '../../main.dart';
import 'about_tile.dart';

/// 显示用户账户的 Drawer
class UserAccountDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Theme.of(context).backgroundColor),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  UIData.developerName,
                ),
                accountEmail: Text(
                  UIData.developerEmail,
                ),
                currentAccountPicture: Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4"),
                    )),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              CacheCenter.tokenCache == null
                                  ? UIData.login
                                  : UIData.profile,
                            );
                          },
                          customBorder: CircleBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                // 箭头同标题颜色
                arrowColor: Theme.of(context).textTheme.title.color,
//                onDetailsPressed: () {
//                  showMenu<String>(
//                      context: context,
//                      position: RelativeRect.fromLTRB(0, 0, 0, 0),
//                      items: [PopupMenuItem(child: Text("Menu"))]);
//                },
                otherAccountsPictures: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4"),
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
                  Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4"),
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
                  Stack(
                    children: <Widget>[
                      Positioned.fill(
                          child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://avatars1.githubusercontent.com/u/20200460?s=460&v=4"),
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
                ],
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
