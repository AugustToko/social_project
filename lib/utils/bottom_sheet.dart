import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:share/share.dart';
import 'package:social_project/model/menu.dart';
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/ui/widgets/profile_tile.dart';
import 'package:social_project/ui/widgets/wp/user_header.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';

import '../ui/widgets/about_tile.dart';

class BottomSheetUtil {

  static const double opacityVal = 0.85;

  /// 显示于 BottomSheet 顶部
  static Widget _header(final WpUser user) {
    var tempUser = user;
    if (tempUser == null) tempUser = WpUser.defaultUser;
    return Ink(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.cyan.shade600.withOpacity(opacityVal),
        Colors.blue.shade900.withOpacity(opacityVal)
      ])),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//              CircleAvatar(
//                radius: 25.0,
//                backgroundImage: NetworkImage(user.avatarUrls.s96),
//              ),
            WpUserHeader(
              wpSource: WordPressRep.wpSource,
              showUserName: false,
              userId: tempUser.id,
              radius: 25.0,
              canClick: true,
            ),
            SizedBox(
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfileTile(
                title: tempUser.name,
                subtitle: tempUser.name,
                textColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  static void showSheetBottom(
      final BuildContext context, final WpUser wpUser, final Menu menu) {
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        builder: (context) => Stack(
              children: <Widget>[
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .backgroundColor
                              .withOpacity(opacityVal)),
                    ),
                  ),
                ),
                Material(
//            clipBehavior: Clip.antiAlias,
                    color: Colors.transparent,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.only(
//                    topLeft: Radius.circular(15.0),
//                    topRight: Radius.circular(15.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        BottomSheetUtil._header(wpUser),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: false,
                            itemCount: menu.items.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: menu.items[i],
                              );
                            },
                          ),
                        ),
                        MyAboutTile()
                      ],
                    ))
              ],
            ));
  }

  /// 显示来自 POST CARD 被长按下的 bottomSheet
  static void showPostSheetShow(final BuildContext context, final WpPost item) {
    var textStyle = TextStyle(color: Colors.white);
    showSheetBottom(
        context,
        CacheCenter.getUser(item.author),
        Menu(title: "Title", items: [
          ListTile(
            title: Text(
              "打开原网站",
            ),
            leading: Icon(
              Icons.link,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              FlutterWebBrowser.openWebPage(url: item.link);
            },
          ),
          ListTile(
            title: Text("分享"),
            leading: Icon(
              Icons.share,
              color: Theme.of(context).iconTheme.color,
            ),
            onTap: () {
              Share.share(item.title.rendered + ":" + " \r\n" + item.link);
            },
          ),
          ListTile(
            title: Text("收藏"),
            leading: Icon(
              Icons.star,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          ListTile(
            title: Text("隐藏"),
            leading: Icon(
              Icons.restore_from_trash,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
        ]));
  }
}

class SheetHeaderData {}
