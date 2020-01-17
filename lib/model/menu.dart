import 'package:flutter/material.dart';

class Menu {
  String title;
  String image;
  List<ListTile> items;
  BuildContext context;
  Color menuColor;

  Menu(
      {this.title,
      this.image,
      this.items,
      this.context,
      this.menuColor = Colors.black});
}

