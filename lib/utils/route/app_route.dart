import 'package:flutter/widgets.dart';
import 'package:shared/ui/page/about_app.dart';
import 'package:shared/ui/page/settings_page.dart';
import 'package:shared/ui/page/web_page.dart';
import 'package:social_project/rebuild/view/page/login_page.dart';
import 'package:social_project/rebuild/view/page/profile_coolapk_page.dart';
import 'package:social_project/ui/page/comment_deatil_page.dart';
import 'package:social_project/ui/page/gooey_edge_page.dart';
import 'package:social_project/ui/page/mainpages/main_page.dart';
import 'package:social_project/ui/page/mainpages/subpages/timeline_page.dart';
import 'package:social_project/ui/page/pic_swiper.dart';
import 'package:social_project/ui/page/wordpress/draft_box_page.dart';
import 'package:social_project/ui/page/wordpress/u_posts_page.dart';
import 'package:social_project/ui/page/wordpress/wp_detail_page_header_media.dart';

import '../uidata.dart';

void goToWpPostDetail(final BuildContext context, final data) {
  Navigator.pushNamed(context, UIData.wpPostDetail, arguments: {
    "postItem": data,
  });
}

RouteResult getRouteResult({String name, Map<String, dynamic> arguments}) {
  switch (name) {
    case "fluttercandies://picswiper":
      return RouteResult(
        widget: PicSwiper(
          index: arguments['index'],
          pics: arguments['pics'],
        ),
        showStatusBar: false,
        routeName: "PicSwiper",
      );
      break;
    case UIData.homeRoute:
      return RouteResult(
        widget: MainPage(),
        showStatusBar: false,
        routeName: UIData.homeRoute,
      );
      break;
    case UIData.gooeyEdge:
      return RouteResult(
        widget: GooeyEdgePage(),
        showStatusBar: false,
        routeName: UIData.gooeyEdge,
      );
      break;
    case UIData.timeLine:
      return RouteResult(
        widget: TimelineTwoPage(),
        showStatusBar: false,
        routeName: UIData.timeLine,
      );
      break;
    case ProfileCoolApkPage.profile:
      return RouteResult(
        widget: ProfileCoolApkPage(arguments["wpUserId"]),
        showStatusBar: false,
        routeName: ProfileCoolApkPage.profile,
      );
      break;
    case UIData.commentDetail:
      return RouteResult(
        widget: CommentPage(),
        showStatusBar: false,
        routeName: UIData.commentDetail,
      );
      break;
    case UIData.wpPostDetail:
      return RouteResult(
//        widget: WpDetailPage(
//          arguments['postItem'],
//        ),
        widget: WpDetailPageHeaderMedia(
          arguments['postItem'],
        ),
        showStatusBar: false,
        routeName: UIData.wpPostDetail,
      );
      break;
    case PostsPage.argPostsPage:
      return RouteResult(
        widget: PostsPage(
          arguments['url'],
          arguments['appBar'],
        ),
        showStatusBar: false,
        routeName: PostsPage.argPostsPage,
      );
      break;
    case LoginPage.loginPage:
      return RouteResult(
        widget: LoginPage(),
        showStatusBar: false,
        routeName: LoginPage.loginPage,
      );
      break;
    case UIData.sendPage:
      return RouteResult(
        //TODO：编辑页面待完善
//        widget: EditorPage(editorData: arguments == null ? null : arguments["editorData"],),
        widget: Container(),
        showStatusBar: true,
        routeName: UIData.sendPage,
      );
      break;
    case UIData.settingsPage:
      return RouteResult(
        widget: SettingsOnePage(),
        showStatusBar: true,
        routeName: UIData.settingsPage,
      );
      break;
    case UIData.draftBoxPage:
      return RouteResult(
        widget: DraftBoxPage(),
        showStatusBar: true,
        routeName: UIData.draftBoxPage,
      );
      break;
    case AboutPage.routeName:
      return RouteResult(
        widget: AboutPage(),
        showStatusBar: true,
        routeName: AboutPage.routeName,
      );
      break;
    case WebPage.routeName:
      return RouteResult(
        widget: WebPage(
          title: arguments["title"],
          url: arguments["url"],
        ),
        showStatusBar: true,
        routeName: UIData.webPage,
      );
      break;
//    case "fluttercandies://customimage":
//      return RouteResult(
//        widget: CustomImageDemo(),
//        routeName: "custom image load state",
//        description: "show image with loading,failed,animation state",
//      );
//    case "fluttercandies://image":
//      return RouteResult(
//        widget: ImageDemo(),
//        routeName: "image",
//        description:
//            "cache image,save to photo Library,image border,shape,borderRadius",
//      );
//    case "fluttercandies://imageeditor":
//      return RouteResult(
//        widget: ImageEditorDemo(),
//        routeName: "image editor",
//        description: "crop,rotate and flip with image editor",
//      );
//    case "fluttercandies://mainpage":
//      return RouteResult(
//        widget: MainPage(),
//        routeName: "MainPage",
//      );
//    case "fluttercandies://paintimage":
//      return RouteResult(
//        widget: PaintImageDemo(),
//        routeName: "paint image",
//        description:
//            "show how to paint any thing before/after image is painted",
//      );
//    case "fluttercandies://photoview":
//      return RouteResult(
//        widget: PhotoViewDemo(),
//        routeName: "photo view",
//        description: "show how to zoom/pan image in page view like WeChat",
//      );
//    case "fluttercandies://WaterfallFlowDemo":
//      return RouteResult(
//        widget: WaterfallFlowDemo(),
//        routeName: "WaterfallFlow",
//        description:
//            "show how to build loading more WaterfallFlow with ExtendedImage.",
//      );
//    case "fluttercandies://zoomimage":
//      return RouteResult(
//        widget: ZoomImageDemo(),
//        routeName: "image zoom",
//        description: "show how to zoom/pan image",
//      );
    default:
      return RouteResult();
  }
}

class RouteResult {
  /// The Widget return base on route
  final Widget widget;

  /// Whether show this route with status bar.
  final bool showStatusBar;

  /// The route name to track page
  final String routeName;

  /// The description of route
  final String description;

  const RouteResult(
      {this.widget,
      this.showStatusBar = true,
      this.routeName = '',
      this.description = ''});
}
