import 'package:flutter/material.dart';

class LyEmptyWidget extends StatelessWidget {
  final String msg;
  final Widget emptyWidget;

  LyEmptyWidget(this.msg, {this.emptyWidget});

  @override
  Widget build(BuildContext context) {
    if (emptyWidget != null) return emptyWidget;
    return Container(
      color: Theme.of(context).backgroundColor,
      margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 180.0,
              width: 180.0,
              child: Text("这里什么都没有哦~"),
            ),
            Text(
              msg,
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
