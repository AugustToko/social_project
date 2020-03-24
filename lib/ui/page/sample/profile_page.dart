//import 'package:flutter/material.dart';
//import 'package:flutter_html/flutter_html.dart';
//import 'package:oktoast/oktoast.dart';
//import 'package:shared/login_sys/cache_center.dart';
//import 'package:shared/model/wordpress/wp_post_source.dart';
//import 'package:shared/model/wordpress/wp_user.dart';
//import 'package:shared/rep/wp_rep.dart';
//import 'package:shared/ui/widget/profile_tile.dart';
//import 'package:shared/util/bottom_sheet.dart';
//import 'package:shared/util/log.dart';
//import 'package:shared/util/net_util.dart';
//import 'package:social_project/rebuild/view/page/login_page.dart';
//import 'package:social_project/rebuild/view/page/profile_coolapk_page.dart';
//import 'package:social_project/utils/route/app_route.dart';
//import 'package:social_project/utils/uidata.dart';
//
//import 'file:///C:/Users/chenlongcould/AndroidStudioProjects/social_project/lib/ui/widgets/user_header.dart';
//
//import '../content_page.dart';
//
///// 根据所给 UserId 获取信息
//@Deprecated("Use CoolApk-style profile")
//class ProfilePage extends StatefulWidget {
//  final int wpUserId;
//
//  // TODO: 使用 [WpUser] 传参
//  ProfilePage(this.wpUserId);
//
//  @override
//  State<StatefulWidget> createState() {
//    return _ProfilePageState();
//  }
//
//  static Widget getCard(BuildContext context, WpPost post) =>
//      _ProfilePageState.articleCard(context, post);
//}
//
//@Deprecated("")
//class _ProfilePageState extends State<ProfilePage> {
//  Size _deviceSize;
//
//  WpUser _wpUser = WpUser.defaultUser;
//
//  bool _destroy = false;
//
//  final List<Widget> _posts = [];
//
//  Widget profileHeader() => Container(
//        height: _deviceSize.height / 4,
//        width: double.infinity,
//        child: Card(
//          clipBehavior: Clip.antiAlias,
//          margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
//          child: Padding(
//            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
//            child: FittedBox(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: <Widget>[
//                  Container(
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.circular(50.0),
//                        border: Border.all(width: 2.0, color: Colors.white)),
//                    child: CircleAvatar(
//                        radius: 40,
//                        backgroundImage: NetworkImage(_wpUser.avatarUrls.s96)),
////                    WpUserHeader(
////                      radius: 40,
////                      userId: wpUser.id,
////                      showUserName: false,
////                      wpSource: WordPressRep.wpSource,
////                      canClick: false,
////                    ),
//                  ),
//                  Text(
//                    _wpUser.name,
//                    style: TextStyle(fontSize: 20.0),
//                  ),
//                  Text(
//                    // TODO: building
//                    "Building...",
//                  )
//                ],
//              ),
//            ),
//          ),
//        ),
//      );
//
//  Widget imagesCard() => Container(
//        height: _deviceSize.height / 3.5,
//        child: Padding(
//          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(
//                      "照片",
//                      style: TextStyle(
//                          fontWeight: FontWeight.w700, fontSize: 18.0),
//                    ),
//                    MaterialButton(
//                      child: Text(
//                        "查看更多",
//                        style: TextStyle(color: Colors.blue),
//                      ),
//                      onPressed: () {
//                        //TODO: more
//                      },
//                    ),
//                  ],
//                ),
//              ),
//              Expanded(
//                child: Card(
//                  child: ListView.builder(
//                    scrollDirection: Axis.horizontal,
//                    itemCount: 5,
//                    itemBuilder: (context, i) => Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Image.network(
//                        "https://cdn.pixabay.com/photo/2016/10/31/18/14/ice-1786311_960_720.jpg",
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      );
//
//  Widget postCard() => Container(
//        child: Padding(
//          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//          child: Column(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(
//                      "文章 (显示最新的 5 篇)",
//                      style: TextStyle(
//                          fontWeight: FontWeight.w700, fontSize: 18.0),
//                    ),
//                    MaterialButton(
//                      child: Text(
//                        "查看更多",
//                        style: TextStyle(color: Colors.blue),
//                      ),
//                      onPressed: _morePosts,
//                    ),
//                  ],
//                ),
//              ),
//              _posts.length == 0
//                  ? CircularProgressIndicator(
//                      strokeWidth: 4.0,
//                      backgroundColor: Colors.blue,
//                      // value: 0.2,
//                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//                    )
//                  : Column(
//                      children: _posts,
//                    )
//            ],
//          ),
//        ),
//      );
//
//  static Widget articleCard(BuildContext context, final WpPost post) {
//    var content = post.content.rendered;
//
//    content =
//        content.substring(0, content.length >= 1000 ? 1000 : content.length);
//
//    return Card(
//      child: InkWell(
//        onTap: () {
//          goToWpPostDetail(context, post);
//        },
//        onLongPress: () {
//          BottomSheetUtil.showPostSheetShow(context, post);
//        },
//        child: Padding(
//          padding: EdgeInsets.fromLTRB(
//            10,
//            010,
//            10,
//            10,
//          ),
//          child: Column(
//            children: <Widget>[
//              Column(
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      WpUserHeader(
//                        radius: 20,
//                        userId: post.author,
//                        showUserName: true,
//                        wpSource: WordPressRep.wpSource,
//                        profileRouteName: ProfileCoolApkPage.profile,
//                        loginRouteName: LoginPage.loginPage,
//                      ),
//                    ],
//                  ),
//                  Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Text(
//                              post.title.rendered,
//                              style: const TextStyle(fontSize: 20),
//                            ),
//                            SizedBox(
//                              height: 5.0,
//                            ),
//                            Text(
//                              post.date,
//                            ),
//                          ],
//                        ),
//                      ),
//                      Html(data: content)
//                    ],
//                  ),
//                ],
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  //TODO: followColumn 待完善
//  Widget followColumn(final Size deviceSize, final int userId) {
//    final WpPostSource source = WpCacheCenter.getPosts(userId);
//    const double iconSize = 80;
//    return Container(
//      height: deviceSize.height * 0.13,
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceAround,
//        children: <Widget>[
//          IconButton(
//              iconSize: iconSize,
//              icon: ProfileTile(
//                title: source == null
//                    ? "加载中..."
//                    : source.feedList.length.toString(),
//                subtitle: "文章",
//              ),
//              onPressed: _morePosts),
//          IconButton(
//              iconSize: iconSize,
//              icon: ProfileTile(
//                title: "1.2K",
//                subtitle: "正在关注",
//              ),
//              onPressed: () {}),
//          IconButton(
//              iconSize: iconSize,
//              icon: ProfileTile(
//                title: "2.5K",
//                subtitle: "关注者",
//              ),
//              onPressed: () {}),
//          IconButton(
//              iconSize: iconSize,
//              icon: ProfileTile(
//                title: "10K",
//                subtitle: "评论",
//              ),
//              onPressed: () {}),
//        ],
//      ),
//    );
//  }
//
//  /// Body
//  Widget bodyData() => SingleChildScrollView(
//        child: Column(
//          children: <Widget>[
//            AppBar(
//              title: Text(_wpUser.name + " 的资料"),
//              backgroundColor: Colors.transparent,
//              actions: <Widget>[
//                //TODO: menu
//                PopupMenuButton<Choice>(
//                  onSelected: (val) {},
//                  itemBuilder: (BuildContext context) {
//                    return choices.skip(2).map((Choice choice) {
//                      return PopupMenuItem<Choice>(
//                        value: choice,
//                        child: Row(
//                          children: <Widget>[
//                            Icon(choice.icon),
//                            SizedBox(
//                              width: 15,
//                            ),
//                            Text(choice.title)
//                          ],
//                        ),
//                      );
//                    }).toList();
//                  },
//                ),
//              ],
//            ),
//            profileHeader(),
//            followColumn(_deviceSize, widget.wpUserId),
//            imagesCard(),
//            postCard(),
//          ],
//        ),
//      );
//
//  @override
//  void initState() {
//    super.initState();
//
//    _destroy = false;
//
//    if (widget.wpUserId != -1) {
//      LogUtils.d("Profile Page", "userId != -1");
//
//      // 更新 _wpUser
//      NetTools.getWpUserInfoAuto(widget.wpUserId).then((user) {
//        WpCacheCenter.putUser(widget.wpUserId, user);
//        _wpUser = user;
//        if (!_destroy) {
//          setState(() {});
//        }
//      });
//
//      final WpPostSource wpSource = WpCacheCenter.getPosts(widget.wpUserId);
//      if (wpSource == null) {
//        NetTools.getAllPosts(widget.wpUserId).then((wpPostSource) {
//          WpCacheCenter.putPosts(widget.wpUserId, wpPostSource);
//          if (!_destroy) {
//            // 更新 followColumn
//            setState(() {});
//          }
////          final List<WpPost> posts = [];
////          posts.addAll(wpPostSource.feedList);
////          posts.removeRange(0, 5);
////          updateRecentlyPosts(posts);
//        });
//      } else {
////        final List<WpPost> posts = [];
////        posts.addAll(wpSource.feedList);
////        posts.removeRange(0, 5);
////        updateRecentlyPosts(posts);
//      }
//
//      NetTools.getPostsAuto(widget.wpUserId, 5).then((wpPostsSource) {
//        if (!_destroy) {
//          setState(() {
//            wpPostsSource.feedList.forEach((post) {
//              _posts.add(articleCard(context, post));
//            });
//          });
//        }
//      });
//    } else {
//      LogUtils.d("Profile Page", "userId == -1");
//    }
//  }
//
////  void _updateRecentlyPosts(final List<WpPost> posts) {
////    posts.forEach((post) {
////      _posts.add(articleCard(post));
////    });
////    if (!_destroy) {
////      setState(() {});
////    }
////  }
//
//  @override
//  Widget build(BuildContext context) {
//    _deviceSize = MediaQuery.of(context).size;
//
//    return Scaffold(
//      body: bodyData(),
//      floatingActionButton: WpCacheCenter.tokenCache != null &&
//              WpCacheCenter.tokenCache.userId == _wpUser.id
//          ? null
//          : FloatingActionButton(
//              onPressed: () {
//                if (WpCacheCenter.tokenCache == null) {
//                  showToast("请先登陆",
//                      backgroundColor: Colors.red,
//                      position: ToastPosition.bottom);
//                  Navigator.pushNamed(context, UIData.loginPage);
//                } else {
//                  showToast("功能：添加好友（关注），状态：建设中", backgroundColor: Colors.red);
//                }
//              },
//              child: Icon(Icons.person_add),
//            ),
//    );
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _destroy = true;
//  }
//
//  /// 查看更多 Posts
//  void _morePosts() {
//    Navigator.pushNamed(
//      context,
//      UIData.argPostsPage,
//      arguments: {
//        "url": WordPressRep.getWpLink(WordPressRep.wpSource) +
//            WordPressRep.postsOfAuthorX +
//            _wpUser.id.toString(),
//        "appBar": AppBar(
//          title: Text(_wpUser.name + " 的全部文章"),
//        )
//      },
//    );
//  }
//}
//
//const List<Choice> choices = const <Choice>[
//  const Choice(title: 'Menu 1', icon: Icons.title),
//  const Choice(title: 'Menu 2', icon: Icons.title),
//  const Choice(title: 'Menu 3', icon: Icons.title),
//  const Choice(title: 'Menu 4', icon: Icons.title),
//  const Choice(title: 'Menu 5', icon: Icons.title),
//  const Choice(title: 'Menu 6', icon: Icons.title),
//];
