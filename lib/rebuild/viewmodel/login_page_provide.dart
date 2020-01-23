import 'dart:convert';

import 'package:dio/dio.dart';
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

  Observable login() => _repo
      .login(username, password)
      .doOnData((r) {
        CacheCenter.tokenCache = WpLoginResultDone.fromJson(json.decode(r));
      })
      .doOnError((e, stacktrace) {
        if (e is DioError) {
          print(e.response.data.toString());
        }
      })
      .doOnListen(() => loading = true)
      .doOnDone(() => loading = false);
}
