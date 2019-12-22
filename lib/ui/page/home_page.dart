import 'package:flutter/material.dart';
import 'package:social_project/ui/page/content_page.dart';

import 'empty_page.dart';

/// 仅带有一个 BottomNavigationBar
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexState();
  }
}

class _IndexState extends State<HomePage> {
  final List<BottomNavigationBarItem> _bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text("Home"),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      title: Text("Search"),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.message),
      title: Text("Message"),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: Text("Profile"),
    ),
  ];

  var _currentIndex;

  final pages = [
    ContentPage(),
    EmptyPage(),
    EmptyPage(),
    EmptyPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          _changePage(index);
        },
      ),
    );
  }

  /*切换页面*/
  void _changePage(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }
}
