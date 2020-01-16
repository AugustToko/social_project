import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/ui/page/photo_view.dart';
import 'package:social_project/ui/page/sample/content/home_page.dart';
import 'package:social_project/ui/page/search_page.dart';
import 'package:social_project/ui/page/timeline_page.dart';
import 'package:social_project/ui/page/wp_page.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/route/example_route.dart';
import 'package:social_project/utils/uidata.dart';

/// 用于 [HomePage], 装载着数个 Page
class ContentPage extends StatefulWidget {
  //抽屉widget
  final Widget drawer;

  ContentPage({
    Key key,
    this.drawer,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabBarState(this.drawer);
  }
}

/// 创建State对象，存储TabBarWidget的内部逻辑和变化状态
/// with表示扩展，SingleTickerProviderStateMixin是一个扩展（混合）类，它没有构造函数，只能继承自Object。
/// 一个类可以有多个扩展类，扩展类可以实现方法，接口不能实现方法，只能在实现类里面实现，继承只能是单继承，这就是扩展的好处。
/// 当有继承，扩展，以及类本身实现同样的功能时，方法调用的优先级是扩展类，函数本身，和父类，第二个扩展类，优先级高于第一个扩展类
class _TabBarState extends State<ContentPage>
    with SingleTickerProviderStateMixin {
  final Widget _drawer;

  ScrollController _scrollViewController;

  _TabBarState(
    this._drawer,
  ) : super();

  //标签控制器，主要是管理标签的行为，比如移动或者跳转到哪一个标签
  TabController _tabController;

  //初始化方法，当有状态widget已创建，就会为之创建一个state对象，就会调用initState方法
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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

    //这个类主要是可以实现展示drawer、snack bar、bottom sheets的功能
    return Scaffold(
      //抽屉界面
      drawer: _drawer,
//      body:  NestedScrollView(
//        controller: _scrollViewController,
//        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//          return <Widget>[
//             SliverAppBar(
//              title:  Text("Social Project"),
//              pinned: true,
//              floating: true,
//              forceElevated: innerBoxIsScrolled,
//              bottom:  TabBar(
//                tabs: <Tab>[
//                   Tab(text: "Time line"),
//                   Tab(text: "Time line2"),
//                ],
//                controller: _tabController,
//              ),
//              actions: <Widget>[
//                 IconButton(
//                    icon: Icon(Icons.search),
//                    tooltip: 'Search',
//                    onPressed: () {
//                      showSearch(
//                        context: context,
//                        delegate: SearchBarDelegate(),
//                      );
//                    }),
//                // overflow menu
//                PopupMenuButton<Choice>(
//                  onSelected: (val) {},
//                  itemBuilder: (BuildContext context) {
//                    return choices.skip(2).map((Choice choice) {
//                      return PopupMenuItem<Choice>(
//                        value: choice,
//                        child: Text(choice.title),
//                      );
//                    }).toList();
//                  },
//                ),
//              ],
//            ),
//          ];
//        },
//        body:  TabBarView(
//          children: <Widget>[
//            TimelineTwoPage(),
//            EmptyPage(),
//          ],
//          controller: _tabController,
//        ),
//      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 5,
        title: Text("Social Project"),
        bottom: TabBar(
          tabs: <Tab>[
            Tab(
              child: Text(
                "热门",
              ),
            ),
            Tab(text: "TuChong"),
            Tab(text: "Wordpress"),
            Tab(text: "Time line 4"),
          ],
          controller: _tabController,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              tooltip: '搜索',
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchBarDelegate(),
                );
              }),
          // overflow menu
          PopupMenuButton<Choice>(
            onSelected: (val) {},
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: TabBarView(
        children: <Widget>[
          TimelineTwoPage(),
          PhotoViewDemo(),
          wpPage,
          SampleHomePage(),
        ],
        controller: _tabController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            CacheCenter.tokenCache == null ? UIData.loginPage : UIData.sendPage,
          ).then((result){
            if (result != null) {
              switch (result) {
                case NavState.SendWpPostDone:
                  wpPage.onNewPostReleased();
                  break;
                default:
                  break;
              }
            }
          });
        },
        backgroundColor: Colors.white,
        child: CustomPaint(
          child: Container(),
          foregroundPainter: FloatingPainter(),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

// TODO: Sample Menus
const List<Choice> choices = const <Choice>[
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class FloatingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint amberPaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 5;

    Paint greenPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5;

    Paint bluePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5;

    Paint redPaint = Paint()
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
