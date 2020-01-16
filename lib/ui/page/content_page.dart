import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/ui/page/photo_view.dart';
import 'package:social_project/ui/page/sample/content/home_page.dart';
import 'package:social_project/ui/page/search_page.dart';
import 'package:social_project/ui/page/timeline_page.dart';
import 'package:social_project/ui/page/wordpress/wp_page.dart';
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
    return Scaffold(
      drawer: _drawer,
      body: NestedScrollView(
        controller: _scrollViewController,
        headerSliverBuilder: _sliverBuilder,
        body: TabBarView(
          children: <Widget>[
            wpPage,
//            TimelineTwoPage(),
            PhotoViewDemo(),
            SampleHomePage(),
            SampleHomePage(),
          ],
          controller: _tabController,
        ),
      ),
    );

//    这个类主要是可以实现展示drawer、snack bar、bottom sheets的功能
//    return Scaffold(
//      //抽屉界面
//      drawer: _drawer,
//      appBar: AppBar(
//        backgroundColor: Theme.of(context).backgroundColor,
//        elevation: 5,
//        title: Text("Social Project"),
//        bottom: TabBar(
//          tabs: <Tab>[
//            Tab(
//              child: Text(
//                "热门",
//              ),
//            ),
//            Tab(text: "TuChong"),
//            Tab(text: "Wordpress"),
//            Tab(text: "Time line 4"),
//          ],
//          controller: _tabController,
//        ),
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.search),
//              tooltip: '搜索',
//              onPressed: () {
//                showSearch(
//                  context: context,
//                  delegate: SearchBarDelegate(),
//                );
//              }),
//          // overflow menu
//          PopupMenuButton<Choice>(
//            onSelected: (val) {},
//            itemBuilder: (BuildContext context) {
//              return choices.map((Choice choice) {
//                return PopupMenuItem<Choice>(
//                  value: choice,
//                  child: Text(choice.title),
//                );
//              }).toList();
//            },
//          ),
//        ],
//      ),
//      body: TabBarView(
//        children: <Widget>[
//          TimelineTwoPage(),
//          PhotoViewDemo(),
//          wpPage,
//          SampleHomePage(),
//        ],
//        controller: _tabController,
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () async {
//          await Navigator.pushNamed(
//            context,
//            CacheCenter.tokenCache == null ? UIData.loginPage : UIData.sendPage,
//          ).then((result) {
//            if (result != null) {
//              switch (result) {
//                case NavState.SendWpPostDone:
//                  wpPage.onNewPostReleased();
//                  break;
//                default:
//                  break;
//              }
//            }
//          });
//        },
//        backgroundColor: Colors.white,
//        child: CustomPaint(
//          child: Container(),
//          foregroundPainter: FloatingPainter(),
//        ),
//      ),
//    );
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        centerTitle: true,
        elevation: 5,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text("Social Project"),
        pinned: false,
        primary: true,
//        flexibleSpace: FlexibleSpaceBar(
//          centerTitle: true,
//          title: Text('我是一个FlexibleSpaceBar'),
//          background: Image.network(
//            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531798262708&di=53d278a8427f482c5b836fa0e057f4ea&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F342ac65c103853434cc02dda9f13b07eca80883a.jpg",
//            fit: BoxFit.cover,
//          ),
//        ),
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
      SliverPersistentHeader(
        delegate: _SliverAppBarDelegate(
          TabBar(
//            labelColor: Colors.green,
//            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                child: Text(
                  "博客",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(text: "TuChong"),
              Tab(
                child: Text(
                  "热门",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Tab(text: "Time line 4"),
            ],
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

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: Material(child: _tabBar, elevation: 2,),
      color: Theme.of(context).backgroundColor,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
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
