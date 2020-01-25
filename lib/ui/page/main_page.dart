import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/ui/page/dashboard/dashboard_one.page.dart';
import 'package:social_project/ui/page/profile/profile_guest.dart';
import 'package:social_project/ui/page/sample/content/home_page.dart';
import 'package:social_project/ui/widgets/navbar/navbar.dart';
import 'package:social_project/ui/page/content_page.dart';
import 'package:social_project/ui/widgets/user_account_drawer.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';

/// [MainPage]
/// 仅带有一个 BottomNavigationBar
class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexState();
  }
}

class _IndexState extends State<MainPage> {
  List<NavBarItemData> _navBarItems;

  int _selectedNavIndex = 0;

  List<Widget> _viewsByIndex;

  @override
  void initState() {
    //Declare some buttons for our tab bar
    _navBarItems = [
      NavBarItemData("首页", OMIcons.home, 110, Color(0xff01b87d)),
      NavBarItemData("搜索", OMIcons.search, 110, Color(0xff594ccf)),
      NavBarItemData("消息", OMIcons.message, 115, Color(0xff09a8d9)),
      NavBarItemData("收藏", OMIcons.save, 105, Color(0xfff2873f)),
      NavBarItemData("我", OMIcons.person, 100, Color(0xffcf4c7a)),
    ];

    //Create the views which will be mapped to the indices for our nav btns
    _viewsByIndex = <Widget>[
      ContentPage(
//        drawer: UserAccountDrawer(),
        drawer: null,
      ),
      GuidePage(),
      SampleHomePage(),
      SampleHomePage(),
      ProfileContent(WordPressRep.wpSource),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];

//    FlutterStatusbarcolor.setNavigationBarColor(Theme.of(context).backgroundColor, animate: true);
//    FlutterStatusbarcolor.setNavigationBarWhiteForeground(Theme.of(context).backgroundColor.red < 120);

    // Wrap our custom navbar + contentView with the app Scaffold
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              width: double.infinity,
              //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 350),
                //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
                child: contentView,
              ),
            ),
            NavBar(
              items: _navBarItems,
              itemTapped: _handleNavBtnTapped,
              currentIndex: _selectedNavIndex,
            )
          ],
        ),
//        bottomNavigationBar: NavBar(
//          items: _navBarItems,
//          itemTapped: _handleNavBtnTapped,
//          currentIndex: _selectedNavIndex,
//        ), //Pass our custom navBar into the scaffold
      ),
      onWillPop: () => DialogUtil.showExitDialog(context),
    );
  }

  void _handleNavBtnTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }
}
