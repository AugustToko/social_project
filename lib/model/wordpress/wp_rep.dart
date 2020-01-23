import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'dart:async';
import 'dart:convert';

import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/utils/log.dart';
import 'package:social_project/utils/net_util.dart';

enum WpSource { BlogGeek, WeiRan, MMGal }

class WordPressRep extends LoadingMoreBase<WpPost> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;

  static const WpSource defaultWpSource = WpSource.BlogGeek;

  static const WpSource wpSource = defaultWpSource;

  /// BASE URL
  static const String baseWeiranUrl = "https://www.weiran.org.cn";
  static const String baseMmgalUrl = "https://www.mmgal.com";
  static const String baseBlogGeekUrl = "https://blog.geek-cloud.top";

  /// -------- GEEK BLOG ------------

  static const String blogGeekReg = "https://blog.geek-cloud.top/wp-login.php?action=register";
  static const String blogGeekLostPwd = "https://blog.geek-cloud.top/wp-login.php?action=lostpassword";

  /// 获取第 x 页
  static const String _posts = "/wp-json/wp/v2/posts?page=";

  /// 获取最新十篇文章
  static const String _posts2 = "/wp-json/wp/v2/posts";

//  static const String _urlBlogGeekPost = baseBlogGeekUrl + _posts;
//  static const String _urlWeiranPost = baseWeiranUrl + _posts;

  String url;
  static const String postsOfAuthorX = "/wp-json/wp/v2/posts?author=";

  WordPressRep(this.url);

  @override
  bool get hasMore => (_hasMore && length < 300) || forceRefresh;

  /// 刷新数据
  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    LogUtils.d("LoadData url: ", url);

    // 标志位
    bool isSuccess = false;
    try {
      var result =
          await HttpClientHelper.get(url + _posts + pageIndex.toString());

      var data = NetTools.checkData(url, result.body);

      var source = WpPostSource.fromJson(json.decode(data));

      if (pageIndex == 1) {
        this.clear();
      }

      for (var item in source.feedList) {
        if (!this.contains(item) && hasMore) this.add(item);
      }

      _hasMore = source.feedList.length != 0;
      pageIndex++;

      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }

  static String getWpLink(WpSource wpSource) {
    switch (wpSource) {
      case WpSource.BlogGeek:
        return baseBlogGeekUrl;
        break;
      case WpSource.WeiRan:
        return baseWeiranUrl;
        break;
      case WpSource.MMGal:
        return baseMmgalUrl;
        break;
    }
    return baseBlogGeekUrl;
  }
}
