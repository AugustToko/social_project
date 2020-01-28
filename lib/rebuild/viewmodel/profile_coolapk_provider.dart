import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/rebuild/view/base.dart';
import 'package:social_project/ui/page/profile/profile_page.dart';
import 'package:social_project/utils/bottom_sheet.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:social_project/utils/utils.dart';

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
    final double margin = ScreenUtil.instance.setWidth(22);
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
            margin,
            onCardClicked: () {
              Navigator.pushNamed(context, UIData.wpPostDetail, arguments: {
                "content": post.content.rendered,
                "title": post.title.rendered,
              });
            },
            onLongPressed: () {
              BottomSheetUtil.showPostSheetShow(context, post);
            },
          ));
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
