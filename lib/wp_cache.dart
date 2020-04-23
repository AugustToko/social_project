import 'package:flutter/material.dart';
import 'package:wpmodel/model/wp_user.dart';

class WpCacheModel extends ChangeNotifier {
  WpUser _userCache;

  WpUser get userCache => _userCache;

  set userCache(final WpUser user) {
    if (user != null && user.avatarUrls.s96 != null) {
      _userCache = user;
      notifyListeners();
    }
  }
}
