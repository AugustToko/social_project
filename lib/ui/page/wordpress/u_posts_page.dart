import 'dart:async';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide CircularProgressIndicator;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_rep_argments_posts.dart';
import 'package:social_project/ui/page/pic_swiper.dart';
import 'package:social_project/ui/widgets/loading_more_list_widget/list_config.dart';
import 'package:social_project/ui/widgets/loading_more_list_widget/loading_more_sliver_list.dart';
import 'package:social_project/ui/widgets/push_to_refresh_header.dart';
import 'package:social_project/utils/bottom_sheet.dart';
import 'package:social_project/utils/route/app_route.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';

/// 通用文章展示页面（列表）
/// TODO: 简化代码
class PostsPage extends StatefulWidget {
  final String _url;
  final AppBar _appBar;

  PostsPage(this._url, this._appBar);

  @override
  _WordPressPageState createState() => _WordPressPageState(_url, _appBar);
}

class _WordPressPageState extends State<PostsPage> {
  ArgPostsRep listSourceRepository;

  final String _url;

  final AppBar _appBar;

  _WordPressPageState(this._url, this._appBar);

  @override
  void initState() {
    listSourceRepository = ArgPostsRep(_url);
    super.initState();
  }

  // if you can't know image size before build,
  // you have to handle copy when image is loaded.
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
                  LyLoadingMoreSliverList(
                    LySliverListConfig<WpPost>(
                      indicatorBuilder: (p, q) {
                        return listSourceRepository.length > 0
                            ? Text(
                                "—————— 做人也是要有底线的哦 ——————",
                                textAlign: TextAlign.center,
                              )
                            : null;
                      },
                      collectGarbage: (List<int> indexes) {
                        ///TODO: collectGarbage
                        indexes.forEach((index) {});
                      },
                      itemBuilder: (context, item, index) {
                        String title = item.title.rendered;
                        if (title == null || title == "") {
                          title = "Image$index";
                        }

                        // 内容文本
                        var content = item.content.rendered;

                        // 修复图片
                        if (WordPressRep.wpSource == WpSource.WeiRan) {
                          content = content.replaceAll(
                              "weiran-1254802562.file.myqcloud.com/static/weiran_index/wp-content/uploads/",
                              "static.weiran.org.cn/img/");
                        }

                        content = content.replaceAll("[java]", "<code>");
                        content = content.replaceAll("[/java]", "</code>");

                        content = content.replaceAll("[xml]", "<code>");
                        content = content.replaceAll("[/xml]", "</code>");

                        // 裁剪内容
                        // TODO: 裁剪规范，如何使 card 大小适中
                        var contentSmall = content.substring(
                            0, content.length < 1050 ? content.length : 1050);

                        contentSmall += "<h2>......</h2>";
                        return ThemeUtil.materialPostCard(
                            InkWell(
                              onTap: () {
                                goToWpPostDetail(context, item);
                              },
                              onLongPress: () {
                                BottomSheetUtil.showPostSheetShow(
                                    context, item);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          title,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Html(
                                          data: contentSmall,
                                          showImages: true,
                                          useRichText: false,
                                          linkStyle: TextStyle(),
                                          customRender: (node, children) {
                                            if (node is dom.Element) {
                                              switch (node.localName) {
                                                case "video":
                                                  return Text("[Video Here]");
                                                case "img":
                                                  String imageUrl =
                                                      node.attributes[
                                                          "data-original"];
                                                  return imageUrl == null
                                                      ? null
                                                      : Image.network(imageUrl);
                                                default:
                                                  return null;
                                              }
                                            } else {
                                              return null;
                                            }
                                          },
                                          onImageTap: (url) {
                                            Navigator.pushNamed(context,
                                                "fluttercandies://picswiper",
                                                arguments: {
                                                  "index": 0,
                                                  "pics": [PicSwiperItem(url)],
                                                });
                                          },
                                          onImageError: (p1, p2) {
                                            print(
                                                "Image Error---------------start-----------------");
                                            print(p1);
                                            print(
                                                "-----===-------=======------====-----");
                                            print(p2);
                                            print(
                                                "Image Error----------------end----------------");
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
//                                      child: actionRow(item),
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.only(
                                      left: margin,
                                      right: margin,
                                      bottom: margin,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            item,
                            margin);
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

    return Scaffold(
      appBar: _appBar,
      body: ExtendedTextSelectionPointerHandler(
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
      ),
    );
  }

  Future<bool> onRefresh() {
    return listSourceRepository.refresh().whenComplete(() {
      dateTimeNow = DateTime.now();
    });
  }

//  avatar(int userId) {
//    var widget = Stack(
//      children: <Widget>[
//        CircleAvatar(
//            radius: 25.0,
//            backgroundImage: NetworkImage(
//              "",
//            )),
//        Positioned.fill(
//          child: Material(
//            color: Colors.transparent,
//            child: InkWell(
//              onTap: () {
//                Navigator.pushNamed(context, UIData.profile);
//              },
//              customBorder: CircleBorder(),
//            ),
//          ),
//        ),
//      ],
//    );
//
//    NetTools.getWpUserInfo(NetTools.weiranSite, userId).then((user){
//      print("avatar: " + user.avatarUrls.s96);
//      widget.children.removeAt(0);
//      widget.children.insert(0, CircleAvatar(
//          radius: 25.0,
//          backgroundImage: NetworkImage(
//            user.avatarUrls.s96,
//          )));
//    });
//
//    return widget;
//
//
////                                    InkWell(
////                                      onTap: () {
////                                        Navigator.pushNamed(
////                                            context, UIData.profile);
////                                      },
////                                      child: ExtendedImage.network(
////                                        item.avatarUrl,
////                                        width: 40.0,
////                                        height: 40.0,
////                                        shape: BoxShape.circle,
////                                        //enableLoadState: false,
////                                        border: Border.all(
////                                            color: Colors.grey.withOpacity(0.4),
////                                            width: 1.0),
////                                        loadStateChanged: (state) {
////                                          if (state.extendedImageLoadState ==
////                                              LoadState.completed) {
////                                            return null;
////                                          }
////                                          return Image.asset(
////                                            "assets/avatar.jpg",
////                                          );
////                                        },
////                                      ),
////                                    ),
//  }
}
