import 'package:shared/ui/placeholder/placeholder_card_tall.dart';
import 'package:flutter/material.dart';

class SampleHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ListView.builder(
        itemCount: 9,
        itemBuilder: (content, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: PlaceholderCardTall(
              height: 200,
            ),
          );
        },
      ),
    );
  }
}
