import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/ui/page/profile/profile_page.dart';
import 'package:social_project/ui/page/sample/content/home_page.dart';
import 'package:social_project/ui/page/sample/my_bar.dart';
import 'package:social_project/ui/widgets/profile_tile.dart';
import 'package:social_project/ui/widgets/wp/user_header.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:social_project/utils/utils.dart';

import '../content_page.dart';

class ProfileCoolApk extends StatefulWidget {
  final int wpUserId;

  ProfileCoolApk(this.wpUserId);

  @override
  State<StatefulWidget> createState() => _ProfileCoolApkState();
}

class _ProfileCoolApkState extends State<ProfileCoolApk>
    with TickerProviderStateMixin {
  TabController _tabController;

  /// 用于最新 5 篇文章数据存储
  final List<Widget> _posts = [];

  WpPostSource source;

  bool _destroy = false;

  WpUser _wpUser = WpUser.defaultUser;

  var needChangeColor = false;

  var iconTheme = IconThemeData(color: Colors.grey);

  Size _deviceSize;

  @override
  void initState() {
    super.initState();
    _destroy = false;
    _tabController = TabController(length: 4, vsync: this);

    if (widget.wpUserId > 0) {
      // 更新 _wpUser
      getWpUserNew(widget.wpUserId).then((user) {
        _wpUser = user;
        if (!_destroy) {
          setState(() {});
        }
      });

      NetTools.getAllPosts(widget.wpUserId).then((wpPostSource) {
        CacheCenter.putPosts(widget.wpUserId, wpPostSource);
        source = wpPostSource;

        if (!_destroy) {
          setState(() {});
        }
        return wpPostSource;
      }).then((wpSource) {
        if (!_destroy) {
          setState(() {
            wpSource.feedList.reversed
                .skip(wpSource.feedList.length - 5)
                .toList()
                .reversed
                .forEach((post) {
              _posts.add(ProfilePage.getCard(context, post));
            },);
          });
        }
      });
    }
  }

  //TODO: followColumn 待完善
  Widget followColumn(final Size deviceSize, final int userId) {
    const double iconSize = 60;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
              iconSize: iconSize,
              icon: ProfileTile(
                textColor: Colors.white,
                title:
                    source == null ? "加载中" : source.feedList.length.toString(),
                subtitle: "文章",
              ),
              onPressed: _morePosts),
          IconButton(
              iconSize: iconSize,
              icon: ProfileTile(
                textColor: Colors.white,
                title: "1.2K",
                subtitle: "正在关注",
              ),
              onPressed: () {}),
          IconButton(
              iconSize: iconSize,
              icon: ProfileTile(
                textColor: Colors.white,
                title: "2.5K",
                subtitle: "关注者",
              ),
              onPressed: () {}),
          IconButton(
              iconSize: iconSize,
              icon: ProfileTile(
                textColor: Colors.white,
                title: "10K",
                subtitle: "评论",
              ),
              onPressed: () {}),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _destroy = true;
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: _sliverBuilder,
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: postCard(),
            ),
            SampleHomePage(),
            SampleHomePage(),
            SampleHomePage(),
          ],
          controller: _tabController,
        ),
