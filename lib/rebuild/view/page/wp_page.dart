import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart'
    as re;
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/rebuild/viewmodel/wordpress_page_provider.dart';
import 'package:social_project/ui/widgets/push_to_refresh_header.dart';
import 'package:social_project/utils/screen_util.dart';
import 'package:social_project/utils/theme_util.dart';

import '../base.dart';

/// TODO: 写完文章后自动刷新
class WordPressPage extends PageProvideNode<WordPressPageProvider> {
  @override
  Widget buildContent(BuildContext context) {
    return _WordPressPageContent(mProvider);
  }

  void onNewPostReleased() {
    mProvider.onRefresh();
  }
}

/// 获取 WordPress Posts
class _WordPressPageContent extends StatefulWidget {
  final WordPressPageProvider provider;

  _WordPressPageContent(this.provider);

  @override
  _WordPressPageContentState createState() {
    return _WordPressPageContentState();
  }
}

class _WordPressPageContentState extends State<_WordPressPageContent>
    implements Presenter {
  WordPressPageProvider mProvider;

  static const String ACTION_CARD_CLICKED = "ACTION_CARD_CLICKED";
  static const String ACTION_CARD_LONG_PRESSED = "ACTION_CARD_LONG_PRESSED";

  @override
  void initState() {
    super.initState();
    mProvider = widget.provider;
    mProvider.init(context);
  }

  Widget actionRow(final WpPost post) {
    const double iconSize = 18.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        LikeButton(
          likeCount: 999,
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
          onTap: (bool isLiked) {
            mProvider.share(post);
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
    mProvider.listSourceRepository.dispose();
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
              onRefresh: () => mProvider.onRefresh(),
              child: LoadingMoreCustomScrollView(
                showGlowLeading: true,
                showGlowTrailing: true,
                physics: ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: re.PullToRefreshContainer((info) {
                      return PullToRefreshHeader(info, mProvider.dateTimeNow);
                    }),
                  ),
                  LoadingMoreSliverList(
                    SliverListConfig<WpPost>(
                      indicatorBuilder: (p, q) {
                        return mProvider.listSourceRepository.length > 0
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  10,
                                  0,
                                  ThemeUtil.navBarHeight +
                                      ScreenUtil.getInstance().setWidth(20),
                                ),
                                child: Text(
                                  "—————— 做人也是要有底线的哦 ——————",
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : null;
                      },
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
                        var content =
                            mProvider.fixPostData(item.content.rendered);

                        var contentSmall = mProvider.trimContent(content);

                        var card = ThemeUtil.materialPostCard(
                            InkWell(
                              onTap: () {
                                mProvider.cardClicked(context, content, title);
                              },
                              onLongPress: () {
                                mProvider.cardLongPressed(context, item);
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
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: actionRow(item),
                                        ),
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
                            ),
                            item,
                            margin);

                        if (index == 0) {
                          return Column(
                            children: <Widget>[buildBannerSwipe(), card],
                          );
                        } else {
                          return card;
                        }
                      },
                      sourceList: mProvider.listSourceRepository,
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

  Widget buildBannerSwipe() {
    return BannerSwiper(
      showIndicator: true,
      //width  和 height 是图片的高宽比  不用传具体的高宽   必传
      height: 100,
      width: 48,
      //轮播图数目 必传
      length: mProvider.banners.length,

      //轮播的item  widget 必传
      getwidget: (index) {
        var bannerData = mProvider.banners[index % mProvider.banners.length];
        return GestureDetector(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Material(
              elevation: 1.5,
              borderRadius: ThemeUtil.clipRRectBorderRadius,
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: ThemeUtil.clipRRectBorderRadius,
                child: Stack(
                  children: <Widget>[
//                                        Image.network(
//                                          "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1579963291831&di=6fdb4ea45d31a968fd7025721ddb9380&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2F4%2F586b0784596f9.jpg%3Fdown",
//                                          width: 400,
//                                          fit: BoxFit.cover,
//                                        ),
                    Image.network(
//                                          "assets/images${bannerData.assetUrl}",
                      bannerData.assetUrl,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.4),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            bannerData.title,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            bannerData.subTitle,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            bannerData.messageText,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                    width: 1.5, color: Colors.white)),
                            onPressed: () {},
                            child: Text(
                              "了解更多",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onNewPostReleased() {
    mProvider.onRefresh();
  }

  @override
  void onClick(String action) {
  }
}
