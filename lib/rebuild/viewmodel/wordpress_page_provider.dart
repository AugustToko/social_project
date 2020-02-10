import 'package:flutter/cupertino.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:share/share.dart';
import 'package:shared/model/lingyun/banner_model.dart';
import 'package:shared/model/wordpress/wp_post_source.dart';
import 'package:shared/mvvm/view/base.dart';
import 'package:shared/rep/wp_rep.dart';
import 'package:shared/util/bottom_sheet.dart';
import 'package:shared/util/net_util.dart';

class WordPressPageProvider extends BaseProvide {
  List<LingYunBanner> _banners = [];
  List<LingYunBanner> get banners => _banners;
  set banners(List<LingYunBanner> data){
    _banners.clear();
    _banners.addAll(data);
//    notifyListeners();
  }

  WordPressRep listSourceRepository =
      WordPressRep(WordPressRep.getWpLink(WordPressRep.wpSource));

  // if you can't know image size before build,
  // you have to handle copy when image is loaded.
  bool knowImageSize = true;
  DateTime dateTimeNow = DateTime.now();

  @override
  void init(BuildContext context) {
    NetTools.getLingYunBanner().then((data) {
      banners = data;
    });
  }

  void share(final WpPost post) {
    Share.share("This is a test action by LingYun");
  }

  String fixPostData(final String data) {
    var content = data;

    // 修复图片
    if (WordPressRep.wpSource == WpSource.WeiRan) {
      content = content.replaceAll(
          "weiran-1254802562.file.myqcloud.com/static/weiran_index/wp-content/uploads/",
          "static.weiran.org.cn/img/");
    }

    content = content.replaceAll("[java]", "<code>");
    content = content.replaceAll("[/java]", "</code>");

    content = content.replaceAll("[xml]", "<code>");
    content = content.replaceAll("[/xml]", "</code>");

    return content;
  }

  String trimContent(final String content) {
    // 裁剪内容
    // TODO: 裁剪规范，如何使 card 大小适中
    var contentSmall =
        content.substring(0, content.length < 1500 ? content.length : 1500);

    contentSmall += "<h2>......</h2>";

    return contentSmall;
  }

  void cardLongPressed(final BuildContext context, final WpPost item) {
    BottomSheetUtil.showPostSheetShow(context, item);
  }

  Future<bool> onRefresh() {
    return listSourceRepository.refresh().whenComplete(() {
      dateTimeNow = DateTime.now();
    });
  }

  void onBannerPressed(final LingYunBanner banner) {
     var temp = banner.onTapAction.split(';');
     if (temp.length < 2) return;

     print("-------------------- action ===-------------");
     print(temp[0]);
     print(temp[1]);

     switch (temp[0]) {
       case "openUrl":
         FlutterWebBrowser.openWebPage(url: temp[1]);
         break;
     }
  }
}
