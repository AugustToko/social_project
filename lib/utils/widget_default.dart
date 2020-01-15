import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetDefault {
  static Widget defaultCircleAvatar(final BuildContext context) => Icon(
        Icons.person,
        size: 40,
        color: Theme.of(context).textTheme.title.color,
      );
}
