import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final title;
  final subtitle;
  final textColor;

  ProfileTile({this.title, this.subtitle, this.textColor});

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).textTheme.title.color;

    if (textColor != null) {
      color = textColor;
    }

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
