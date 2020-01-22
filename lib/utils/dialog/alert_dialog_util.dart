import 'dart:async';

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

  static Future<bool> showExitEditorDialog(
      final BuildContext context, final bool needBackup) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(needBackup ? '请问是否需要保存到草稿箱？' : '是否退出编辑？'),
          content: Text(needBackup ? "我们发现您已经编辑了一些内容，请问是否保存它们？" : '您即将离开编辑页面！'),
          actions: needBackup
              ? <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('不用'),
                  ),
                  FlatButton(
                    onPressed: () {
                      //TODO: 保存操作
                      Navigator.of(context).pop(true);
                    },
                    child: Text('保存'),
                  ),
                ]
              : <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('确定'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('取消'),
                  ),
                ],
        );
      },
    );
  }

  static void showLogoutDialog(
      final BuildContext context, Function afterLogout) {
    showAlertDialog(context, "登出", "即将退出登陆，请确认。", [
      FlatButton(
          onPressed: () {
            afterLogout();
            showToast(
              "您已退出登陆。",
              position: ToastPosition.bottom,
            );
            Navigator.pop(context);
          },
          child: Text("登出")),
      FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("取消"))
    ]);
  }
}
