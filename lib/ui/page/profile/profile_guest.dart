import 'package:flutter/material.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';
import 'package:social_project/utils/route/example_route.dart';
import 'package:social_project/utils/uidata.dart';

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

  _ProfileContentState(this.wpSource);

  WpUser _wpUser = WpUser.defaultUser;

  @override
  Widget build(BuildContext context) {
    if (CacheCenter.tokenCache != null) {
      _wpUser = CacheCenter.getUser(CacheCenter.tokenCache.userId);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Me"),
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
                  if (CacheCenter.tokenCache == null) {
                    Navigator.pushNamed(context, UIData.loginPage)
                        .then((result) {
                      if (result == NavState.LoginDone) {
                        setState(() {});
                      }
                    });
                  } else {
                    Navigator.of(context).pushNamed(UIData.profile,
                        arguments: {"wpUserId": CacheCenter.tokenCache.userId});
                  }
                },
                subtitle: Text(
                  "View profile",
                  style:
                      TextStyle(color: Theme.of(context).textTheme.title.color),
                ),
              ),
              Divider(),
              CacheCenter.tokenCache == null
                  ? Container()
                  : Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.message,
                            color: Colors.green,
                          ),
                          title: buildText(context, "Message"),
                          trailing: buildArrowIcon(context, Icons.arrow_right),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Colors.orange,
                          ),
                          title: buildText(context, "Logout"),
                          trailing: buildArrowIcon(context, Icons.arrow_right),
                          onTap: () {
                            DialogUtil.showLogoutDialog(context, () {
                              CacheCenter.tokenCache = null;
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
