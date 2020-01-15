import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'dart:async';
import 'dart:convert';

import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/utils/log.dart';

/// https://blog.geek-cloud.top/wp-json/wp/v2/posts?author=1
class AuthorPostsRep extends LoadingMoreBase<WpPost> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;

  String url;
  int userId;

  AuthorPostsRep(this.url, this.userId);

  @override
  bool get hasMore => (_hasMore && length < 300) || forceRefresh;

  /// 刷新数据
  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    // force to refresh list when you don't want clear list before request
    // for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    // 标志位
    bool isSuccess = false;
    try {
      // https://blog.geek-cloud.top/wp-json/wp/v2/posts?author=1&per_page=20&page=1

      var result = await HttpClientHelper.get(url +
          WordPressRep.postsOfAuthorX +
          userId.toString() +
          "&per_page=20&page=$pageIndex");

      var data = result.body;

      // 去除 json 下的注释
      if (url.contains("mmgal")) {
        data = data.substring(0, data.indexOf("<!--"));
      }

      var source = WpPostSource.fromJson(json.decode(data));

      if (pageIndex == 1) {
        clear();
      }

      for (var item in source.feedList) {
        if (!contains(item) && hasMore) add(item);
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
}
