import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/model/wordpress/wp_post_source.dart';
import 'package:shared/util/theme_util.dart';
import 'package:social_project/ui/page/pic_swiper.dart';
import 'crop_image2.dart';

const int maxPicGridViewCount = 9;

class ImagePack {
  List<String> imageUrls;

  ImagePack(this.imageUrls);
}

/// Grid view to show picture
class WpPicGridView extends StatelessWidget {
  final ImagePack item;

  WpPicGridView({
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = LayoutBuilder(builder: (ctx, b) {
      final double margin = ScreenUtil().setWidth(22);
      var size = b.maxWidth;
      int rowCount = 3;
      //single image
      if (item.imageUrls.length == 1) {
        var widgetA = GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(margin),
            child: ClipRRect(
              borderRadius: ThemeUtil.clipRRectBorderRadius,
              child: ExtendedImage.network(item.imageUrls[0]),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, "fluttercandies://picswiper",
                arguments: {
                  "index": 0,
                  "pics": item.imageUrls
                      .map<PicSwiperItem>((f) => PicSwiperItem(f, des: f))
                      .toList(),
                });
          },
        );
        return widgetA;
      }

      var totalWidth = size;
      if (item.imageUrls.length == 4) {
        totalWidth = size / 3 * 2;
        rowCount = 2;
      }

      return Container(
        margin: EdgeInsets.all(margin),
        width: totalWidth,
        child: ClipRRect(
          borderRadius: ThemeUtil.clipRRectBorderRadius,
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: rowCount,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0),
            itemBuilder: (s, index) {
              return WpCropImage(
                index: index,
                postItem: item,
              );
            },
            physics: NeverScrollableScrollPhysics(),
            itemCount: item.imageUrls.length.clamp(1, maxPicGridViewCount),
          ),
        ),
      );
    });
    // if (margin != null) {
    //   widget = Padding(
    //     padding: margin,
    //     child: widget,
    //   );
    // }
    widget = Align(
      child: widget,
      alignment: Alignment.centerLeft,
    );
    return widget;
  }
}

class ImageTempPack {
  List<String> images = [];

  ImageTempPack(this.images);
}
