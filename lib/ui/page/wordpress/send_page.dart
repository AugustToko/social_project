import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/model/wordpress/send/send_post_data.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/route/app_route.dart';
import 'package:social_project/utils/theme_util.dart';

/// 编辑文章、回复文章
/// TODO: 待完善
class SendPage extends StatefulWidget {
  SendPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SendPageState createState() {
    print("CREATE STATE");
    return _SendPageState();
  }
}

class _SendPageState extends State<SendPage> {
  bool openComment = true;

  File headerImage;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("发表文章"),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 10, 5),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(width: 1.5, color: Colors.blue)),
              onPressed: () {
                if (titleController.text == null ||
                    titleController.text == "") {
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
                  Card(
                    color: Theme.of(context).backgroundColor.withOpacity(0.5),
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Container(
                          height: ThemeUtil.headerImageHeight,
                          width: double.infinity,
                          child: headerImage == null ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "添加特色图片",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text("（请注意图片于文章的适应性）"),
                            ],
                          ) : Image.file(headerImage, fit: BoxFit.cover,),
                        ),
                      ),
                      onTap: () {
                        ImagePicker.pickImage(
                            source: ImageSource.gallery).then((file){
                              setState(() {
                                headerImage = file;
                              });
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                    decoration: InputDecoration(
                      helperText: "严禁标题党、灌水等",
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
                  SizedBox(
                    height: 15,
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
