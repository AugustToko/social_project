import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:share/share.dart';
import 'package:social_project/model/menu.dart';
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/ui/widgets/profile_tile.dart';
import 'package:social_project/ui/widgets/wp/user_header.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ui/widgets/about_tile.dart';

class BottomSheetUtil {

  /// 显示于 BottomSheet 顶部
  static Widget header(final WpUser user) {
    var tempUser = user;
    if (tempUser == null) tempUser = WpUser.defaultUser;
    return Ink(
      decoration:
          BoxDecoration(gradient: LinearGradient(colors: UIData.kitGradients2)),
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

  static void showSheetBottom(final BuildContext context, final WpUser wpUser,
      final Menu menu, final Function(int num, Menu menu) func) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Material(
//            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).backgroundColor,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.only(
//                    topLeft: Radius.circular(15.0),
//                    topRight: Radius.circular(15.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                BottomSheetUtil.header(wpUser),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: menu.items.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListTile(
                          title: Text(
                            menu.items[i],
                          ),
                          onTap: () {
                            func(i, menu);
                          }),
                    ),
                  ),
                ),
                MyAboutTile()
              ],
            )));
  }

  /// 显示来自 POST CARD 被长按下的 bottomSheet
  static void showPostSheetShow(final BuildContext context, final WpPost item) {
    showSheetBottom(
        context,
        CacheCenter.getUser(item.author),
        Menu(title: "Title", items: [
          "打开原网站",
          "分享",
          "收藏",
          "隐藏",
        ]), (i, menu) {
      switch (i) {
        case 0:
          {
            launch(item.link);
          }
          break;
        case 1:
          Share.share(item.title.rendered + ":" + " \r\n" + item.link);
          break;
      }
    });
  }
}

class SheetHeaderData {}
