import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart'
    as re;
import 'package:share/share.dart';
import 'package:html/dom.dart' as dom;
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/ui/widgets/push_to_refresh_header.dart';
import 'package:social_project/ui/widgets/wp/user_header.dart';
import 'package:social_project/utils/bottom_sheet.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';

import '../pic_swiper.dart';

/// 获取 WordPress Posts
class WordPressPage extends StatefulWidget {
  final List<_WordPressPageState> _list = List(1);

  void onNewPostReleased() {
    var state = _list[0];
    if (state != null) {
      state.onNewPostReleased();
    }
  }

  @override
  _WordPressPageState createState() {
    _list[0] = _WordPressPageState(WordPressRep.wpSource);
    return _list[0];
  }
}

class _WordPressPageState extends State<WordPressPage> {
//  final MyExtendedMaterialTextSelectionControls
//      _myExtendedMaterialTextSelectionControls =
//      MyExtendedMaterialTextSelectionControls();

  WordPressRep listSourceRepository;

  final WpSource _wpSource;

  _WordPressPageState(this._wpSource);

  @override
  void initState() {
    listSourceRepository = WordPressRep(WordPressRep.getWpLink(_wpSource));
    super.initState();
  }

  // if you can't know image size before build,
  // you have to handle copy when image is loaded.
  bool knowImageSize = true;
  DateTime dateTimeNow = DateTime.now();

  Widget actionRow(final WpPost post) {
    const double iconSize = 18.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        LikeButton(
          likeCount: 999,
          onTap: (bool val) {
            Navigator.pushNamed(
              context,
              UIData.sendPage,
            );
            return Future.value(true);
          },
          likeBuilder: (bool isClicked) {
            return Icon(
              FontAwesomeIcons.comment,
              color: isClicked ? Colors.deepPurpleAccent : Colors.grey,
              size: iconSize,
            );
          },
        ),
        LikeButton(
          likeCount: 999,
          likeBuilder: (bool isClicked) {
            return Icon(
              FontAwesomeIcons.retweet,
              color: isClicked ? Colors.deepOrange : Colors.grey,
              size: iconSize,
            );
          },
        ),
        LikeButton(
          likeCount: 999,
          size: iconSize,
        ),
        LikeButton(
          likeCount: 999,
          onTap: (bool val) {
            //TODO: Share库 支持平台问题
            Share.share("This is a test action by Social Project");
            return Future.value(true);
          },
          likeBuilder: (bool isClicked) {
            return Icon(
              FontAwesomeIcons.share,
              color: isClicked ? Colors.blue : Colors.grey,
              size: iconSize,
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    listSourceRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double margin = ScreenUtil.instance.setWidth(22);
    final Widget result = Material(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Expanded(
            child: re.PullToRefreshNotification(
              pullBackOnRefresh: false,
              maxDragOffset: maxDragOffset,
              armedDragUpCancel: false,
              onRefresh: onRefresh,
              child: LoadingMoreCustomScrollView(
                showGlowLeading: true,
                showGlowTrailing: true,
                physics: ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: re.PullToRefreshContainer((info) {
                      return PullToRefreshHeader(info, dateTimeNow);
                    }),
                  ),
                  LoadingMoreSliverList(
                    SliverListConfig<WpPost>(
                      collectGarbage: (List<int> indexes) {
                        ///collectGarbage
                        indexes.forEach((index) {
//                          final item = listSourceRepository[index];
//                          if (item.hasImage) {
//                            item.images.forEach((image) {
//                              image.clearCache();
//                            });
//                          }
                        });
                      },
                      itemBuilder: (context, item, index) {
                        String title = item.title.rendered;
                        if (title == null || title == "") {
                          title = "Image$index";
                        }

                        // 内容文本
                        var content = item.content.rendered;

                        // 修复图片
                        if (_wpSource == WpSource.WeiRan) {
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
                            0, content.length < 1500 ? content.length : 1500);

                        contentSmall += "<h2>......</h2>";

                        var card = ThemeUtil.materialCard(InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, UIData.wpPostDetail,
                                arguments: {
                                  "content": content,
                                  "title": title,
                                });
                          },
                          onLongPress: () {
                            BottomSheetUtil.showPostSheetShow(context, item);
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
                                    WpUserHeader(
                                      userId: item.author,
                                      wpSource: _wpSource,
                                    ),
                                    SizedBox(
                                      width: margin,
                                    ),
                                    // TODO: 超出屏幕宽度
                                    RichText(
                                      maxLines: 1,
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "${item.date}",
                                            style: ThemeUtil.subtitle)
                                      ]),
                                    )
                                  ],
                                ),
                              ),
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
                                              String imageUrl = node
                                                  .attributes["data-original"];
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
                                      child: actionRow(item),
                                    )
//                                          CupertinoButton(
//                                              child: Material(
//                                                color: Colors.transparent,
//                                                child: Ink(
//                                                  decoration: BoxDecoration(
//                                                      gradient: LinearGradient(
//                                                    begin: Alignment.topCenter,
//                                                    end: Alignment.bottomCenter,
//                                                    colors: [
//                                                      Colors.white,
//                                                      Theme.of(context)
//                                                          .backgroundColor,
//                                                    ],
//                                                  )),
//                                                  child: Padding(
//                                                    padding:
//                                                        const EdgeInsets.all(
//                                                            0.0),
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .center,
//                                                      children: <Widget>[
//                                                        Text("Click for more")
//                                                      ],
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
//                                              onPressed: () {}),

//                                          Image.asset(
//                                              'assets/images/linear_mask.png',
//                                              fit: BoxFit.cover,
//                                              package: App.pkg)
                                  ],
                                ),
                                padding: EdgeInsets.only(
                                  left: margin,
                                  right: margin,
                                  bottom: margin,
                                ),
                              ),
                              // 标签
//                                Padding(
//                                  padding:
//                                      EdgeInsets.symmetric(horizontal: margin),
//                                  child: buildTagsWidget(item, context),
//                                ),
                              // 图片区域
//                                PicGridView(
//                                  tuChongItem: item,
//                                ),
                              // 操作按钮区域
//                                Padding(
//                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
//                                  child: buildBottomWidget(item,
//                                      showAvatar: false),
//                                ),
                            ],
                          ),
                        ));

                        if (index == 0) {
                          return Column(
                            children: <Widget>[
                              ThemeUtil.materialCard(Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "🚧 置顶消息 🚧",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Image.asset("assets/images/timeline.jpeg")
                                  ],
                                ),
                              )),
                              card
                            ],
                          );
                        } else {
                          return card;
                        }
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

  void onNewPostReleased() {
    onRefresh();
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
