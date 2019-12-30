///
///  photo_view.dart
///  create by zmtzawqlp on 2019/4/4
///

import 'dart:async';
import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide CircularProgressIndicator;
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:social_project/logic/special_text/my_special_text_span_builder.dart';
import 'package:social_project/misc/photo_view_page_item_builder.dart';
import 'package:social_project/misc/my_extended_text_selection_controls.dart';
import 'package:social_project/ui/widgets/pic_grid_view.dart';
import 'package:social_project/ui/widgets/push_to_refresh_header.dart';
import 'package:social_project/model/tuchong/tu_chong_repository.dart';
import 'package:social_project/model/tuchong/tu_chong_source.dart';
import 'package:social_project/utils/screen_util.dart';
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
  final String _attachContent =
      "[love]Extended text help you to build rich text quickly. any special text you will have with extended text.It's my pleasure to invite you to join \$FlutterCandies\$ if you want to improve flutter .[love] if you meet any problem, please let me konw @zmtzawqlp .[sun_glasses]";

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

                        var content = item.content ?? (item.excerpt ?? title);
                        content += this._attachContent;

                        return Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(margin),
                                child: Row(
                                  children: <Widget>[
                                    // 头像
                                    ExtendedImage.network(
                                      item.avatarUrl,
                                      width: 40.0,
                                      height: 40.0,
                                      shape: BoxShape.circle,
                                      //enableLoadState: false,
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.4),
                                          width: 1.0),
                                      loadStateChanged: (state) {
                                        if (state.extendedImageLoadState ==
                                            LoadState.completed) {
                                          return null;
                                        }
                                        return Image.asset("assets/avatar.jpg");
                                      },
                                    ),
                                    SizedBox(
                                      width: margin,
                                    ),
                                    // 用户名
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: ScreenUtil.instance.setSp(34),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                child: ExtendedText(
                                  content,
                                  // 文本点击
                                  onSpecialTextTap: (dynamic parameter) {
                                    if (parameter.startsWith("\$")) {
                                      launch(
                                          "https://github.com/fluttercandies");
                                    } else if (parameter.startsWith("@")) {
                                      launch("mailto:zmtzawqlp@live.com");
                                    }
                                  },
                                  specialTextSpanBuilder:
                                      MySpecialTextSpanBuilder(),
                                  //overflow: ExtendedTextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: ScreenUtil.instance.setSp(28),
                                      color: Colors.grey),
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
                                                  "https://github.com/fluttercandies/extended_text");
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
                                child: buildTagsWidget(item),
                              ),
                              // 图片区域
//                              ClipRRect(
//                                borderRadius: BorderRadius.circular(8.0),
//                                child:
                              PicGridView(
                                tuChongItem: item,
                              ),
//                              ),
                              // 操作按钮区域
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child:
                                    buildBottomWidget(item, showAvatar: false),
                              ),
                              SizedBox(
                                height: margin,
                              ),
                            ],
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
}