//        body: Center(
//          child: ListView.builder(
//            itemBuilder: _itemBuilder,
//            itemCount: 15,
//          ),
//        ),
      ),
    );
  }

  /// 查看更多 Posts
  void _morePosts() {
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

  Widget postCard() => Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "文章 (显示最新的 5 篇)",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0),
                    ),
                    MaterialButton(
                      child: Text(
                        "查看更多",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: _morePosts,
                    ),
                  ],
                ),
              ),
              _posts.length == 0
                  ? CircularProgressIndicator(
                      strokeWidth: 4.0,
                      backgroundColor: Colors.blue,
                      // value: 0.2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    )
                  : Column(
                      children: _posts,
                    )
            ],
          ),
        ),
      );

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
//        title: Text(
//          "PROFILE TEST",
//          style: TextStyle(color: Colors.white),
//        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        expandedHeight: 370.0,
        pinned: false,
        iconTheme: iconTheme,
        brightness: Brightness.dark,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          PopupMenuButton<Choice>(
            onSelected: (val) => val.onTap(),
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(
                    children: <Widget>[Text(choice.title)],
                  ),
                );
              }).toList();
            },
          ),
        ],
        primary: true,
        flexibleSpace: CustomFlexibleSpaceBar(
          callBack: (t) {
//            val = Tween<double>(begin: 0, end: 255).transform(t).round();
//            print(iconTheme.color);
          },
          onImageTap: () {
            DialogUtil.showAlertDialog(context, "更换背景图片", "将更换背景图片", []);
          },
          appbarColor: Theme.of(context).backgroundColor,
          background: Stack(
            children: <Widget>[
              Image.network(
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579795819240&di=a76686117f05bff3788ff5532a6fd196&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F4%2F5743b11d203a1.jpg",
                fit: BoxFit.cover,
                height: 430,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 82, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        WpUserHeader(
                          radius: 45,
                          canClick: false,
                          userId: widget.wpUserId,
                          showUserName: false,
                          wpSource: WordPressRep.wpSource,
                        ),
//                        InkWell(
//                          child: CircleAvatar(
//                            radius: 45,
//                            backgroundImage: NetworkImage(
//                              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579376237112&di=5e6ab6e58386d3463f7f95cf7420be00&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201412%2F29%2F20141229220034_wi3x2.thumb.700_0.jpeg",
//                            ),
//                          ),
//                          onTap: () {
//                            DialogUtil.showAlertDialog(context, "更换背景图片", "将更换背景图片", []);
//                          },
//                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            RaisedButton(
                              padding: EdgeInsets.all(10.0),
                              shape: StadiumBorder(),
                              child: Text(
                                "  ${(CacheCenter.tokenCache == null || CacheCenter.tokenCache.userId != widget.wpUserId) ? "注册新账号" : "编辑个人资料"}  ",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Color.fromARGB(50, 255, 255, 255),
                              elevation: 0,
                              onPressed: () {},
                            ),
                            RaisedButton(
                              padding: EdgeInsets.all(10.0),
                              shape: CircleBorder(),
                              child: Icon(
                                Icons.camera,
                                color: Colors.white,
                              ),
                              color: Color.fromARGB(50, 255, 255, 255),
                              elevation: 0,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(_wpUser.name,
                        style: TextStyle(fontSize: 25, color: Colors.white)),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      _wpUser.description == null || _wpUser.description == ""
                          ? "这里是空空的，啥也没有哦~"
                          : _wpUser.description,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CacheCenter.tokenCache != null &&
                            CacheCenter.tokenCache.userId == _wpUser.id
                        ? Text(
                            getWpUserCap(CacheCenter.tokenCache.userCaps),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )
                        : Container(),
                    followColumn(_deviceSize, widget.wpUserId),
                  ],
                ),
              )
            ],
          ),
        ),
//        bottom: TabBar(
//          labelColor: Colors.green,
//          unselectedLabelColor: Colors.grey,
//          tabs: [
//            Tab(text: '文章'),
//            Tab(text: '动态'),
//            Tab(text: '关注的话题'),
//            Tab(text: '粉丝'),
//          ],
//          controller: _tabController,
//        ),
      ),
      SliverPersistentHeader(
        delegate: _SliverAppBarDelegate(
          TabBar(
            labelColor: Colors.red,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: '文章'),
              Tab(text: '动态'),
              Tab(text: '关注的话题'),
              Tab(text: '粉丝'),
            ],
            controller: _tabController,
          ),
        ),
        pinned: true,
      )
    ];
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRRect(
      child: Container(
        child: _tabBar,
        color: Theme.of(context).backgroundColor,
      ),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

List<Choice> choices = <Choice>[
  Choice(title: '分享', icon: Icons.directions_boat, onTap: () {}),
  Choice(title: '查看我的资料', icon: Icons.directions_boat, onTap: () {}),
];
