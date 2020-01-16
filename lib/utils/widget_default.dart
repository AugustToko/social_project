import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetDefault {
  static Widget defaultCircleAvatar(final BuildContext context, {final Color color}) => Icon(
        Icons.person,
        size: 40,
        color: color == null ? Theme.of(context).textTheme.title.color : color,
      );
}
