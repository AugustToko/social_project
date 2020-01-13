import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/log.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/uidata.dart';

class LoginPage extends StatelessWidget {

  final userController = TextEditingController();
  final passwordController = TextEditingController();

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
            "Welcome to ${UIData.appName}",
            style: TextStyle(fontWeight: FontWeight.w700, color: Colors.green),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "Sign in to continue",
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
                  hintStyle: TextStyle(color: Theme.of(context).textTheme.title.color),
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.title.color),
                  hintText: "Enter your username",
                  labelText: "Username",
                ),
                controller: userController,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Theme.of(context).textTheme.title.color),
                  labelStyle: TextStyle(color: Theme.of(context).textTheme.title.color),
                  hintText: "Enter your password",
                  labelText: "Password",
                ),
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
                  "SIGN IN",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () {
                  LogUtils.d("LoginPage", "Login Button Pressed!");
                  NetTools.getWpLoginResult(WordPressRep.baseBlogGeekUrl, userController.text, passwordController.text).then((wpLoginResult){
                    if (wpLoginResult.token != null) {
                      CacheCenter.putToken(wpLoginResult);
                      Navigator.pop(context);
                    } else {
                      showToast("UserName or Password error!");
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "SIGN UP FOR AN ACCOUNT",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
}
