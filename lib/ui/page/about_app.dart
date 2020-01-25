import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/ui/widgets/flip_panel.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

//  @override
//  void dispose() {
//    super.dispose();
//    FlutterStatusbarcolor.setNavigationBarColor(Colors.black, animate: true);
//    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("关于"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(
                style: FlutterLogoStyle.markOnly,
                size: 110,
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            customBorder: CircleBorder(),
            child: Column(
              children: <Widget>[
                Text(
                  "零昀",
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Step By Step",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            onTap: () {
              DialogUtil.showAlertDialog(
                  context, "零昀 Step By Step", "即使黑暗，我们也一步一个脚印得往前走。", [
                FlatButton(
                    onPressed: () {
                      FlutterWebBrowser.openWebPage(
                          url: WordPressRep.aboutBlogGeek,
                          androidToolbarColor: Theme.of(context).primaryColor);
                    },
                    child: Text("加入我们"))
              ]);
            },
          ),
          SizedBox(
            height: 240,
          ),
          CupertinoButton(
            onPressed: () {
              FlutterWebBrowser.openWebPage(
                  url: WordPressRep.baseBlogGeekUrl,
                  androidToolbarColor: Theme.of(context).primaryColor);
            },
            pressedOpacity: 0.8,
            child: Container(
              alignment: Alignment.center,
              width: 300,
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  gradient: LinearGradient(colors: [
                    Color(0xFF686CF2),
                    Color(0xFF0E5CFF),
                  ]),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x4D5E56FF),
                        offset: Offset(0.0, 4.0),
                        blurRadius: 13.0)
                  ]),
              child: Text(
                "访问官网",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          RaisedButton(
            shape: StadiumBorder(),
            child: Text(
              "开源许可证",
              style: TextStyle(color: Theme.of(context).textTheme.title.color),
            ),
            color: Theme.of(context).backgroundColor,
            elevation: 0,
            onPressed: () {
              FlutterWebBrowser.openWebPage(
                  url: WordPressRep.blogGeekReg,
                  androidToolbarColor: Theme.of(context).primaryColor);
//                      launch(WordPressRep.blogGeekReg);
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Developed by August 827266641@qq.com",
            style: TextStyle(fontSize: 10),
          )
        ],
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
