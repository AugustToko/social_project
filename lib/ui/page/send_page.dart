import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/model/wordpress/send/send_post_data.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/route/example_route.dart';

/// 编辑文章、回复文章
class SendPage extends StatefulWidget {
  SendPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  bool openComment = true;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发表文章"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          MaterialButton(
            shape: StadiumBorder(),
            onPressed: () {
              if (titleController.text == null || titleController.text == "") {
                showToast("标题不可为空!", position: ToastPosition.bottom);
              } else {
                NetTools.sendPost(
                    CacheCenter.tokenCache.token,
                    SendPost(titleController.text, contentController.text,
                        openComment))
                    .then((post) {
                  if (post != null) {
                    showToast("发表成功!", position: ToastPosition.bottom);
                    Navigator.pop(context, NavState.SendWpPostDone);
                  }
                });
              }
            },
            child: Text(
              "发表",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.subtitle.color),
                      labelText: "文章标题",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).textTheme.title.color)),
                    ),
                  ),
                  TextField(
                    controller: contentController,
                    keyboardType: TextInputType.text,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.subtitle.color),
                      labelText: "文章内容",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).textTheme.title.color)),
                    ),
                    maxLines: 5,
                  ),
//                  Card(
//                    child: ListView.builder(
//                      scrollDirection: Axis.horizontal,
//                      itemCount: 5,
//                      itemBuilder: (context, i) => Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Image.network(
//                          "https://cdn.pixabay.com/photo/2016/10/31/18/14/ice-1786311_960_720.jpg",
//                        ),
//                      ),
//                    ),
//                  ),
                  CheckboxListTile(
                    value: openComment,
                    onChanged: (newValue) {
                      setState(() {
                        openComment = newValue;
                      });
                    },
                    title: Text('开启评论'),
                    secondary: Icon(Icons.comment),
                    selected: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
