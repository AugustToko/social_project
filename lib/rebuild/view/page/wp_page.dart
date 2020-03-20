import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart'
    as re;
import 'package:shared/model/wordpress/wp_post_source.dart';
import 'package:shared/model/wordpress/wp_category.dart';
import 'package:shared/mvvm/view/base.dart';
import 'package:shared/ui/widget/loading_more_list_widget/list_config.dart';
import 'package:shared/ui/widget/loading_more_list_widget/loading_more_sliver_list.dart';
import 'package:shared/ui/widget/push_to_refresh_header.dart';
import 'package:shared/util/bottom_sheet.dart';
import 'package:shared/util/theme_util.dart';
import 'package:social_project/misc/wordpress_config_center.dart';
import 'package:social_project/rebuild/viewmodel/wordpress_page_provider.dart';
import 'package:social_project/ui/widgets/wp_pic_grid_view.dart';
import 'package:social_project/utils/route/app_route.dart';

/// TODO: 写完文章后自动刷新
class WordPressPage extends PageProvideNode<WordPressPageProvider> {
  @override
  Widget buildContent(BuildContext context) {
    return _WordPressPageContent(mProvider);
  }
}

/// 获取 WordPress Posts
class _WordPressPageContent extends StatefulWidget {
  final WordPressPageProvider provider;

  _WordPressPageContent(this.provider);

  @override
  WordPressPageContentState createState() {
    return WordPressPageContentState();
  }
}

class WordPressPageContentState extends State<_WordPressPageContent>
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

  @override
  void dispose() {
    mProvider.listSourceRepository.dispose();
    super.dispose();
  }

  static Widget buildIndicator(int len) {
    return len > 0
        ? Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              10,
              0,
              ThemeUtil.navBarHeight + ScreenUtil().setWidth(20),
            ),
            child: Text(
              "—————— 做人也是要有底线的哦 ——————",
              textAlign: TextAlign.center,
            ),
          )
        : null;
  }

  static String trimContent(final String content) {
    // 裁剪内容
    // TODO: 裁剪规范，如何使 card 大小适中
    var contentSmall =
        content.substring(0, content.length < 1500 ? content.length : 1500);

    contentSmall += "<h2>......</h2>";

    return contentSmall;
  }

  static String fixPostData(final String data) {
    var content = data;

    content = content.replaceAll("[java]", "<code>");
    content = content.replaceAll("[/java]", "</code>");

    content = content.replaceAll("[xml]", "<code>");
    content = content.replaceAll("[/xml]", "</code>");

    return content;
  }

  /// 主体卡片
  static Widget buildCard(final context, final item, final index) {
    final double margin = ScreenUtil().setWidth(22);
    String title = item.title.rendered;
    if (title == null || title == "") {
      return Container();
    }

    // 内容文本
    var content = fixPostData(item.content.rendered);
    var contentSmall = trimContent(content);

    var card = ThemeUtil.materialPostCard(
        Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            buildTagsWidget(item, context),
            Html(
              data: contentSmall,
              showImages: false,
            ),
            WpPicGridView(
              item: item,
            ),
//                                Padding(
//                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                                  child: actionRow(item),
//                                ),
          ],
        ),
        item,
        margin, onCardClicked: () {
      goToWpPostDetail(context, item);
    }, onLongPressed: () {
      BottomSheetUtil.showPostSheetShow(context, item);
    });

    return card;
  }

  @override
  Widget build(BuildContext context) {
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
                  LyLoadingMoreSliverList(
                    LySliverListConfig<WpPost>(
                      indicatorBuilder: (p, q) {
                        return buildIndicator(
                            mProvider.listSourceRepository.length);
                      },
                      collectGarbage: (List<int> indexes) {},
                      itemBuilder: (ctx, item, index) {
                        var card = buildCard(ctx, item, index);
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

  /// 标签
  static Widget buildTagsWidget(final WpPost item, final BuildContext context) {
    final fontSize = 12.0;
    final tags = <WpCategory>[];
    var spacing = ScreenUtil().setWidth(10.0);

    WordPressConfigCenter.wpCategories.list.forEach((val) {
      if (item.categories.contains(val.id)) {
        tags.add(val);
      }
    });

    Widget wpTag(String name) {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              border:
                  Border.all(color: Colors.grey.withOpacity(0.4), width: 1.0),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: 标签按下
                },
              ),
            ),
          ),
        ],
      );
    }

    var tagWidgets = <Widget>[];
    tags.forEach((t) {
      tagWidgets.add(wpTag(t.name));
    });

    return Wrap(
      runSpacing: spacing,
      spacing: spacing,
      children: tagWidgets,
    );
  }

  Widget actionRow(final WpPost post) {
    const double iconSize = 18.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        LikeButton(
          likeCount: 999,
          likeBuilder: (isClicked) {
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
          onTap: () {
            mProvider.onBannerPressed(bannerData);
          },
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
                    Image.network(
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
                            onPressed: () {
                              mProvider.onBannerPressed(bannerData);
                            },
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
  void onClick(String action) {}
}
