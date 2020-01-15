import 'package:http_client_helper/http_client_helper.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'dart:async';
import 'dart:convert';

import 'package:social_project/model/tuchong/tu_chong_source.dart';
import 'package:social_project/utils/log.dart';

class TuChongRepository extends LoadingMoreBase<TuChongItem> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;

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
    // 解析 URL
    String url = "";
    if (this.length == 0) {
      url = "https://api.tuchong.com/feed-app";
    } else {
      int lastPostId = this[this.length - 1].postId;
      url =
          "https://api.tuchong.com/feed-app?post_id=$lastPostId&page=$pageIndex&type=loadmore";
    }

    LogUtils.d("LoadData url: ", url);

    // 标志位
    bool isSuccess = false;
    try {
      var result = await HttpClientHelper.get(url);
      var source = TuChongSource.fromJson(json.decode(result.body));

      if (pageIndex == 1) {
        this.clear();
      }

      for (var item in source.feedList) {
        if (item.hasImage && !this.contains(item) && hasMore) this.add(item);
      }

      _hasMore = source.feedList.length != 0;
      pageIndex++;
//      this.clear();
//      _hasMore=false;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
