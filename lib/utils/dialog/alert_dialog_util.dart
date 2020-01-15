import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../../main.dart';

class DialogUtil {
  static void showAlertDialog(final BuildContext context, final String title,
      final String content, final List<Widget> actions) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        semanticLabel: 'Label',
        actions: actions,
      ),
    );
  }

//  static void showExitDialog(final BuildContext context) {
//    showAlertDialog(context, "退出", "Are you sure?", [
//      FlatButton(
//          onPressed: () {
//            App.exitApp();
//          },
//          child: Text("Sure")),
//      FlatButton(
//          onPressed: () {
//            Navigator.pop(context);
//          },
//          child: Text("Cancel"))
//    ]);
//  }

  static Future<bool> showExitDialog(final BuildContext context) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('退出 Social Project'),
          content: Text("确定退出 Social Project? \r\n\r\nXD"),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('还是算了吧'),
            ),
            FlatButton(
              onPressed: () async {
                await App.exitApp();
              },
              child: Text('退出'),
            ),
          ],
        );
      },
    );
  }

  static void showLogoutDialog(
      final BuildContext context, Function afterLogout) {
    showAlertDialog(context, "Logout", "Are you sure?", [
      FlatButton(
          onPressed: () {
            afterLogout();
            showToast(
              "You are logged out.",
              position: ToastPosition.bottom,
            );
            Navigator.pop(context);
          },
          child: Text("Sure")),
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"))
    ]);
  }
}
