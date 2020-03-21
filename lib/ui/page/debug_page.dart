import 'package:flutter/material.dart';
import 'package:shared/ui/loading_dialog.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Debug Page"),
        ),
        body: Column(
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                var dialog = LoadingDialog(
                  text: "正在上传媒体文件...",
                );

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (c) {
                    return dialog;
                  },
                );

              },
              child: Text("Loading Dialog"),
            )
          ],
        ));
  }
}
