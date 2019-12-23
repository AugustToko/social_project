import 'dart:math';

import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:social_project/ui/page/content_page.dart';
import 'package:social_project/ui/page/sample/content/gallery_page.dart';
import 'package:social_project/ui/page/sample/content/home_page.dart';
import 'package:social_project/ui/page/sample/content/likes_page.dart';
import 'package:social_project/ui/page/sample/content/save_page.dart';
import 'package:social_project/ui/widgets/navbar/navbar.dart';

/// [HomePage]
/// 仅带有一个 BottomNavigationBar
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexState();
  }
}

class _IndexState extends State<HomePage> {
  List<NavBarItemData> _navBarItems;
  int _selectedNavIndex = 0;

  List<Widget> _viewsByIndex;

  @override
  void initState() {
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("Home", OMIcons.home, 110, Color(0xff01b87d)),
      NavBarItemData("Search", OMIcons.search, 110, Color(0xff594ccf)),
      NavBarItemData("Message", OMIcons.message, 115, Color(0xff09a8d9)),
      NavBarItemData("Profile", OMIcons.person, 100, Color(0xffcf4c7a)),
      NavBarItemData("Saved", OMIcons.save, 105, Color(0xfff2873f)),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      ContentPage(),
      GalleryPage(),
      SampleHomePage(),
      SampleLikesPage(),
      SampleSavePage(),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var accentColor = _navBarItems[_selectedNavIndex].selectedColor;

    //Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];

    //Wrap our custom navbar + contentView with the app Scaffold
    return Scaffold(
      body: Container(
        width: double.infinity,
        //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 350),
          //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
          child: contentView,
        ),
      ),
      bottomNavigationBar: NavBar(
        items: _navBarItems,
        itemTapped: _handleNavBtnTapped,
        currentIndex: _selectedNavIndex,
      ), //Pass our custom navBar into the scaffold
    );
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });
  }
}

//import 'package:flutter/material.dart';
//import 'package:social_project/ui/page/content_page.dart';
//import 'package:social_project/ui/page/sample/empty_page.dart';
//
///// [HomePage]
///// 仅带有一个 BottomNavigationBar
//class HomePage extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    return _IndexState();
//  }
//}
//
//class _IndexState extends State<HomePage> {
//  final List<BottomNavigationBarItem> _bottomNavItems = [
//    BottomNavigationBarItem(
//      icon: Icon(Icons.home),
//      title: Text("Home"),
//    ),
//    BottomNavigationBarItem(
//      icon: Icon(Icons.search),
//      title: Text("Search"),
//    ),
//    BottomNavigationBarItem(
//      icon: Icon(Icons.message),
//      title: Text("Message"),
//    ),
//    BottomNavigationBarItem(
//      icon: Icon(Icons.person),
//      title: Text("Profile"),
//    ),
//  ];
//
//  var _currentIndex;
//
//  final pages = [
//    ContentPage(),
//    EmptyPage(),
//    EmptyPage(),
//    EmptyPage(),
//  ];
//
//  @override
//  void initState() {
//    super.initState();
//    _currentIndex = 0;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: pages[_currentIndex],
//      bottomNavigationBar: BottomNavigationBar(
//        items: _bottomNavItems,
//        currentIndex: _currentIndex,
//        onTap: (index) {
//          _changePage(index);
//        },
//        selectedItemColor: Colors.blue,
//        unselectedItemColor: Colors.grey,
//        showUnselectedLabels: true,
//      ),
//    );
//  }
//
//  /*切换页面*/
//  void _changePage(int index) {
//    if (index != _currentIndex) {
//      setState(() {
//        _currentIndex = index;
//      });
//    }
//  }
//}
