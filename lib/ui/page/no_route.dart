import 'package:flutter/material.dart';

class NoRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Can't find route"),
        ),
        body: Center(
          child: Container(
            child: Text("Can't find route"),
          ),
        ));
  }
}
