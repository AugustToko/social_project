import 'package:flutter/material.dart';
import 'package:social_project/utils/uidata.dart';

class LabelBelowIcon extends StatelessWidget {
  final label;
  final IconData icon;
  final iconColor;
  final onPressed;
  final circleColor;
  final isCircleEnabled;
  final betweenHeight;

  LabelBelowIcon(
      {this.label,
      this.icon,
      this.onPressed,
      this.iconColor = Colors.white,
      this.circleColor,
      this.isCircleEnabled = true,
        this.betweenHeight = 8.0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed,
//      customBorder: CircleBorder(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          isCircleEnabled
              ? CircleAvatar(
                  backgroundColor: circleColor,
            radius: 22.0,
                  child: Icon(
                    icon,
                    size: 20.0,
                    color: iconColor,
                  ),
                )
              : Icon(
                  icon,
                  size: 23.0,
                  color: iconColor,
                ),
          SizedBox(
            height: betweenHeight,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: UIData.ralewayFont),
          )
        ],
      ),
    );
  }
}
