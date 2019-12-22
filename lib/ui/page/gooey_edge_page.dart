import 'package:flutter/material.dart';
import 'package:social_project/utils/uidata.dart';

import '../widgets/content_card.dart';
import '../widgets/gooey_carousel.dart';

/// GooeyEdgePage
class GooeyEdgePage extends StatefulWidget {
  GooeyEdgePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GooeyEdgePageState createState() => _GooeyEdgePageState();
}

class _GooeyEdgePageState extends State<GooeyEdgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GooeyCarousel(
        children: <Widget>[
          ContentCard(
            color: 'Red',
            altColor: Color(0xFF4259B2),
            title: "${UIData.appName} Tile one \n第一页",
            subtitle:
                'This is a main social APP.',
          ),
          ContentCard(
            color: 'Yellow',
            altColor: Color(0xFF904E93),
            title: "${UIData.appName} Tile two \n第二页",
            subtitle:
                'This is a main social APP.',
          ),
          ContentCard(
            color: 'Blue',
            altColor: Color(0xFFFFB138),
            title: "${UIData.appName} Tile three \n第三页",
            subtitle:
                'This is a main social APP.',
          ),
        ],
      ),
    );
  }
}
