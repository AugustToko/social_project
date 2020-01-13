import 'package:http_client_helper/http_client_helper.dart';
import 'dart:async';
import 'dart:convert';

import 'package:social_project/model/wordpress/wp_user.dart';

class NetTools {
  static const String weiranSite = "https://www.weiran.org.cn";

  static Future<WpUser> getWpUserInfo(String webSite, int userId) async {
    // 解析 URL
    String url = webSite + "/wp-json/wp/v2/users/" + userId.toString();

    // 标志位
    WpUser data;
    try {
      var result = await HttpClientHelper.get(url);
      data = WpUser.fromJson(json.decode(result.body));

    } catch (exception, stack) {
      print(exception);
      print(stack);
    }
    return data;
  }
}
