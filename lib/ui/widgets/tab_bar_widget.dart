import 'package:flutter/material.dart';
import 'package:social_project/ui/page/photo_view.dart';
import 'package:social_project/ui/page/sample/content/home_page.dart';
import 'package:social_project/ui/page/sample/empty_page.dart';
import 'package:social_project/ui/page/search_page.dart';
import 'package:social_project/ui/page/timeline_page.dart';

class TabBarWidgetPage extends StatefulWidget {
  //抽屉widget
  final Widget drawer;

  TabBarWidgetPage({
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
class _TabBarState extends State<TabBarWidgetPage>
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
        title: Text("Social Project"),
        bottom: TabBar(
          tabs: <Tab>[
            Tab(text: "Time line"),
            Tab(text: "Time line 2"),
            Tab(text: "Time line 3"),
            Tab(text: "Time line 4"),
          ],
          controller: _tabController,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
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
              return choices.skip(2).map((Choice choice) {
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
          SampleHomePage(),
          SampleHomePage(),
        ],
        controller: _tabController,
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];
