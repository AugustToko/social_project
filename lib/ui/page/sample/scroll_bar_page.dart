import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared/login_sys/cache_center.dart';
import 'package:shared/model/wordpress/wp_user.dart';
import 'package:shared/rep/wp_rep.dart';
import 'package:shared/ui/widget/wp/user_header.dart';
import 'package:shared/util/net_util.dart';
import 'package:social_project/ui/page/profile/profile_page.dart';
import 'package:social_project/ui/page/sample/content/home_page.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';

import '../../widgets/my_bar.dart';
import '../content_page.dart';

class DiscoverListPage extends StatefulWidget {
  final int wpUserId;

  DiscoverListPage(this.wpUserId);

  @override
  State<StatefulWidget> createState() => _DiscoverListState();
}

class _DiscoverListState extends State<DiscoverListPage>
    with TickerProviderStateMixin {
  TabController _tabController;

  final List<Widget> _posts = [];

  bool _destroy = false;

  WpUser _wpUser = WpUser.defaultUser;

  var needChangeColor = false;

  var iconTheme = IconThemeData(color: Color.fromARGB(255, 255, 255, 255));

  @override
  void initState() {
    super.initState();
    _destroy = false;

    if (widget.wpUserId != -1) {
      // 更新 _wpUser
      NetTools.getWpUserInfoAuto(widget.wpUserId).then((user) {
        CacheCenter.putUser(widget.wpUserId, user);
        _wpUser = user;
        if (!_destroy) {
          setState(() {});
        }
      });
    }

    _tabController = TabController(length: 4, vsync: this);
    NetTools.getPostsAuto(widget.wpUserId, 5).then((wpPostsSource) {
      print("getpostauto id: ${widget.wpUserId}");
      print("getpostauto size: ${wpPostsSource.feedList.length}");
      if (!_destroy) {
        setState(() {
          wpPostsSource.feedList.forEach((post) {
            _posts.add(ProfilePage.getCard(context, post));
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _destroy = true;
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {
                        showToast("USER ID: " + widget.wpUserId.toString());
                      },
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
        expandedHeight: 350.0,
        pinned: true,
        iconTheme: iconTheme,
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
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579424225565&di=fb5bb05f3d3a959ae153cabd4b5849f7&imgtype=0&src=http%3A%2F%2Fattachments.gfan.com%2Fforum%2Fattachments2%2F201306%2F06%2F144907wbpz80kxwgvv7v11.jpg",
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
                        )
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
                      "user_mail@mail.mail",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "这里是个人签名。这里是个人签名。这里是个人签名。",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "这里是个人签名。这里是个人签名。这里是个人签名。",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      "这里是个人签名。这里是个人签名。这里是个人签名。",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        bottom: TabBar(
          labelColor: Colors.green,
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
//      SliverPersistentHeader(
//        delegate: _SliverAppBarDelegate(
//          TabBar(
//            labelColor: Colors.red,
//            unselectedLabelColor: Colors.grey,
//            tabs: [
//              Tab(text: '文章'),
//              Tab(text: '动态'),
//              Tab(text: '关注的话题'),
//              Tab(text: '粉丝'),
//            ],
//            controller: _tabController,
//          ),
//        ),
//        pinned: true,
//      )
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
      borderRadius: BorderRadius.circular(28.0),
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
