import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/rebuild/viewmodel/login_page_provide.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/route/app_route.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';

import '../base.dart';

class LoginPage extends PageProvideNode<LoginPageProvider> {
  /// 提供
  ///
  /// 获取参数 [title] 并生成一个[HomeProvide]对象
  LoginPage(String title) : super(params: [title]);

  @override
  Widget buildContent(BuildContext context) {
    return _LoginPageContent(mProvider);
  }
}

/// View : 登录页面
class _LoginPageContent extends StatefulWidget {
  final LoginPageProvider provide;

  _LoginPageContent(this.provide);

  @override
  State<StatefulWidget> createState() {
    return LoginPageContentPageState();
  }
}

class LoginPageContentPageState extends State<_LoginPageContent>
    with TickerProviderStateMixin<_LoginPageContent>
    implements Presenter {
  LoginPageProvider mProvide;

  static const ACTION_LOGIN = "login";

  /// 处理动画
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    mProvide = widget.provide;
    mProvide.initData();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 295.0, end: 48.0).animate(_controller)
      ..addListener(() {
        mProvide.btnWidth = _animation.value;
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: Center(
        child: loginBody(context),
      ),
    );
  }

  loginBody(BuildContext context) =>
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[loginHeader(), loginFields(context)],
        ),
      );

  loginHeader() =>
      Column(
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

  loginFields(BuildContext context) =>
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                onChanged: (str) => mProvide.username = str,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  labelStyle: TextStyle(
                    color: Theme
                        .of(context)
                        .textTheme
                        .title
                        .color,
                  ),
                  hintText: "输入你的用户名",
                  labelText: "用户名",
                  focusedBorder:
                  ThemeUtil.getUnderlineFocusedBorderBorder(context),
                  enabledBorder: ThemeUtil.getUnderlineEnabledBorderBorder(),
                ),
                controller: mProvide.userNameController,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              child: TextField(
                maxLines: 1,
                onChanged: (str) => mProvide.password = str,
                obscureText: true,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.grey),
                  labelStyle: TextStyle(
                      color: Theme
                          .of(context)
                          .textTheme
                          .title
                          .color),
                  hintText: "输入你的密码",
                  labelText: "密码",
                  focusedBorder:
                  ThemeUtil.getUnderlineFocusedBorderBorder(context),
                  enabledBorder: ThemeUtil.getUnderlineEnabledBorderBorder(),
                ),
                controller: mProvide.passwordController,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: buildCheckBoxProvide(),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
              width: double.infinity,
              child: buildLoginBtnProvide(),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    padding: EdgeInsets.all(12.0),
                    shape: StadiumBorder(),
                    child: Text(
                      "注册新账号",
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .textTheme
                              .title
                              .color),
                    ),
                    color: Theme
                        .of(context)
                        .backgroundColor,
                    elevation: 0,
                    onPressed: () {
                      FlutterWebBrowser.openWebPage(
                          url: WordPressRep.blogGeekReg,
                          androidToolbarColor: Theme
                              .of(context)
                              .primaryColor);
//                      launch(WordPressRep.blogGeekReg);
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
                          color: Theme
                              .of(context)
                              .textTheme
                              .title
                              .color),
                    ),
                    color: Theme
                        .of(context)
                        .backgroundColor,
                    elevation: 0,
                    onPressed: () {
                      FlutterWebBrowser.openWebPage(
                          url: WordPressRep.blogGeekLostPwd,
                          androidToolbarColor: Theme
                              .of(context)
                              .primaryColor);
//                      launch(WordPressRep.blogGeekLostPwd);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      );

//  Widget buildButton(
//    String text,
//    Function onPressed, {
//    Color color = Colors.white,
//  }) {
//    return FlatButton(
//      color: color,
//      child: Text(text),
//      onPressed: onPressed,
//    );
//  }

  /// 登录按钮
  ///
  /// 当 [mProvide.loading] 为true 时 ，点击事件不生效
  Consumer<LoginPageProvider> buildCheckBoxProvide() {
    return Consumer<LoginPageProvider>(
      builder: (context, value, child) {
        // 使用 Consumer ,当 provide.notifyListeners() 时都会rebuild
        return CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: mProvide.rememberPassword,
          onChanged: (newValue) => mProvide.rememberPassword = newValue,
          title: Text('记住密码'),
//          secondary: Icon(Icons.vpn_key),
          selected: true,
          subtitle: Text("将您的信息加密保存在本地"),
          dense: true,
        );
      },
    );
  }

  /// 登录按钮
  ///
  /// 当 [mProvide.loading] 为true 时 ，点击事件不生效
  Consumer<LoginPageProvider> buildLoginBtnProvide() {
    return Consumer<LoginPageProvider>(
      builder: (context, value, child) {
        // 使用 Consumer ,当 provide.notifyListeners() 时都会rebuild
        return CupertinoButton(
          onPressed: value.loading ? null : () => onClick(ACTION_LOGIN),
          pressedOpacity: 0.8,
          child: Container(
            alignment: Alignment.center,
            width: value.btnWidth,
            height: 48,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                gradient: LinearGradient(colors: [
                  Color(0xFF686CF2),
                  Color(0xFF0E5CFF),
                ]),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x4D5E56FF),
                      offset: Offset(0.0, 4.0),
                      blurRadius: 13.0)
                ]),
            child: buildLoginChild(value),
          ),
        );
      },
    );
  }

  /// 登录按钮内部的 child
  ///
  /// 当请求进行时 [value.loading] 为 true 时,显示 [CircularProgressIndicator]
  /// 否则显示普通文本
  Widget buildLoginChild(LoginPageProvider value) {
    if (value.loading) {
      return const CircularProgressIndicator();
    } else {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '登录',
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white),
        ),
      );
    }
  }

  /// 登录
  void _login() {
    final s = mProvide.login().doOnListen(() {
      _controller.forward();
    }).doOnDone(() {
      _controller.reverse();
    }).listen((data) {
      if (CacheCenter.tokenCache != null) {
        showToast("登陆成功！");
        Navigator.pop(context, NavState.LoginDone);
      } else {
        showToast("登陆失败！", position: ToastPosition.bottom);
      }
    }, onError: (e) {
      print(e);
      showToast("登陆失败！");
    });
    mProvide.addSubscription(s);
  }

  @override
  void onClick(String action) {
    if (ACTION_LOGIN == action) {
      _login();
    }
  }
}
