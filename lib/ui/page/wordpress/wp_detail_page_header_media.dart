import 'package:audioplayerui/audioplayerui.dart';
import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:html/dom.dart' as dom;
import 'package:shared/model/wordpress/wp_page_data.dart';
import 'package:shared/model/wordpress/wp_post_source.dart';
import 'package:shared/util/tost.dart';
import 'package:social_project/rebuild/view/page/login_page.dart';
import 'package:social_project/rebuild/view/page/profile_coolapk.dart';
import 'package:social_project/ui/widgets/user_header.dart';
import 'package:video_player/video_player.dart';

import '../mainpages/subpages/content_page.dart';

/// 用于显示 WordPress 文章
class WpDetailPageHeaderMedia extends StatefulWidget {
  // WpPost
  // WpPage
  final content;

  WpDetailPageHeaderMedia(this.content);

  @override
  _WpPostsPageState createState() {
    return _WpPostsPageState();
  }
}

class _WpPostsPageState extends State<WpDetailPageHeaderMedia> {
  final List<ChangeNotifier> needDispose = [];

  AudioPlayerController audioPlayerController;

  @override
  void dispose() {
    needDispose.forEach((item) {
      item?.dispose();
    });
    if (audioPlayerController != null)
      audioPlayerController.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var padding = ScreenUtil().setWidth(30);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: _sliverBuilder,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    WpUserHeader(
                        clickable: true,
                        needLogin: false,
                        showUserName: true,
                        userId: widget.content.author,
                        loginRouteName: LoginPage.loginPage,
                        profileRouteName: ProfileCoolApkPage.profile),
                    SizedBox(
                      width: ScreenUtil().setWidth(30),
                    ),
                    Text(
                      widget.content.date,
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
//              Text(widget.content.title.rendered, style: Theme.of(context).textTheme.title,)
                Html(
                  data: widget.content.content.rendered,
                  onLinkTap: (url) {
                    FlutterWebBrowser.openWebPage(url: url);
                  },
                  useRichText: false,
                  customRender: (node, children) {
                    if (node is dom.Element) {
                      switch (node.localName) {
                        // 处理 <video>
                        case "video":
                          final videoPlayerController =
                              VideoPlayerController.network(
                            node.attributes["src"],
                          );

                          final chewieController = ChewieController(
                            videoPlayerController: videoPlayerController,
                            aspectRatio: 3 / 2,
                            autoPlay: true,
                            looping: false,
                            allowFullScreen: true,
                            isLive: false,
                            allowMuting: true,
                            allowedScreenSleep: false,
                            autoInitialize: true,
                          );

                          needDispose.add(videoPlayerController);
                          needDispose.add(chewieController);

                          final playerWidget = Chewie(
                            controller: chewieController,
                          );

                          return playerWidget;
                        case "img":
                          String imageUrl = node.attributes["data-original"];
                          return imageUrl == null
                              ? null
                              : ExtendedImage.network(
                                  imageUrl,
                                  cache: true,
                                  clearMemoryCacheIfFailed: true,
                                  filterQuality: FilterQuality.low,
                                  enableMemoryCache: true,
                                  loadStateChanged: (state) {
                                    if (state.extendedImageLoadState ==
                                        LoadState.failed) {
                                      showErrorToast(context, "图片加载失败!");
                                      return Text("加载失败");
                                    }
                                    return null;
                                  },
                                  onDoubleTap: (state) {
                                    showErrorToast(context, "正在建设...");
                                  },
                                );
                        case "audio":
                          audioPlayerController = AudioPlayerController();
                          debugPrint(
                              "-------------- case audio ------------------");
                          var title = "-";
                          if (node.parent.localName == "figure") {
                            var e = node.nextElementSibling;
                            if (e != null && e.localName == "figcaption") {
                              title = e.text;
                            }
                          }
                          debugPrint(node.nextElementSibling.text);
                          var src = node.attributes["src"];
                          return AudioPlayerView(
                              audioPlayerController: audioPlayerController,
                              trackUrl: src,
                              isLocal: false,
                              trackTitle: title,
//                              trackSubtitle: "--",
                              simpleDesign: true,
//                              imageUrl: src.replaceAll('.mp3', '-mp3') + "-image.jpg"
                          );
                        default:
                          return null;
                      }
                    } else {
                      return null;
                    }
                  },
                  showImages: true,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _sliverBuilder(
      final BuildContext context, final bool innerBoxIsScrolled) {
    String mediaUrl;

    if (widget.content is WpPost &&
        widget.content.jetpackFeaturedMediaUrl != null &&
        widget.content.jetpackFeaturedMediaUrl != '') {
      mediaUrl = widget.content.jetpackFeaturedMediaUrl;
    }

    if (widget.content is WpPage) {
      WpPage page = widget.content;
      if (page.imageUrls.length > 0) {
        mediaUrl = page.imageUrls[0];
      }
    }

    return <Widget>[
      SliverAppBar(
        title: Text(widget.content.title.rendered),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        expandedHeight: mediaUrl != null ? 200.0 : 0,
        pinned: true,
        brightness: Brightness.dark,
        // TODO: WpPageDetail Menu 功能
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showErrorToast(context, "正在完善...");
              }),
          PopupMenuButton<Choice>(
            onSelected: (val) => val.onTap(),
            itemBuilder: (BuildContext context) {
              return <Choice>[
                Choice(
                    icon: null,
                    onTap: () {
                      showErrorToast(context, "正在完善...");
                    },
                    title: "收藏"),
                Choice(
                    icon: null,
                    onTap: () {
                      showErrorToast(context, "正在完善...");
                    },
                    title: "复制"),
                Choice(icon: null, onTap: () {}, title: "举报"),
              ].map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Text(choice.title),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
        flexibleSpace: mediaUrl != null
            ? FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    ExtendedImage.network(
                      mediaUrl,
                      width: double.infinity,
                      height: double.infinity,
                      cache: true,
                      clearMemoryCacheIfFailed: true,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).backgroundColor.withOpacity(0.8),
                            Theme.of(context).backgroundColor.withOpacity(0),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : null,
      )
    ];
  }
}
