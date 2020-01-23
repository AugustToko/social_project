import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetDefault {
  static Widget defaultCircleAvatar(final BuildContext context, {final Color color, final double size}) => Icon(
        Icons.person,
        size: size ?? 40,
        color: color == null ? Theme.of(context).textTheme.title.color : color,
      );
}
