import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/util/alert_dialog_util.dart';
import 'package:social_project/model/editor/editor_data.dart';
import 'package:social_project/utils/uidata.dart';

import '../../../env.dart';

class DraftBoxPage extends StatefulWidget {
  DraftBoxPage({Key key}) : super(key: key);

  @override
  _DraftBoxPageState createState() => _DraftBoxPageState();
}

class _DraftBoxPageState extends State<DraftBoxPage> {
//  List<FileSystemEntity> listData = [];
  List<EditorData> listEditorData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("草稿箱"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: MaterialButton(
              onPressed: () {
                DialogUtil.showAlertDialog(context, "清空草稿箱", "确定删除所有草稿？", [
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearData();
                      },
                      child: Text("确定")),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("取消"))
                ]);
              },
              child: Text(
                "清空草稿箱",
              ),
            ),
          )
        ],
      ),
      body: Center(
          child:
              listEditorData.length == 0 ? Text("恩，什么都没有。") : buildListView()),
    );
  }

  void _clearData() {
    Env.getTempArticlesDir().exists().then((exists) async {
      if (exists) {
        var list = await Env.getTempArticlesDir().list().toList();
        final stream = Stream.fromIterable(list);
        await for (var i in stream) {
          i.deleteSync();
        }
        _loadData();
      }
    });
  }

  /// 加载草稿数据
  void _loadData() {
    setState(() {
      listEditorData.clear();
    });
    Env.getTempArticlesDir().exists().then((exists) async {
      if (exists) {
        var list = await Env.getTempArticlesDir().list().toList();
        list.forEach((i) async {
          File(i.path).readAsString().then((str) {
            setState(() {
              listEditorData.add(EditorData.fromJson(jsonDecode(str)));
            });
          });
        });
      }
    });
  }

  buildListView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        var data = listEditorData[index];
        return Stack(
          children: <Widget>[
            Material(
              child: InkWell(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(35)),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              data.title,
                              style: Theme.of(context).textTheme.title,
                              textAlign: TextAlign.left,
                            )
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(18),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              data.insert.substring(
                                  0,
                                  data.insert.length > 30
                                      ? 30
                                      : data.insert.length),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(18),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Time",
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                            Text(
                              "图文",
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(UIData.sendPage,
                      arguments: {"editorData": data});
                },
              ),
            ),
            Container(
              color: Theme.of(context).textTheme.title.color.withOpacity(0.1),
              height: 1,
            )
          ],
        );
      },
      itemCount: listEditorData.length,
    );
  }
}
