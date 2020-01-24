import 'package:flutter/widgets.dart';
import 'package:social_project/ui/page/pic_swiper.dart';
import 'package:social_project/ui/page/comment_deatil_page.dart';
import 'package:social_project/ui/page/gooey_edge_page.dart';
import 'package:social_project/ui/page/main_page.dart';
import 'package:social_project/rebuild/view/page/login_page.dart';
import 'package:social_project/rebuild/view/page/profile_coolapk.dart';
import 'package:social_project/ui/page/wordpress/editor.dart';
import 'package:social_project/ui/page/wordpress/draft_box_page.dart';
import 'package:social_project/ui/page/wordpress/u_posts_page.dart';
import 'package:social_project/ui/page/settings_page.dart';
import 'package:social_project/ui/page/timeline_page.dart';
import 'package:social_project/ui/page/wordpress/wp_detail_page.dart';

import '../uidata.dart';

enum NavState {
  LoginDone,

  /// 发表 wordPress 文章成功
  SendWpPostDone
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
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.homeRoute:
      return RouteResult(
        widget: MainPage(),
        showStatusBar: false,
        routeName: UIData.homeRoute,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.gooeyEdge:
      return RouteResult(
        widget: GooeyEdgePage(),
        showStatusBar: false,
        routeName: UIData.gooeyEdge,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.timeLine:
      return RouteResult(
        widget: TimelineTwoPage(),
        showStatusBar: false,
        routeName: UIData.timeLine,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.profile:
      return RouteResult(
//        widget: ProfilePage(arguments["wpUserId"]),
        widget: ProfileCoolApkPage(arguments["wpUserId"]),
        showStatusBar: false,
        routeName: UIData.profile,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.commentDetail:
      return RouteResult(
        widget: CommentPage(),
        showStatusBar: false,
        routeName: UIData.commentDetail,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.wpPostDetail:
      return RouteResult(
        widget: WpDetailPage(
          arguments['title'],
          arguments['content'],
        ),
        showStatusBar: false,
        routeName: UIData.wpPostDetail,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.argPostsPage:
      return RouteResult(
        widget: PostsPage(
          arguments['url'],
          arguments['appBar'],
        ),
        showStatusBar: false,
        routeName: UIData.argPostsPage,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.loginPage:
      return RouteResult(
        widget: LoginPage("Login Page"),
        showStatusBar: false,
        routeName: UIData.loginPage,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.sendPage:
      return RouteResult(
        //TODO：编辑页面待完善
        widget: EditorPage(),
//        widget: SendPage(),
        showStatusBar: true,
        routeName: UIData.sendPage,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.settingsPage:
      return RouteResult(
        widget: SettingsOnePage(),
        showStatusBar: true,
        routeName: UIData.settingsPage,
        pageRouteType: PageRouteType.transparent,
      );
      break;
    case UIData.draftBoxPage:
      return RouteResult(
        widget: DraftBoxPage(),
        showStatusBar: true,
        routeName: UIData.draftBoxPage,
        pageRouteType: PageRouteType.transparent,
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

  /// The type of page route
  final PageRouteType pageRouteType;

  /// The description of route
  final String description;

  const RouteResult(
      {this.widget,
      this.showStatusBar = true,
      this.routeName = '',
      this.pageRouteType,
      this.description = ''});
}

enum PageRouteType { material, cupertino, transparent }
