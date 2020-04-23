//import 'dart:async';
//import 'dart:convert';
//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:oktoast/oktoast.dart';
//import 'package:provider/provider.dart';
//import 'package:quill_delta/quill_delta.dart';
//import 'package:wpmodel/config/cache_center.dart';
//import 'package:wpmodel/model/send/send_post_data.dart';
//import 'package:wpmodel/model/wp_media_data.dart';
//import 'package:wpmodel/mvvm/view/base.dart';
//import 'package:shared/ui/loading_dialog.dart';
//import 'package:shared/util/dialog_util.dart';
//import 'package:shared/util/theme_util.dart';
//import 'package:shared/util/toast.dart';
//import 'package:social_project/model/editor/editor_data.dart';
//import 'package:social_project/rebuild/viewmodel/editor_page_provider.dart';
//import 'package:wpmodel/util/wp_net_utils.dart';
//import 'package:zefyr/zefyr.dart';
//
//import '../../../env.dart';
//
//class EditorPage extends PageProvideNode<EditorPageProvider> {
//  static const String editorPage = "/editorPage";
//
//  /// 预加载数据
//  final EditorData editorData;
//
//  EditorPage({this.editorData});
//
//  @override
//  Widget buildContent(final BuildContext context) {
//    return _EditorPageContent(
//      provide: mProvider,
//      editorData: editorData,
//    );
//  }
//}
//
//class _EditorPageContent extends StatefulWidget {
//  final BouncingScrollPhysics editorP = BouncingScrollPhysics();
//  final BouncingScrollPhysics parentP = BouncingScrollPhysics();
//  final EditorData editorData;
//  final FocusNode focusNode = FocusNode(canRequestFocus: true);
//  final TextEditingController titleController = TextEditingController();
//
//  final int lineHeight = 42;
//
//  final EditorPageProvider provide;
//
//  _EditorPageContent({this.provide, this.editorData});
//
//  @override
//  State<StatefulWidget> createState() {
//    return EditorPageState();
//  }
//}
//
//class EditorPageState extends State<_EditorPageContent>
//    with TickerProviderStateMixin<_EditorPageContent>
//    implements Presenter {
//  EditorPageProvider mProvide;
//
//  static const String ACTION_SEND = "ACTION_SEND";
//
//  var openComment = true;
//
//  @override
//  void initState() {
//    super.initState();
//    mProvide = widget.provide;
//    final document = _loadDocument();
//
//    mProvide.controller = ZefyrController(document);
//    mProvide.controller.addListener(() {
//      mProvide.height =
//          (mProvide.controller.document.toPlainText().split('\n').length)
//                  .round() *
//              widget.lineHeight;
//    });
//  }
//
//  @override
//  void dispose() {
//    widget.titleController.dispose();
//    mProvide.disposeControllers();
//    mProvide.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//        child: Scaffold(
//          backgroundColor: Theme.of(context).backgroundColor,
//          appBar: AppBar(
//            title: Text("发表文章"),
//            actions: <Widget>[
//              Padding(
//                padding: EdgeInsets.fromLTRB(0, 8, 10, 5),
//                child: MaterialButton(
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(5),
//                      side: BorderSide(width: 1.5, color: Colors.blue)),
//                  onPressed: () => onClick(ACTION_SEND),
//                  child: Text(
//                    "发表",
//                    style: TextStyle(
//                      fontSize: 16,
//                      color: Colors.blue,
//                    ),
//                  ),
//                ),
//              )
//            ],
//          ),
//          body: SingleChildScrollView(
//            physics: widget.parentP,
//            child: Padding(
//              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//              child: Column(
//                children: <Widget>[
//                  buildHeaderImage(),
//                  SizedBox(
//                    height: 20,
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
//                    child: TextField(
//                      controller: widget.titleController,
//                      keyboardType: TextInputType.text,
//                      maxLength: 20,
//                      decoration: InputDecoration(
//                        helperText: "严禁标题党、灌水等",
//                        helperStyle: TextStyle(
//                            color: Theme.of(context).textTheme.subtitle.color),
//                        labelStyle: TextStyle(
//                            fontWeight: FontWeight.bold,
//                            color: Theme.of(context).textTheme.subtitle.color),
//                        labelText: "文章标题",
//                        focusedBorder: OutlineInputBorder(
//                          borderSide: BorderSide(color: Colors.blue),
//                        ),
//                        enabledBorder: OutlineInputBorder(
//                            borderSide: BorderSide(
//                                color:
//                                    Theme.of(context).textTheme.title.color)),
//                      ),
//                    ),
//                  ),
//                  Divider(),
//                  CheckboxListTile(
//                    value: openComment,
//                    onChanged: (newValue) {
//                      setState(() {
//                        openComment = newValue;
//                      });
//                    },
//                    title: Text('开启评论'),
//                    secondary: Icon(Icons.comment),
//                    selected: true,
//                  ),
//                  Divider(),
//                  buildEditor()
//                ],
//              ),
//            ),
//          ),
//        ),
//        onWillPop: () {
//          return DialogUtil.showExitEditorDialog(
//              context, mProvide.controller.document.length > 1, () {
//            _saveDocument(context);
//          });
//        });
//  }
//
//  Consumer<EditorPageProvider> buildHeaderImage() {
//    return Consumer<EditorPageProvider>(
//      builder: (context, value, child) {
//        return Card(
//          color: Theme.of(context).backgroundColor.withOpacity(0.5),
//          child: InkWell(
//            child: Padding(
//              padding: EdgeInsets.all(8),
//              child: Container(
//                height: ThemeUtil.headerImageHeight,
//                width: double.infinity,
//                child: mProvide.headerImage == null
//                    ? Column(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Text(
//                            "添加特色图片",
//                            style: TextStyle(fontSize: 20),
//                          ),
//                          Text("（请注意图片于文章的适应性）"),
//                        ],
//                      )
//                    : Image.file(
//                        mProvide.headerImage,
//                        fit: BoxFit.cover,
//                      ),
//              ),
//            ),
//            onTap: () {
//              ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
//                mProvide.headerImage = file;
//                print("---------------- pickup file -----------------------");
//                debugPrint(file.path);
//              });
//            },
//          ),
//        );
//      },
//    );
//  }
//
//  Consumer<EditorPageProvider> buildEditor() {
//    return Consumer<EditorPageProvider>(
//      builder: (context, value, child) {
//        return Container(
//          height: mProvide.height.roundToDouble() < 300
//              ? 300
//              : mProvide.height.roundToDouble(),
//          child: ZefyrScaffold(
//            child: ZefyrEditor(
//              mode: ZefyrMode.edit,
//              autofocus: false,
//              physics: NeverScrollableScrollPhysics(),
//              controller: mProvide.controller,
//              focusNode: widget.focusNode,
//              imageDelegate: MyAppZefyrImageDelegate(),
//            ),
//          ),
//        );
//      },
//    );
//  }
//
//  NotusDocument _loadDocument() {
//    // 进行预加载数据
//    if (widget.editorData != null) {
//      widget.titleController.text = widget.editorData.title;
//      final Delta delta = Delta.fromJson([widget.editorData.toJson()]);
//      return NotusDocument.fromDelta(delta);
//    }
//
//    // 如果没有预载，进行默认数据填充
//    final Delta delta = Delta()..insert("输入点什么吧 (*^_^*)\n");
//    widget.titleController.text = "文章标题";
//    return NotusDocument.fromDelta(delta);
//  }
//
//  void _saveDocument(BuildContext context) {
//    // 解码 NotusDocument, 再编码为 Json
//    print(jsonEncode(mProvide.controller.document));
//    var data = EditorData.fromJson(
//        json.decode(jsonEncode(mProvide.controller.document))[0]);
//    data.title = widget.titleController.text ?? "";
//    final contents = json.encode(data);
//
//    Env.getTempArticlesDir().exists().then((exists) async {
//      if (!exists) {
//        await Env.getTempArticlesDir().create();
//      }
//
//      final file =
//          File(Env.getTempArticlesDir().path + "/" + "${DateTime.now()}.json");
//      debugPrint(file.path);
//      file.writeAsString(contents).then((_) {
//        showToast("已保存！");
//        Navigator.of(context).pop(true);
//      });
//    });
//  }
//
//  @override
//  Future<void> onClick(final String action) async {
//    switch (action) {
//      case ACTION_SEND:
//        {
//          if (widget.titleController.text == null ||
//              widget.titleController.text == "") {
//            showErrorToast(context, "标题不可为空!");
//          } else {
//            WpMediaUploaded mediaData;
//            if (mProvide.headerImage != null) {
//              showDialog(
//                context: context,
//                barrierDismissible: false,
//                builder: (c) {
//                  return LoadingDialog(
//                    text: "正在上传媒体文件...",
//                  );
//                },
//              );
//
//              mediaData = await WpNetTools.uploadImage(
//                  WpCacheCenter.tokenCache.token,
//                  mProvide.headerImage.path,
//                  "test.png");
//
//              Navigator.pop(context);
//            }
//
//            showDialog(
//              context: context,
//              barrierDismissible: false,
//              builder: (c) {
//                return LoadingDialog(
//                  text: "正在发送文章...",
//                );
//              },
//            );
//
//            WpNetTools.sendPost(
//                    WpCacheCenter.tokenCache.token,
//                    SendPost(widget.titleController.text,
//                        mProvide.controller.document.toPlainText(),
//                        allowComment: openComment,
//                        featuredMedia: mediaData == null ? -1 : mediaData.id))
//                .then((post) {
//              if (post != null) {
//                Navigator.pop(context);
//              }
//            }).whenComplete(() {
//              Navigator.pop(context, true);
//              showSuccessToast(context, "文章发表成功！");
//            });
//          }
//        }
//        break;
//    }
//  }
//}
//
//class MyAppZefyrImageDelegate implements ZefyrImageDelegate<ImageSource> {
//  @override
//  Future<String> pickImage(ImageSource source) async {
//    final file = await ImagePicker.pickImage(source: source);
//    print(file.path);
//    if (file == null) return null;
//    return file.uri.toString();
//  }
//
//  @override
//  Widget buildImage(BuildContext context, String key) {
//    final file = File.fromUri(Uri.parse(key));
//    final image = FileImage(file);
//    return Image(image: image);
//  }
//
//  @override
//  ImageSource get cameraSource => ImageSource.camera;
//
//  @override
//  ImageSource get gallerySource => ImageSource.gallery;
//}
