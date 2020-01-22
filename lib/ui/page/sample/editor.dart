import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';
import 'package:zefyr/zefyr.dart';

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

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
          backgroundColor: Colors.white,
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
                      color: Colors.blue,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: ZefyrScaffold(
            child: ZefyrEditor(
              padding: EdgeInsets.all(16),
              mode: ZefyrMode.edit,
              controller: _controller,
              focusNode: _focusNode,
              imageDelegate: MyAppZefyrImageDelegate(),
            ),
          ),
        ),
        onWillPop: () {
          return DialogUtil.showExitEditorDialog(context, _controller.document.length > 1);
        });
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final Delta delta = Delta()..insert("\n");
    return NotusDocument.fromDelta(delta);
  }
}

class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
  @override
  Future<String> pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    print(file.path);
    if (file == null) return null;
    // We simply return the absolute path to selected file.
    return file.uri.toString();
  }

  @override
  Widget buildImage(BuildContext context, String key) {
    final file = File.fromUri(Uri.parse(key));

    /// Create standard [FileImage] provider. If [key] was an HTTP link
    /// we could use [NetworkImage] instead.
    final image = FileImage(file);
    return Image(image: image);
  }

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;
}
