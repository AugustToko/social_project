import 'package:flutter/material.dart';

import 'clipped_view.dart';
import 'navbar_button.dart';

class NavBar extends StatelessWidget {
  final ValueChanged<int> itemTapped;
  final int currentIndex;
  final List<NavBarItemData> items;

  const NavBar({this.items, this.itemTapped, this.currentIndex = 0});

  NavBarItemData get selectedItem =>
      currentIndex >= 0 && currentIndex < items.length
          ? items[currentIndex]
          : null;

  @override
  Widget build(BuildContext context) {
    //For each item in our list of data, create a NavBtn widget
    List<Widget> buttonWidgets = items.map((data) {
      //Create a button, and add the onTap listener
      return NavbarButton(data, data == selectedItem, onTap: () {
        //Get the index for the clicked data
        var index = items.indexOf(data);
        //Notify any listeners that we've been tapped, we rely on a parent widget to change our selectedIndex and redraw
        itemTapped(index);
      });
    }).toList();

    // 创建一个包含一行的容器，然后将btn小部件添加到该行中
    return Container(
      decoration: BoxDecoration(
        // navBar 背景颜色
        color: Theme.of(context).backgroundColor,
        // 在我们的导航栏中添加一些阴影，使用 2 可获得更好的效果
        boxShadow: [
          BoxShadow(blurRadius: 16, color: Colors.black12),
          BoxShadow(blurRadius: 24, color: Colors.black12),
        ],
      ),
      alignment: Alignment.center,
      height: 64,
      // 裁剪小部件行，以抑制动画期间可能发生的任何溢出错误
      child: ClippedView(
        child: Row(
          // 水平居中按钮
          mainAxisAlignment: MainAxisAlignment.center,
          // Inject a bunch of btn instances into our row
          // 向我们的行中注入一堆btn实例
          children: buttonWidgets,
        ),
      ),
    );
  }
}

class NavBarItemData {
  final String title;
  final IconData icon;
  final Color selectedColor;
  final double width;

  NavBarItemData(this.title, this.icon, this.width, this.selectedColor);
}
