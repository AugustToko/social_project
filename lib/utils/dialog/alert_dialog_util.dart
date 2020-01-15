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

  static void showExitDialog(final BuildContext context) {
    showAlertDialog(context, "Exit", "Are you sure?", [
      FlatButton(
          onPressed: () {
            App.exitApp();
          },
          child: Text("Sure")),
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"))
    ]);
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
