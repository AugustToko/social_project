import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shared/mvvm/view/base.dart';
import 'package:zefyr/zefyr.dart';

class EditorPageProvider extends BaseProvide {
  File headerImage;

  int _height = 300;

  int get height => _height;

  set height(int val) {
    _height = val;
    notifyListeners();
  }

  ZefyrController controller;

  @override
  void init(BuildContext context) {
    // TODO: implement init
  }

  void disposeControllers() {
    controller.dispose();
  }
}