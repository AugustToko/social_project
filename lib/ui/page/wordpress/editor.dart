import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:shared/login_sys/cache_center.dart';
import 'package:shared/model/wordpress/send/send_post_data.dart';
import 'package:shared/util/net_util.dart';
import 'package:shared/util/theme_util.dart';
import 'package:shared/util/tost.dart';
import 'package:shared/ui/loading_dialog.dart';
import 'package:social_project/model/editor/editor_data.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';
import 'package:zefyr/zefyr.dart';

import '../../../env.dart';

class EditorPage extends StatefulWidget {
  final BouncingScrollPhysics editorP = BouncingScrollPhysics();
  final BouncingScrollPhysics parentP = BouncingScrollPhysics();

  final FocusNode focusNode = FocusNode(canRequestFocus: true);

  final TextEditingController titleController = TextEditingController();

  final int lineHeight = 42;

  /// 预加载数据
  final EditorData editorData;

  EditorPage({Key key, this.editorData}) : super(key: key);

  @override
  EditorPageState createState() {
    return EditorPageState();
  }
}

class EditorPageState extends State<EditorPage> {
  File headerImage;
  int height = 300;

  ZefyrController controller;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    controller = ZefyrController(document);
    controller.addListener(() {
      setState(() {
        height =
            (controller.document.toPlainText().split('\n').length).round() *
                widget.lineHeight;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    widget.titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
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
                    if (widget.titleController.text == null ||
                        widget.titleController.text == "") {
                      showErrorToast(context, "标题不可为空!");
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (c) {
                          return LoadingDialog(
                            text: "正在发送文章...",
                          );
                        },
                      );
                      NetTools.sendPost(
                              WpCacheCenter.tokenCache.token,
                              SendPost(widget.titleController.text,
                                  controller.document.toPlainText(), true))
                          .then((post) {
                        if (post != null) {
                          Navigator.pop(context);
                        }
                      }).whenComplete((){
                        Navigator.pop(context, NavState.SendWpPostDone);
                      });
                    }
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
            physics: widget.parentP,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                children: <Widget>[
                  Card(
                    color: Theme.of(context).backgroundColor.withOpacity(0.5),
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
                      controller: widget.titleController,
                      keyboardType: TextInputType.text,
                      maxLength: 20,
                      decoration: InputDecoration(
                        helperText: "严禁标题党、灌水等",
                        helperStyle: TextStyle(
                            color: Theme.of(context).textTheme.subtitle.color),
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.subtitle.color),
                        labelText: "文章标题",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).textTheme.title.color)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: height.roundToDouble() < 300
                        ? 300
                        : height.roundToDouble(),
                    child: ZefyrScaffold(
                      child: ZefyrEditor(
                        mode: ZefyrMode.edit,
                        autofocus: false,
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller,
                        focusNode: widget.focusNode,
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
              context, controller.document.length > 1, () {
            _saveDocument(context);
          });
        });
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // 进行预加载数据
    if (widget.editorData != null) {
      widget.titleController.text = widget.editorData.title;
      final Delta delta = Delta.fromJson([widget.editorData.toJson()]);
      return NotusDocument.fromDelta(delta);
    }

    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final Delta delta = Delta()..insert("输入点什么吧 (*^_^*)\n");
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {
    // 解码 NotusDocument, 再编码为 Json
    print(jsonEncode(controller.document));
    var data =
        EditorData.fromJson(json.decode(jsonEncode(controller.document))[0]);
    data.title = widget.titleController.text ?? "";
    final contents = json.encode(data);

    Env.getTempArticlesDir().exists().then((exists) async {
      if (!exists) {
        await Env.getTempArticlesDir().create();
      }

      final file =
          File(Env.getTempArticlesDir().path + "/" + "${DateTime.now()}.json");
      debugPrint(file.path);
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
