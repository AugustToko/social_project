import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:zefyr/zefyr.dart';

import '../../../env.dart';

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  ZefyrController _controller;

  final TextEditingController titleController = TextEditingController();

  FocusNode _focusNode;

  File headerImage;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Theme
              .of(context)
              .backgroundColor,
          appBar: AppBar(
            title: Text("发表文章"),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 10, 5),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(width: 1.5, color: Colors.blue)),
                  onPressed: () {
//                if (titleController.text == null ||
//                    titleController.text == "") {
//                  showToast("标题不可为空!", position: ToastPosition.bottom);
//                } else {
//                  NetTools.sendPost(
//                          CacheCenter.tokenCache.token,
//                          SendPost(titleController.text, contentController.text,
//                              openComment))
//                      .then((post) {
//                    if (post != null) {
//                      showToast("发表成功!", position: ToastPosition.bottom);
//                      Navigator.pop(context, NavState.SendWpPostDone);
//                    }
//                  });
//                }
                  },
                  child: Text(
                    "发表",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: <Widget>[
                  Card(
                    color: Theme
                        .of(context)
                        .backgroundColor
                        .withOpacity(0.5),
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          height: ThemeUtil.headerImageHeight,
                          width: double.infinity,
                          child: headerImage == null
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "添加特色图片",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text("（请注意图片于文章的适应性）"),
                            ],
                          )
                              : Image.file(
                            headerImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () {
                        ImagePicker.pickImage(source: ImageSource.gallery)
                            .then((file) {
                          setState(() {
                            headerImage = file;
                          });
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: TextField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      maxLength: 20,
                      decoration: InputDecoration(
                        helperText: "严禁标题党、灌水等",
                        helperStyle: TextStyle(
                            color: Theme
                                .of(context)
                                .textTheme
                                .subtitle
                                .color),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme
                                .of(context)
                                .textTheme
                                .subtitle
                                .color),
                        labelText: "文章标题",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                Theme
                                    .of(context)
                                    .textTheme
                                    .title
                                    .color)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 330,
                    child: ZefyrScaffold(
                      child: ZefyrEditor(
                        mode: ZefyrMode.edit,
                        controller: _controller,
                        focusNode: _focusNode,
                        imageDelegate: MyAppZefyrImageDelegate(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () {
          return DialogUtil.showExitEditorDialog(
              context, _controller.document.length > 1, () {
            _saveDocument(context);
          });
        });
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final Delta delta = Delta()
      ..insert("\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {
    final contents = jsonEncode(_controller.document);

    Env.getTempArticlesDir().exists().then((exists) async {
      if (!exists) {
        await Env.getTempArticlesDir().create();
      }

      final file =
      File(Env
          .getTempArticlesDir()
          .path + "/" + "${DateTime.now()}.json");
      print(file.path);
      file.writeAsString(contents).then((_) {
        showToast("已保存！");
        Navigator.of(context).pop(true);
      });
    });
  }
}

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    print(file.path);
    if (file == null) return null;
    return file.uri.toString();
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    final file = File.fromUri(Uri.parse(key));
    final image = FileImage(file);
    return Image(image: image);
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}
