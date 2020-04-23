import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared/ui/widget/profile_tile.dart';
import 'package:shared/util/theme_util.dart';
import 'package:social_project/misc/wordpress_config_center.dart';
import 'package:social_project/rebuild/view/page/wp_page.dart';
import 'package:social_project/ui/widgets/login_background.dart';
import 'package:social_project/ui/widgets/wp_pic_grid_view.dart';
import 'package:social_project/utils/route/app_route.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:wpmodel/config/cache_center.dart';
import 'package:wpmodel/model/wp_page_data.dart';
import 'package:wpmodel/rep/wp_rep.dart';
import 'package:wpmodel/ui/wp_bottom_sheet.dart';

class GuidePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Widget appBarColumn(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 18.0),
          child: Column(
            children: <Widget>[
              ProfileTile(
                title: "Hi, " +
                    (WpCacheCenter.tokenCache == null
                        ? "User"
                        : WpCacheCenter.tokenCache.userDisplayName),
                subtitle: "欢迎来到 ${UIData.appNameFull}",
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      );

  Widget searchCard(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).textTheme.title.color,
                  ),
                  onPressed: () {
                    showToast("搜索", position: ToastPosition.bottom);
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "查找信息",
                      hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.title.color),
                    ),
                    onSubmitted: (par1) => Navigator.pushNamed(
                        context, UIData.argPostsPage,
                        arguments: {
                          'url': WordPressRep.getWpLink(WordPressRep.wpSource) +
                              "/wp-json/wp/v2/posts?search=${_controller.text}",
                          'appBar': AppBar(
                            title: Text(_controller.text + ' 的搜索结果'),
                            backgroundColor: Theme.of(context).backgroundColor,
                            elevation: 5,
                          )
                        }),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).textTheme.title.color,
                  ),
                  onPressed: () {
                    showToast("搜索菜单", position: ToastPosition.bottom);
                  },
                ),
              ],
            ),
          ),
        ),
      );

//  Widget actionMenuCard() => Padding(
//        padding: const EdgeInsets.symmetric(horizontal: 8.0),
//        child: Card(
//          elevation: 2.0,
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Center(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: <Widget>[
//                  DashboardMenuRow(
//                    firstIcon: FontAwesomeIcons.solidUser,
//                    firstLabel: "Friends",
//                    firstIconCircleColor: Colors.blue,
//                    secondIcon: FontAwesomeIcons.userFriends,
//                    secondLabel: "Groups",
//                    secondIconCircleColor: Colors.orange,
//                    thirdIcon: FontAwesomeIcons.mapMarkerAlt,
//                    thirdLabel: "Nearby",
//                    thirdIconCircleColor: Colors.purple,
//                    fourthIcon: FontAwesomeIcons.locationArrow,
//                    fourthLabel: "Moment",
//                    fourthIconCircleColor: Colors.indigo,
//                  ),
//                  DashboardMenuRow(
//                    firstIcon: FontAwesomeIcons.images,
//                    firstLabel: "Albums",
//                    firstIconCircleColor: Colors.red,
//                    secondIcon: FontAwesomeIcons.solidHeart,
//                    secondLabel: "Likes",
//                    secondIconCircleColor: Colors.teal,
//                    thirdIcon: FontAwesomeIcons.solidNewspaper,
//                    thirdLabel: "Articles",
//                    thirdIconCircleColor: Colors.lime,
//                    fourthIcon: FontAwesomeIcons.solidCommentDots,
//                    fourthLabel: "Reviews",
//                    fourthIconCircleColor: Colors.amber,
//                  ),
//                  DashboardMenuRow(
//                    firstIcon: FontAwesomeIcons.footballBall,
//                    firstLabel: "Sports",
//                    firstIconCircleColor: Colors.cyan,
//                    secondIcon: FontAwesomeIcons.solidStar,
//                    secondLabel: "Fav",
//                    secondIconCircleColor: Colors.redAccent,
//                    thirdIcon: FontAwesomeIcons.blogger,
//                    thirdLabel: "Blogs",
//                    thirdIconCircleColor: Colors.pink,
//                    fourthIcon: FontAwesomeIcons.wallet,
//                    fourthLabel: "Wallet",
//                    fourthIconCircleColor: Colors.brown,
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//      );

//  Widget balanceCard() => Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Card(
//          elevation: 2.0,
//          child: Padding(
//            padding: const EdgeInsets.all(20.0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(
//                      "Balance",
//                      style: TextStyle(fontFamily: UIData.ralewayFont),
//                    ),
//                    Material(
//                      color: Colors.black,
//                      shape: StadiumBorder(),
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text(
//                          "500 Points",
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontFamily: UIData.ralewayFont),
//                        ),
//                      ),
//                    )
//                  ],
//                ),
//                Text(
//                  "₹ 1000",
//                  style: TextStyle(
//                      fontFamily: UIData.ralewayFont,
//                      fontWeight: FontWeight.w700,
//                      color: Colors.green,
//                      fontSize: 25.0),
//                ),
//              ],
//            ),
//          ),
//        ),
//      );

  /// 主体卡片
  static Widget buildCard(final context, final WpPage item) {
    final double margin = ScreenUtil().setWidth(22);
    String title = item.title.rendered;
    if (title == null || title.isEmpty) {
      return Container();
    }

    // 内容文本
    var content = WordPressPageContentState.fixPostData(item.content.rendered);
    var contentSmall = WordPressPageContentState.trimContent(content);

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
//            buildTagsWidget(item, context),
            Html(
              data: contentSmall,
              showImages: false,
            ),
            WpPicGridView(
              item: ImagePack(item.imageUrls),
            ),
//                                Padding(
//                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                                  child: actionRow(item),
//                                ),
          ],
        ),
        item.author,
        item.date,
        margin, context, onCardClicked: () {
      goToWpPostDetail(context, item);
    }, onLongPressed: () {
      WpBottomSheetUtil.showPostSheetShow(context, item);
    });

    return card;
  }

  Widget allCards(BuildContext context) {
    var widgets = <Widget>[];
    widgets.addAll([
      appBarColumn(context),
      searchCard(context),
    ]);
    WordPressConfigCenter.pages.pageList.forEach((pageData) {
      widgets.add(buildCard(context, pageData));
    });
    widgets.add(SizedBox(
      height: ScreenUtil().setHeight(200),
    ));
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: widgets,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          LoginBackground(
            showIcon: false,
          ),
          allCards(context),
        ],
      ),
    );
  }
}
