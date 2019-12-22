import 'package:flutter/material.dart';
import 'package:social_project/utils/uidata.dart';

import '../../main.dart';

/// 关于页面瓷砖
class MyAboutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      applicationIcon: FlutterLogo(
        colors: App.themeData.primaryColor,
      ),
      icon: FlutterLogo(
        colors: App.themeData.primaryColor,
      ),
      aboutBoxChildren: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Developed By ${UIData.developerName}",
        ),
      ],
      applicationName: UIData.appName,
      applicationVersion: "0.0.1_Dev1",
    );
  }
}
