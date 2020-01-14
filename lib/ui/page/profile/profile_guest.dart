import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/ui/page/profile/profile_page.dart';
import 'package:social_project/utils/cache_center.dart';
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

  @override
  Widget build(BuildContext context) {
    return CacheCenter.tokenCache == null
        ? Scaffold(
            appBar: AppBar(
              title: Text("Profile Guest"),
            ),
            body: Center(
              child: MaterialButton(
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  Navigator.pushNamed(context, UIData.loginPage).then((result) {
                    if (result == NavState.LoginDone) {
                      setState(() {});
                    }
                  });
                },
                color: Colors.blue,
              ),
            ),
          )
        : ProfilePage(CacheCenter.tokenCache.userId);
  }
}
