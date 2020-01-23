import 'package:flutter/material.dart';
import 'package:social_project/model/wordpress/wp_login_result.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/uidata.dart';

///
///  create by zmtzawqlp on 2019/8/23
///
double initScale({Size imageSize, Size size, double initialScale}) {
  var n1 = imageSize.height / imageSize.width;
  var n2 = size.height / size.width;
  if (n1 > n2) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    Size destinationSize = fittedSizes.destination;
    return size.width / destinationSize.width;
  } else if (n1 / n2 < 1 / 4) {
    final FittedSizes fittedSizes =
        applyBoxFit(BoxFit.contain, imageSize, size);
    //final Size sourceSize = fittedSizes.source;
    Size destinationSize = fittedSizes.destination;
    return size.height / destinationSize.height;
  }

  return initialScale;
}

/// 获取权限组
String getWpUserCap(final UserCaps caps) {
  if (caps.administrator) return "${UIData.appName} 管理员";
  if (caps.subscriber) return "订阅者";
  return '';
}

Future<WpUser> getWpUserNew(final int id) async {
  WpUser wpUser = CacheCenter.getUser(id);
  if (wpUser.id == -1) {
    wpUser = await NetTools.getWpUserInfoAuto(id);
  }

  if (wpUser.id > 0) {
    CacheCenter.putUser(id, wpUser);
  }

  return wpUser;
}

class AspectRatioItem {
  final String text;
  final double value;

  AspectRatioItem({this.value, this.text});
}
