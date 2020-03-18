import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared/login_sys/cache_center.dart';
import 'package:shared/model/wordpress/wp_login_result.dart';
import 'package:shared/mvvm/model/repository.dart';
import 'package:shared/mvvm/view/base.dart';

/// ViewModel 层
/// 通过 [notifyListeners] 通知UI层更新
class LoginPageProvider extends BaseProvide {
  final WordPressMvvmRepo _repo;
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

  LoginPageProvider(this._repo);

  @override
  void init(BuildContext context) {
    var data = _repo.getAuth();

    if (data == null || data == '') {
      clearAuth();
    } else {
      var temp = data.split(WordPressMvvmRepo.splitChar);
      if (temp.length < 2) {
        return;
      }
      userNameController.text = temp[0];
      passwordController.text = temp[1];

      username = temp[0];
      password = temp[1];
      _rememberPassword = true;
    }
  }

  Observable login() => _repo
      .login(username, password)
      .doOnData((r) {
        var tempData = WpLoginResultDone.fromJson(json.decode(r));
        if (tempData.token != null && tempData.token != "") {
          WpCacheCenter.tokenCache = tempData;

          if (_rememberPassword) {
            saveAuth();
          } else {
            clearAuth();
          }
        } else {
          WpCacheCenter.tokenCache = null;
        }
      })
      .doOnError((e, stacktrace) {
        if (e is DioError) {
          print(e.response.data.toString());
        }
      })
      .doOnListen(() => loading = true)
      .doOnDone(() => loading = false);

  /// 保存密码
  void saveAuth() {
    _repo.saveAuth(username, password);
  }

  /// 清除登陆信息
  void clearAuth() {
    rememberPassword = false;
    _repo.clearAuth();
  }
}
