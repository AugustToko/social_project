import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/login_sys/cache_center.dart';
import 'package:shared/model/wordpress/wp_post_source.dart';
import 'package:shared/model/wordpress/wp_user.dart';
import 'package:shared/mvvm/view/base.dart';
import 'package:shared/rep/wp_rep.dart';
import 'package:shared/util/bottom_sheet.dart';
import 'package:shared/util/net_util.dart';
import 'package:shared/util/theme_util.dart';
import 'package:social_project/utils/route/app_route.dart';
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
    getWpUserNew(wpUserId).then((user) {
      wpUser = user;
    });

    NetTools.getAllPosts(wpUserId).then((wpPostSource) {
      CacheCenter.putPosts(wpUserId, wpPostSource);
      source = wpPostSource;
      return wpPostSource;
    }).then((wpSource) {
      wpSource.feedList.reversed
          .skip(wpSource.feedList.length - 5)
          .toList()
          .reversed
          .forEach(
        (post) {
          posts.add(ThemeUtil.materialPostCard(
              Column(
                children: <Widget>[
                  Text(
                    post.title.rendered,
                    style: TextStyle(fontSize: 20),
                  ),
//                  Html(data: post.content.rendered)
                ],
              ),
              post,
              margin, onCardClicked: () {
            goToWpPostDetail(context, post);
          }, onLongPressed: () {
            BottomSheetUtil.showPostSheetShow(context, post);
          }, canIconClick: false));
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
