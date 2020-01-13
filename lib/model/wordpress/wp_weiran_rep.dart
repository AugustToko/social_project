import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'dart:async';
import 'dart:convert';

import 'package:social_project/model/wordpress/wp_weiran.dart';
import 'package:social_project/utils/log.dart';

class WPweiranRep extends LoadingMoreBase<WPweiran> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;

  @override
  bool get hasMore => (_hasMore && length < 300) || forceRefresh;

  /// 刷新数据
  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = false;
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
    // 解析 URL
    String url = "https://www.weiran.org.cn/wp-json/wp/v2/posts";

    LogUtils.d("LoadData url: ", url);

    // 标志位
    bool isSuccess = false;
    try {
      var result = await HttpClientHelper.get(url);
      var source = WPweiranPostSource.fromJson(json.decode(result.body));

      for (var item in source.feedList) {
        this.add(item);
      }

      _hasMore = false;

      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
