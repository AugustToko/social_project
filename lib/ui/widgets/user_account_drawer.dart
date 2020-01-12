import 'package:flutter/material.dart';
import 'package:social_project/utils/log.dart';
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
                            Navigator.pushNamed(context,
                                App.login ? UIData.profile : UIData.login);
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
                  LogUtils.d("onDetailsPressed", "");
                },
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
              new ClipRect(
                child: new ListTile(
                  leading: new CircleAvatar(child: new Text("A")),
                  title: new Text('Drawer item A'),
                  onTap: () => {},
                ),
              ),
              new ClipRect(
                child: new ListTile(
                  leading: new CircleAvatar(child: new Text("B")),
                  title: new Text('Drawer item B'),
                  onTap: () => {},
                ),
              ),
              new ClipRect(
                child: new ListTile(
                  leading: new CircleAvatar(child: new Text("B")),
                  title: new Text('Drawer item B'),
                  onTap: () => {},
                ),
              ),
              new ClipRect(
                child: new ListTile(
                  leading: new CircleAvatar(child: new Text("B")),
                  title: new Text('Drawer item B'),
                  onTap: () => {},
                ),
              ),
              new ClipRect(
                child: new ListTile(
                  leading: new CircleAvatar(child: new Text("S")),
                  title: new Text('Settings'),
                  onTap: () {
                    Navigator.pushNamed(context, UIData.settingsPage);
                  },
                ),
              ),
              new ListTile(
                title: Text(
                  "Opt 1",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
              new ListTile(
                title: Text(
                  "Opt 2",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.green,
                ),
              ),
              new ListTile(
                title: Text(
                  "Opt 3",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.dashboard,
                  color: Colors.red,
                ),
              ),
              new ListTile(
                title: Text(
                  "Opt 4",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.timeline,
                  color: Colors.cyan,
                ),
              ),
              Divider(),
              new ListTile(
                title: Text(
                  "Opt 5",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
                leading: Icon(
                  Icons.settings,
                  color: Colors.brown,
                ),
              ),
              Divider(),
              MyAboutTile()
            ],
          ),
        ));
  }
}
