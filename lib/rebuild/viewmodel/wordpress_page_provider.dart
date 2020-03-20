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

  set banners(List<LingYunBanner> data) {
    _banners.clear();
    _banners.addAll(data);
//    notifyListeners();
  }

  WordPressRep listSourceRepository =
      WordPressRep(WordPressRep.getWpLink(WordPressRep.wpSource));

  bool knowImageSize = true;
  DateTime dateTimeNow = DateTime.now();

  @override
  void init(BuildContext context) {
    NetTools.getLingYunBanner().then((data) {
      if (data == null) {
        banners = [];
      } else {
        banners = data;
      }
    });
  }

  void share(final WpPost post) {
    Share.share("This is a test action by LingYun");
  }

  Future<bool> onRefresh() {
    return listSourceRepository.refresh().whenComplete(() {
      dateTimeNow = DateTime.now();
    });
  }

  void onBannerPressed(final LingYunBanner banner) {
    var temp = banner.onTapAction.split(';');
    if (temp.length < 2) return;

    switch (temp[0]) {
      case "openUrl":
        FlutterWebBrowser.openWebPage(url: temp[1]);
        break;
    }
  }
}
