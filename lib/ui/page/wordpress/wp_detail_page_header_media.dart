import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:html/dom.dart' as dom;
import 'package:shared/model/wordpress/wp_post_source.dart';
import 'package:shared/util/log.dart';
import 'package:shared/util/theme_util.dart';
import 'package:shared/util/tost.dart';
import 'package:social_project/rebuild/view/page/login_page.dart';
import 'package:social_project/rebuild/view/page/profile_coolapk.dart';
import 'package:social_project/ui/page/pic_swiper.dart';
import 'package:social_project/ui/widgets/user_header.dart';
import 'package:social_project/utils/dialog/alert_dialog_util.dart';
import 'package:video_player/video_player.dart';

import '../content_page.dart';

/// 用于显示 WordPress 文章
class WpDetailPageHeaderMedia extends StatefulWidget {
  WpDetailPageHeaderMedia(this.content);

  final WpPost content;

  @override
  _WpPostsPageState createState() {
    return _WpPostsPageState();
  }
}

class _WpPostsPageState extends State<WpDetailPageHeaderMedia> {
  final List<ChangeNotifier> needDispose = [];

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
                            looping: true,
                            allowFullScreen: true,
                            isLive: false,
                            allowMuting: true,
                          );

                          needDispose.add(videoPlayerController);
                          needDispose.add(chewieController);

                          final playerWidget = Chewie(
                            controller: chewieController,
                          );

                          return playerWidget;
                        case "img":
                          print("----------------------------------");
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
    var needHeaderMedia = widget.content.jetpackFeaturedMediaUrl != null &&
        widget.content.jetpackFeaturedMediaUrl != '';
    return <Widget>[
      SliverAppBar(
        title: Text(widget.content.title.rendered),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        expandedHeight: needHeaderMedia ? 200.0 : 0,
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
        flexibleSpace: needHeaderMedia
            ? FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    ExtendedImage.network(
                      widget.content.jetpackFeaturedMediaUrl,
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

  @override
  void dispose() {
    needDispose.forEach((item) {
      item?.dispose();
    });
    super.dispose();
  }
}
