import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared/ui/widget/profile_tile.dart';
import 'package:shared/util/dialog_util.dart';
import 'package:social_project/rebuild/viewmodel/profile_coolapk_provider.dart';
import 'package:social_project/ui/page/mainpages/subpages/content_page.dart';
import 'package:social_project/ui/page/sample/content/home_page.dart';
import 'package:social_project/ui/widgets/my_bar.dart';
import 'package:wpmodel/config/cache_center.dart';
import 'package:wpmodel/mvvm/view/base.dart';
import 'package:wpmodel/ui/user_header.dart';
import 'package:wpmodel/util/wp_user_utils.dart';

class ProfileCoolApkPage extends PageProvideNode<ProfileCoolApkPageProvider> {
  final int wpUserId;

  static const String profile = "/profile";

  ProfileCoolApkPage(this.wpUserId);

  @override
  Widget buildContent(BuildContext context) {
    return _ProfileCoolApk(wpUserId, mProvider);
  }
}

class _ProfileCoolApk extends StatefulWidget {
  final int wpUserId;

  final ProfileCoolApkPageProvider provider;

  _ProfileCoolApk(this.wpUserId, this.provider);

  @override
  State<StatefulWidget> createState() => _ProfileCoolApkState();
}

class _ProfileCoolApkState extends State<_ProfileCoolApk>
    with TickerProviderStateMixin
    implements Presenter {
  ProfileCoolApkPageProvider mProvider;

  static const ACTION_LOAD_DATA = "LOAD_DATA";
  static const ACTION_MORE_POSTS = "MORE_POSTS";

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    _tabController = TabController(length: 4, vsync: this);
    mProvider.wpUserId = widget.wpUserId;
    mProvider.destroy = false;

    if (widget.wpUserId > 0) {
      mProvider.init(context);
    }
  }

  @override
  void dispose() {
    mProvider.destroy = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mProvider.deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: _sliverBuilder,
        body: TabBarView(
          children: <Widget>[
            SingleChildScrollView(
              child: buildPostCard(),
            ),
            SampleHomePage(),
            SampleHomePage(),
            SampleHomePage(),
          ],
          controller: _tabController,
        ),
      ),
    );
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
                title: mProvider.source == null
                    ? "加载中"
                    : mProvider.source.feedList.length.toString(),
                subtitle: "文章",
              ),
              onPressed: () {
                onClick(ACTION_MORE_POSTS);
              }),
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

  Widget _postCard() => Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "文章 (显示最新的 5 篇)",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                  ),
                  MaterialButton(
                    child: Text(
                      "查看更多",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      onClick(ACTION_MORE_POSTS);
                    },
                  ),
                ],
              ),
            ),
            buildList()
          ],
        ),
      );

  Widget buildList() {
    return mProvider.posts.length == 0
        ? CircularProgressIndicator(
            strokeWidth: 4.0,
            backgroundColor: Colors.blue,
            // value: 0.2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          )
        : Column(
            children: mProvider.posts,
          );
  }

  Consumer<ProfileCoolApkPageProvider> buildPostCard() {
    return Consumer<ProfileCoolApkPageProvider>(
      builder: (context, value, child) {
        // 使用 Consumer ,当 provide.notifyListeners() 时都会rebuild
        return _postCard();
      },
    );
  }

  /// APPBAR
  Consumer<ProfileCoolApkPageProvider> buildAppBar() {
    return Consumer<ProfileCoolApkPageProvider>(
      builder: (context, value, child) {
        // 使用 Consumer ,当 provide.notifyListeners() 时都会rebuild
        return SliverAppBar(
//        title: Text(
//          "PROFILE TEST",
//          style: TextStyle(color: Colors.white),
//        ),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          expandedHeight: 370.0,
          pinned: true,
          iconTheme: mProvider.iconTheme,
          brightness: Brightness.dark,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.share), onPressed: () {}),
            PopupMenuButton<Choice>(
              onSelected: (val) => val.onTap(),
              itemBuilder: (context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Text(choice.title),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ],
          flexibleSpace: CustomFlexibleSpaceBar(
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
                            userId: widget.wpUserId,
                            showUserName: false,
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
                                  "  ${(WpCacheCenter.tokenCache == null || WpCacheCenter.tokenCache.userId != widget.wpUserId) ? "注册新账号" : "编辑个人资料"}  ",
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
                      Text(mProvider.wpUser.name,
                          style: TextStyle(fontSize: 25, color: Colors.white)),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        mProvider.wpUser.description == null ||
                                mProvider.wpUser.description == ""
                            ? "这里是空空的，啥也没有哦~"
                            : mProvider.wpUser.description,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      WpCacheCenter.tokenCache != null &&
                              WpCacheCenter.tokenCache.userId ==
                                  mProvider.wpUser.id
                          ? Text(
                              getWpUserCapText(
                                  WpCacheCenter.tokenCache.userCaps),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          : Container(),
                      followColumn(mProvider.deviceSize, widget.wpUserId),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// APPBAR HEADER
  Consumer<ProfileCoolApkPageProvider> buildAppBarHeader() {
    return Consumer<ProfileCoolApkPageProvider>(
      builder: (context, value, child) {
        // 使用 Consumer ,当 provide.notifyListeners() 时都会rebuild
        return SliverPersistentHeader(
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
        );
      },
    );
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[buildAppBar(), buildAppBarHeader()];
  }

  @override
  void onClick(String action) {
    switch (action) {
      case ACTION_MORE_POSTS:
        mProvider.morePosts(context);
        break;
    }
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
