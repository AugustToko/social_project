import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/log.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/route/example_route.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final Map<String, bool> data = {"pressed": false};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loginBody(context),
      ),
    );
  }

  loginBody(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[loginHeader(), loginFields(context)],
        ),
      );

  loginHeader() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlutterLogo(
            colors: Colors.green,
            size: 80.0,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "欢迎来到 ${UIData.appName}",
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "登录以继续",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      );

  loginFields(BuildContext context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.title.color),
                    hintText: "输入你的用户名",
                    labelText: "用户名",
                    focusedBorder:
                        ThemeUtil.getUnderlineFocusedBorderBorder(context),
                    enabledBorder: ThemeUtil.getUnderlineEnabledBorderBorder()),
                controller: userController,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(
                        color: Theme.of(context).textTheme.title.color),
                    hintText: "输入你的密码",
                    labelText: "密码",
                    focusedBorder:
                        ThemeUtil.getUnderlineFocusedBorderBorder(context),
                    enabledBorder: ThemeUtil.getUnderlineEnabledBorderBorder()),
                controller: passwordController,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(12.0),
                shape: StadiumBorder(),
                child: Text(
                  "登陆",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () {
                  if (!data["pressed"]) {
                    data["pressed"] = false;
                    LogUtils.d("LoginPage", "Login Button Pressed!");
                    NetTools.getWpLoginResult(WordPressRep.baseBlogGeekUrl,
                            "chenlongcould", "18551348272Chen")
//                            userController.text, passwordController.text)
                        .then((wpLoginResult) {
                      if (wpLoginResult.token != null) {
                        CacheCenter.putToken(wpLoginResult);
                        NetTools.getWpUserInfoAuto(wpLoginResult.userId)
                            .then((user) {
                          if (user != null) {
                            showToast("登陆成功!", position: ToastPosition.bottom);
                            CacheCenter.putUser(wpLoginResult.userId, user);
                            Navigator.pop(context, NavState.LoginDone);
                          }
                        });
                      } else {
                        showToast("用户名或密码错误!", position: ToastPosition.bottom);
                        data["pressed"] = false;
                      }
                    });
                  } else {
                    showToast("登陆中...", position: ToastPosition.bottom);
                  }
                },
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.all(12.0),
                    shape: StadiumBorder(),
                    child: Text(
                      "注册新账号",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.title.color),
                    ),
                    color: Theme.of(context).backgroundColor,
                    elevation: 0,
                    onPressed: () {
                      launch(WordPressRep.blogGeekReg);
                    },
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.all(12.0),
                    shape: StadiumBorder(),
                    child: Text(
                      "忘记密码",
                      style: TextStyle(
                          color: Theme.of(context).textTheme.title.color),
                    ),
                    color: Theme.of(context).backgroundColor,
                    elevation: 0,
                    onPressed: () {
                      launch(WordPressRep.blogGeekLostPwd);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildButton(
    String text,
    Function onPressed, {
    Color color = Colors.white,
  }) {
    return FlatButton(
      color: color,
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
