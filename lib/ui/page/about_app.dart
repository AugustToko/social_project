import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/ui/widgets/flip_panel.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment Detail Page"),
      ),
      body: Column(
        children: <Widget>[AnimatedImagePage()],
      ),
    );
  }
}

class AnimatedImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageWidth = 320.0;
    final imageHeight = 171.0;
    final toleranceFactor = 0.033;
    final widthFactor = 0.125;
    final heightFactor = 0.5;

    final random = Random();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            0,
            1,
            2,
            3,
            4,
            5,
            6,
            7,
          ]
              .map((count) => FlipPanel.stream(
                    itemStream: Stream.fromFuture(Future.delayed(
                        Duration(milliseconds: random.nextInt(20) * 100),
                        () => 1)),
                    itemBuilder: (_, value) => value <= 0
                        ? Container(
                            color: Colors.white,
                            width: widthFactor * imageWidth,
                            height: heightFactor * imageHeight,
                          )
                        : ClipRect(
                            child: Align(
                                alignment: Alignment(
                                    -1.0 +
                                        count * 2 * 0.125 +
                                        count * toleranceFactor,
                                    -1.0),
                                widthFactor: widthFactor,
                                heightFactor: heightFactor,
                                child: Image.asset(
                                  'assets/images/timeline.jpeg',
                                  width: imageWidth,
                                  height: imageHeight,
                                  fit: BoxFit.cover,
                                ))),
                    initValue: 0,
                    spacing: 0.0,
                    direction: FlipDirection.up,
                  ))
              .toList(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            0,
            1,
            2,
            3,
            4,
            5,
            6,
            7,
          ]
              .map((count) => FlipPanel.stream(
                    itemStream: Stream.fromFuture(Future.delayed(
                        Duration(milliseconds: random.nextInt(20) * 100),
                        () => 1)),
                    itemBuilder: (_, value) => value <= 0
                        ? Container(
                            color: Colors.white,
                            width: widthFactor * imageWidth,
                            height: heightFactor * imageHeight,
                          )
                        : ClipRect(
                            child: Align(
                                alignment: Alignment(
                                    -1.0 +
                                        count * 2 * 0.125 +
                                        count * toleranceFactor,
                                    1.0),
                                widthFactor: widthFactor,
                                heightFactor: heightFactor,
                                child: Image.asset(
                                  'assets/images/timeline.jpeg',
                                  width: imageWidth,
                                  height: imageHeight,
                                  fit: BoxFit.cover,
                                ))),
                    initValue: 0,
                    spacing: 0.0,
                    direction: FlipDirection.down,
                  ))
              .toList(),
        )
      ],
    );
  }
}

//class FlipClockPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('FlipClock'),
//      ),
//      body: Center(
//        child: SizedBox(
//          height: 64.0,
//          child: FlipClock.simple(
//            startTime: DateTime.now(),
//            digitColor: Colors.white,
//            backgroundColor: Colors.black,
//            digitSize: 48.0,
//            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class CountdownClockPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('FlipClock'),
//      ),
//      body: Center(
//        child: SizedBox(
//          height: 64.0,
//          child: FlipClock.countdown(
//            duration: Duration(minutes: 1),
//            digitColor: Colors.white,
//            backgroundColor: Colors.black,
//            digitSize: 48.0,
//            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
//            onDone: () => print('ih'),
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class ReverseCountdown extends StatelessWidget {
//  //when using reverse countdown in your own app, change debugMode to false and provide the requied dDay values.
//  final bool debugMode = true;
//  DateTime now = DateTime.now();
//  DateTime dDay = DateTime(2018, 11, 26, 0, 0, 0);
//
//  @override
//  Widget build(BuildContext context) {
//    dDay = (debugMode)
//        ? DateTime(now.year, now.month + 2, now.day, now.hour, now.minute,
//            now.second + 10)
//        : dDay;
//
//    Duration _duration = dDay.difference(now);
//
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('ReverseCountdown'),
//      ),
//      body: Center(
//        child: SizedBox(
//          height: 64.0,
//          child: FlipClock.reverseCountdown(
//            duration: _duration,
//            digitColor: Colors.white,
//            backgroundColor: Colors.black,
//            digitSize: 30.0,
//            borderRadius: const BorderRadius.all(Radius.circular(3.0)),
//            //onDone: () => print('ih'),
//          ),
//        ),
//      ),
//    );
//  }
//}
