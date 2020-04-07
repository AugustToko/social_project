import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/config/cache_center.dart';
import 'package:shared/model/wordpress/wp_post_source.dart';
import 'package:shared/model/wordpress/wp_user.dart';
import 'package:shared/mvvm/view/base.dart';
import 'package:shared/rep/wp_rep.dart';
import 'package:shared/util/net_util.dart';
import 'package:shared/util/toast.dart';
import 'package:social_project/rebuild/view/page/wp_page.dart';
import 'package:social_project/utils/uidata.dart';

/// ViewModel 层
/// 通过 [notifyListeners] 通知UI层更新
class ProfileCoolApkPageProvider extends BaseProvide {
  /// 用于最新 5 篇文章数据存储
  final List<Widget> _posts = [];

  List<Widget> get posts => _posts;

//  set posts(List<Widget> widgets){
//    _posts.addAll(widgets);
//    notifyListeners();
//  }

  WpPostSource source;

  bool destroy = false;

  WpUser _wpUser = WpUser.defaultUser;

  WpUser get wpUser => _wpUser;

  set wpUser(WpUser user) {
    _wpUser = user;
    notifyListeners();
  }

  int wpUserId;

  var needChangeColor = false;

  var iconTheme = IconThemeData(color: Colors.grey);

  Size deviceSize;

  @override
  void init(final BuildContext context) {
    final double margin = ScreenUtil().setWidth(22);
    // 清除数据
    _posts.clear();

    // 更新 _wpUser
    NetTools.getAndSaveWpUser(wpUserId).then((user) {
      if (user == null) {
        Navigator.of(context).pop();
        showErrorToast(context, "获取用户失败!");
      } else {
        wpUser = user;
      }
    });

    /// TODO: 使用 LoadMoreListView
    NetTools.getAllPosts(wpUserId).then((wpPostSource) {
      WpCacheCenter.putPosts(wpUserId, wpPostSource);
      source = wpPostSource;
      return wpPostSource;
    }).then((wpSource) {
      if (wpSource.feedList.length == 0) {
        notifyListeners();
        return;
      }
      wpSource.feedList.reversed
          .skip(wpSource.feedList.length - 5)
          .toList()
          .reversed
          .forEach(
        (post) {
          posts.add(WordPressPageContentState.buildCard(context, post, 0));
        },
      );
      notifyListeners();
    });
  }

  /// 查看更多 Posts
  morePosts(final BuildContext context) {
    Navigator.pushNamed(
      context,
      UIData.argPostsPage,
      arguments: {
        "url": WordPressRep.getWpLink(WordPressRep.wpSource) +
            WordPressRep.postsOfAuthorX +
            _wpUser.id.toString(),
        "appBar": AppBar(
          title: Text(_wpUser.name + " 的全部文章"),
        )
      },
    );
  }
}
