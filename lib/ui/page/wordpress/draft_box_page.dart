import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';
import 'package:social_project/utils/theme_util.dart';

import '../../../env.dart';

class DraftBoxPage extends StatefulWidget {
  DraftBoxPage({Key key}) : super(key: key);

  @override
  _DraftBoxPageState createState() => _DraftBoxPageState();
}

class _DraftBoxPageState extends State<DraftBoxPage> {
  List<FileSystemEntity> listData = [];

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
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        ],
      ),
      body: Center(
          child: listData.length == 0
              ? Text("恩，什么都没有。")
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(listData[index].path),
                    );
                  },
                  itemCount: listData.length,
                )),
    );
  }

  void _clearData() {
    Env.getTempArticlesDir().exists().then((exists) {
      if (exists) {
        Env.getTempArticlesDir().list().toList().then((list) {
          list.forEach((e) {
            e.delete();
          });
        }).whenComplete(() {
          _loadData();
        });
      }
    });
  }

  void _loadData() {
    listData.clear();
    Env.getTempArticlesDir().exists().then((exists) {
      if (exists) {
        Env.getTempArticlesDir().list().toList().then((list) {
          setState(() {
            listData.addAll(list);
          });
        });
      }
    });
  }
}
