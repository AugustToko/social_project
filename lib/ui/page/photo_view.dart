///
///  photo_view.dart
///  create by zmtzawqlp on 2019/4/4
///

import 'dart:async';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide CircularProgressIndicator;
import 'package:loading_more_list/loading_more_list.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:social_project/logic/special_text/my_special_text_span_builder.dart';
import 'package:social_project/misc/photo_view_page_item_builder.dart';
import 'package:social_project/misc/my_extended_text_selection_controls.dart';
import 'package:social_project/model/menu.dart';
import 'package:social_project/ui/widgets/pic_grid_view.dart';
import 'package:social_project/ui/widgets/push_to_refresh_header.dart';
import 'package:social_project/model/tuchong/tu_chong_repository.dart';
import 'package:social_project/model/tuchong/tu_chong_source.dart';
import 'package:social_project/utils/bottom_sheet.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
    name: "fluttercandies://photoview",
    routeName: "photo view",
    description: "show how to zoom/pan image in page view like WeChat")
class PhotoViewDemo extends StatefulWidget {
  @override
  _PhotoViewDemoState createState() => _PhotoViewDemoState();
}

class _PhotoViewDemoState extends State<PhotoViewDemo> {
  MyExtendedMaterialTextSelectionControls
      _myExtendedMaterialTextSelectionControls;

  /// TODO: Sample Text, 演示富文本使用方法
//  final String _attachContent =
//      "[love]Extended text help you to build rich text quickly. any special text you will have with extended text.It's my pleasure to invite you to join \$FlutterCandies\$ if you want to improve flutter .[love] if you meet any problem, please let me konw @zmtzawqlp .[sun_glasses]";

  @override
  void initState() {
    _myExtendedMaterialTextSelectionControls =
        MyExtendedMaterialTextSelectionControls();
    super.initState();
  }

  final TuChongRepository listSourceRepository = TuChongRepository();

  //if you can't know image size before build,
  //you have to handle copy when image is loaded.
  bool knowImageSize = true;
  DateTime dateTimeNow = DateTime.now();

  @override
  void dispose() {
    listSourceRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double margin = ScreenUtil.instance.setWidth(22);
    Widget result = Material(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PullToRefreshNotification(
              pullBackOnRefresh: false,
              maxDragOffset: maxDragOffset,
              armedDragUpCancel: false,
              onRefresh: onRefresh,
              child: LoadingMoreCustomScrollView(
                showGlowLeading: false,
                physics: ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: PullToRefreshContainer((info) {
                      return PullToRefreshHeader(info, dateTimeNow);
                    }),
                  ),
                  LoadingMoreSliverList(
                    SliverListConfig<TuChongItem>(
                      collectGarbage: (List<int> indexes) {
                        ///collectGarbage
                        indexes.forEach((index) {
                          final item = listSourceRepository[index];
                          if (item.hasImage) {
                            item.images.forEach((image) {
                              image.clearCache();
                            });
                          }
                        });
                      },
                      itemBuilder: (context, item, index) {
                        String title = item.site.name;
                        if (title == null || title == "") {
                          title = "Image$index";
                        }

                        // 内容文本
                        var content = item.content ?? (item.excerpt ?? title);
//                        content += this._attachContent;

                        return Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, UIData.commentDetail);
                            },
                            onLongPress: () {
                              BottomSheetUtil.showSheetBottom(
                                  context,
                                  Menu(
                                      title: "Title",
                                      items: [
                                        "Menu 1",
                                        "Menu 2",
                                        "Menu 3",
                                        "Menu 4",
                                        "Menu 5",
                                        "Menu 6",
                                      ]));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(margin),
                                  child: Row(
                                    children: <Widget>[
                                      // 头像
                                      avatar(item.avatarUrl),
                                      SizedBox(
                                        width: margin,
                                      ),
                                      // TODO: 超出屏幕宽度
                                      // 用户名
                                      Row(
                                        children: <Widget>[
                                          Text("$title  "),
                                          RichText(
                                            maxLines: 1,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: "@Location · ",
                                                  style: ThemeUtil.subtitle),
                                              TextSpan(
                                                  text: "${item.passedTime}",
                                                  style: ThemeUtil.subtitle)
                                            ]),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  child: ExtendedText(
                                    content,
                                    // 文本点击
                                    onSpecialTextTap: (dynamic parameter) {
                                      print("content text  clicked!");
                                      if (parameter.startsWith("\$")) {
                                        showToast("Special text '\$' clicked.",
                                            position: ToastPosition.bottom);
                                      } else if (parameter.startsWith("@")) {
                                        showToast("Special text '@' clicked.",
                                            position: ToastPosition.bottom);
                                      }
                                    },
                                    specialTextSpanBuilder:
                                        MySpecialTextSpanBuilder(),
                                    //overflow: ExtendedTextOverflow.ellipsis,
//                                  style: TextStyle(
//                                      fontSize: ScreenUtil.instance.setSp(28),
//                                      color: Colors.grey),
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
                                    overFlowTextSpan: OverFlowTextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: '  \u2026  '),
                                        TextSpan(
                                            text: "more detail",
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launch(
                                                  "https://github.com/fluttercandies/extended_text",
                                                );
                                              })
                                      ],
                                    ),
                                    selectionEnabled: true,
                                    textSelectionControls:
                                        _myExtendedMaterialTextSelectionControls,
                                  ),
                                  padding: EdgeInsets.only(
                                    left: margin,
                                    right: margin,
                                    bottom: margin,
                                  ),
                                ),
                                // 标签
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: margin),
                                  child: buildTagsWidget(item, context),
                                ),
                                // 图片区域
                                PicGridView(
                                  tuChongItem: item,
                                ),
                                // 操作按钮区域
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                  child: buildBottomWidget(item,
                                      showAvatar: false),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      sourceList: listSourceRepository,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );

    return ExtendedTextSelectionPointerHandler(
      //default behavior
      // child: result,
      //custom your behavior
      builder: (states) {
        return Listener(
          child: result,
          behavior: HitTestBehavior.translucent,
          onPointerDown: (value) {
            for (var state in states) {
              if (!state.containsPosition(value.position)) {
                //clear other selection
                state.clearSelection();
              }
            }
          },
          onPointerMove: (value) {
            //clear other selection
            for (var state in states) {
              state.clearSelection();
            }
          },
        );
      },
    );
  }

  Future<bool> onRefresh() {
    return listSourceRepository.refresh().whenComplete(() {
      dateTimeNow = DateTime.now();
    });
  }

  avatar(String url) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              url,
            )),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, UIData.profile);
              },
              customBorder: CircleBorder(),
            ),
          ),
        ),
      ],
    );
//                                    InkWell(
//                                      onTap: () {
//                                        Navigator.pushNamed(
//                                            context, UIData.profile);
//                                      },
//                                      child: ExtendedImage.network(
//                                        item.avatarUrl,
//                                        width: 40.0,
//                                        height: 40.0,
//                                        shape: BoxShape.circle,
//                                        //enableLoadState: false,
//                                        border: Border.all(
//                                            color: Colors.grey.withOpacity(0.4),
//                                            width: 1.0),
//                                        loadStateChanged: (state) {
//                                          if (state.extendedImageLoadState ==
//                                              LoadState.completed) {
//                                            return null;
//                                          }
//                                          return Image.asset(
//                                            "assets/avatar.jpg",
//                                          );
//                                        },
//                                      ),
//                                    ),
  }
}
