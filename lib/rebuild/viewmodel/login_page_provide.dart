import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_project/model/wordpress/wp_login_result.dart';
import 'package:social_project/utils/cache_center.dart';

import '../model/repository.dart';
import '../view/base.dart';

/// ViewModel 层
/// 通过 [notifyListeners] 通知UI层更新
class LoginPageProvider extends BaseProvide {
  final WordPressNewRepo _repo;
  String username = "";
  String password = "";
  bool _loading = false;

  var userNameController = TextEditingController();
  var passwordController = TextEditingController();

  var _rememberPassword = false;

  bool get rememberPassword => _rememberPassword;

  set rememberPassword(bool val) {
    _rememberPassword = val;
    notifyListeners();
  }

  final String title;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  double _btnWidth = 295.0;

  double get btnWidth => _btnWidth;

  set btnWidth(double btnWidth) {
    _btnWidth = btnWidth;
    notifyListeners();
  }

  LoginPageProvider(this.title, this._repo);

  void initData() {
    var data = _repo.getAuth();

    if (data == null || data == '') {
      clearAuth();
    } else {
      var temp = data.split(':');
      userNameController.text = temp[0];
      username = temp[0];
      passwordController.text = temp[1];
      password = temp[1];
      rememberPassword = true;
    }
  }

  Observable login() => _repo
      .login(username, password)
      .doOnData((r) {
        var tempData = WpLoginResultDone.fromJson(json.decode(r));
        if (tempData.token != null && tempData.token != "") {
          CacheCenter.tokenCache = tempData;

          if (_rememberPassword) {
            saveAuth();
          } else {
            clearAuth();
          }
        } else {
          CacheCenter.tokenCache = null;
        }
      })
      .doOnError((e, stacktrace) {
        if (e is DioError) {
          print(e.response.data.toString());
        }
      })
      .doOnListen(() => loading = true)
      .doOnDone(() => loading = false);

  void saveAuth() {
    _repo.saveAuth(username, password);
  }

  void clearAuth() {
    rememberPassword = false;
    _repo.clearAuth();
  }
}
