import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shared/login_sys/cache_center.dart';
import 'package:shared/rep/wp_rep.dart';
import 'package:shared/util/net_util.dart';
import 'package:shared/util/theme_util.dart';
import 'package:shared/util/tost.dart';
import 'package:social_project/rebuild/view/page/login_page.dart';
import 'package:social_project/rebuild/view/page/profile_coolapk.dart';
import 'package:social_project/rebuild/view/page/wp_page.dart';
import 'package:social_project/ui/page/mainpages/subpages/photo_view.dart';
import 'package:social_project/ui/page/topic_page.dart';
import 'package:social_project/ui/widgets/common_drawer.dart';
import 'package:social_project/ui/widgets/my_tabbar.dart';
import 'package:social_project/ui/widgets/user_header.dart';
import 'package:shared/util/wp_user_utils.dart';
import 'package:social_project/utils/uidata.dart';

import '../../../../main.dart';

/// 用于 [HomePage], 装载着数个 Page
class ContentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabBarPageState();
  }
}

/// 创建State对象，存储TabBarWidget的内部逻辑和变化状态
/// with表示扩展，SingleTickerProviderStateMixin是一个扩展（混合）类，它没有构造函数，只能继承自Object。
/// 一个类可以有多个扩展类，扩展类可以实现方法，接口不能实现方法，只能在实现类里面实现，继承只能是单继承，这就是扩展的好处。
/// 当有继承，扩展，以及类本身实现同样的功能时，方法调用的优先级是扩展类，函数本身，和父类，第二个扩展类，优先级高于第一个扩展类
class _TabBarPageState extends State<ContentPage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollViewController;

  final TextEditingController _controller = TextEditingController();

  //标签控制器，主要是管理标签的行为，比如移动或者跳转到哪一个标签
  TabController _tabController;

  final List<Widget> tabs = [
    //TODO: 动态标签（根据服务器）
    Tab(child: Text("博客")),
    Tab(text: "图虫"),
//    Tab(child: Text("热门")),
    Tab(text: "版块"),
  ];

  //初始化方法，当有状态widget已创建，就会为之创建一个state对象，就会调用initState方法
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _scrollViewController = ScrollController();
  }

  //资源释放
  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var wpPage = WordPressPage();
    return Scaffold(
      drawer: CommonDrawer(),
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: _sliverBuilder,
        body: Column(
          children: <Widget>[
//            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: Text("Welcome to LingYun"),),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  wpPage,
                  PhotoViewDemo(),
//                  SampleHomePage(),
                  TopicPage(),
                ],
                controller: _tabController,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, ThemeUtil.navBarHeight),
        child: FloatingActionButton(
          onPressed: () async {
            var page = WpCacheCenter.tokenCache == null
                ? LoginPage.loginPage
                : UIData.sendPage;
            if (page == UIData.sendPage &&
                !canISentPost(WpCacheCenter.tokenCache.userCaps)) {
              showErrorToast(context, "无权限!");
              return;
            }
            Navigator.pushNamed(context, page);
          },
          backgroundColor: Colors.white,
          child: CustomPaint(
            child: Container(),
            foregroundPainter: FloatingPainter(),
          ),
        ),
      ),
    );
  }

  List<Widget> _sliverBuilder(
      final BuildContext context, final bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        centerTitle: true,
        leading: Container(),
        backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.8),
        expandedHeight: 70,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 60,
              child: Card(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context)
                              .textTheme
                              .title
                              .color
                              .withOpacity(0.7),
                        ),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          focusNode: FocusNode(canRequestFocus: true),
                          keyboardAppearance: App.isDarkMode(context)
                              ? Brightness.dark
                              : Brightness.light,
                          controller: _controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "查找信息",
                            hintStyle: TextStyle(
                                color:
                                    Theme.of(context).textTheme.subtitle.color),
                          ),
                          onSubmitted: (par1) {
                            return Navigator.pushNamed(
                                context, UIData.argPostsPage,
                                arguments: {
                                  'url': WordPressRep.getWpLink(
                                          WordPressRep.wpSource) +
                                      "/wp-json/wp/v2/posts?search=${_controller.text}",
                                  'appBar': AppBar(
                                    title: Text(_controller.text + ' 的搜索结果'),
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    elevation: 5,
                                  )
                                });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      WpUserHeader(
                        radius: 20,
                        showUserName: false,
                        needLogin: true,
                        userId: WpCacheCenter.tokenCache == null
                            ? -1
                            : WpCacheCenter.tokenCache.userId,
                        loginRouteName: LoginPage.loginPage,
                        profileRouteName: ProfileCoolApkPage.profile,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        pinned: false,
      ),
      SliverPersistentHeader(
        delegate: _SliverAppBarDelegate(
          MyTabBar(
            tabs: tabs,
            controller: _tabController,
          ),
        ),
        pinned: true,
      ),
    ];
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar) : super();

  final MyTabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: <Widget>[
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor.withOpacity(0.8),
              ),
            ),
          ),
        ),
        _tabBar
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class Choice {
  const Choice({this.title, this.icon, this.onTap});

  final String title;
  final IconData icon;
  final Function() onTap;
}

// TODO: Sample Menus
List<Choice> choices = <Choice>[
  Choice(
      title: '退出',
      icon: Icons.directions_boat,
      onTap: () {
        App.exitApp();
      }),
];

class FloatingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint amberPaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 5;

    final Paint greenPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5;

    final Paint bluePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5;

    final Paint redPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    canvas.drawLine(Offset(size.width * 0.27, size.height * 0.5),
        Offset(size.width * 0.5, size.height * 0.5), amberPaint);

    canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width * 0.5, size.height - (size.height * 0.27)),
        greenPaint);

    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width - (size.width * 0.27), size.height * 0.5), bluePaint);

    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width * 0.5, size.height * 0.27), redPaint);
  }

  @override
  bool shouldRepaint(FloatingPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(FloatingPainter oldDelegate) => false;
}
