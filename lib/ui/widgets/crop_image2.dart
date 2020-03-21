import 'dart:math';
import 'dart:ui' as ui show Image;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/tuchong/tu_chong_source.dart';
import 'package:social_project/ui/page/pic_swiper.dart';
import 'package:social_project/ui/widgets/wp_pic_grid_view.dart';

///
///  crop_image.dart
///  create by zmtzawqlp on 2019/4/4
///
class WpCropImage extends StatelessWidget {
  final ImagePack postItem;
  final int index;

  WpCropImage({
    @required this.index,
    @required this.postItem,
  });

  @override
  Widget build(BuildContext context) {
    if (postItem.imageUrls.length == 0) return Container();

    final double num300 = ScreenUtil().setWidth(300);
    final double num400 = ScreenUtil().setWidth(400);
    double height = num300;
    double width = num400;
    final imageItem = postItem.imageUrls[index];

    return ExtendedImage.network(
        //if you don't want to resize image to reduce the memory
        //use ExtendedImage.network(imageItem.imageUrl)
      imageItem,
        fit: BoxFit.cover,
        //height: 200.0,
        width: width,
        height: height,
        loadStateChanged: (ExtendedImageState state) {
          Widget widget;
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              widget = Container(
                color: Colors.grey,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              );
              break;
            case LoadState.completed:
              //if you can't konw image size before build,
              //you have to handle crop when image is loaded.
              //so maybe your loading widget size will not the same
              //as image actual size, set returnLoadStateChangedWidget=true,so that
              //image will not to be limited by size which you set for ExtendedImage first time.
              state.returnLoadStateChangedWidget = true;

              /// if you don't want override completed widget
              /// please return null or state.completedWidget
              //return null;
              //return state.completedWidget;
              widget = Hero(
                  tag: imageItem,
                  child: buildImage(
                      state.extendedImageInfo.image, num300, num400));

              break;
            case LoadState.failed:
              widget = GestureDetector(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
//                    Image.asset(
//                      "assets/failed.jpg",
//                      fit: BoxFit.fill,
//                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Center(
                        child: Text(
                          "加载失败，点击重试",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  state.reLoadImage();
                },
              );
              break;
          }
          if (index == 8 && postItem.imageUrls.length > 9) {
            widget = Stack(
              children: <Widget>[
                widget,
                Container(
                  color: Colors.grey.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: Text(
                    "+${postItem.imageUrls.length - 9}",
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                )
              ],
            );
          }

          // （图片放大浏览）
          widget = GestureDetector(
            child: widget,
            onTap: () {
              Navigator.pushNamed(context, "fluttercandies://picswiper",
                  arguments: {
                    "index": index,
                    "pics": postItem.imageUrls
                        .map<PicSwiperItem>(
                            (f) => PicSwiperItem(f, des: f))
                        .toList(),
                  });
            },
          );

          return widget;
        });
  }

  Widget buildImage(ui.Image image, double num300, double num400) {
    return ExtendedRawImage(
      image: image,
      width: num300,
      height: num400,
      fit: BoxFit.cover,
//      soucreRect:
//          Rect.fromLTWH(0.0, 0.0, image.width.toDouble(), 4 * image.width / 3),
    );

//    var n = image.height / image.width;
//    var fitType = BoxFit.cover;
//    if (n >= 4 / 3) {
//      Widget imageWidget = ExtendedRawImage(
//        image: image,
//        width: num300,
//        height: num400,
//        fit: fitType,
////        soucreRect: Rect.fromLTWH(
////            0.0, 0.0, image.width.toDouble(), 4 * image.width / 3),
//      );
//      if (n >= 4) {
//        imageWidget = Container(
//          width: num300,
//          height: num400,
//          child: Stack(
//            children: <Widget>[
//              Positioned(
//                top: 0.0,
//                right: 0.0,
//                left: 0.0,
//                bottom: 0.0,
//                child: imageWidget,
//              ),
//              Positioned(
//                bottom: 0.0,
//                right: 0.0,
//                child: Container(
//                  padding: EdgeInsets.all(2.0),
//                  color: Colors.grey,
//                  child: const Text(
//                    "加载图像中...",
//                    style: TextStyle(color: Colors.white, fontSize: 10.0),
//                  ),
//                ),
//              )
//            ],
//          ),
//        );
//      }
//      return imageWidget;
//    } else if (4 / 3 > n && n > 3 / 4) {
//      var maxValue = max(image.width, image.height);
//      var height = num400 * image.height / maxValue;
//      var width = num400 * image.width / maxValue;
//      return ExtendedRawImage(
//        height: height,
//        width: width,
//        image: image,
//        fit: fitType,
//      );
//    } else if (n <= 3 / 4) {
//      var width = 4 * image.height / 3;
//      Widget imageWidget = ExtendedRawImage(
//        image: image,
//        width: num400,
//        height: num300,
//        fit: fitType,
////        soucreRect: Rect.fromLTWH(
////          (image.width - width) / 2.0,
////          0.0,
////          width,
////          image.height.toDouble(),
////        ),
//      );
//
//      if (n <= 1 / 4) {
//        imageWidget = Container(
//          width: num400,
//          height: num300,
//          child: Stack(
//            children: <Widget>[
//              Positioned(
//                top: 0.0,
//                right: 0.0,
//                left: 0.0,
//                bottom: 0.0,
//                child: imageWidget,
//              ),
//              Positioned(
//                bottom: 0.0,
//                right: 0.0,
//                child: Container(
//                  padding: EdgeInsets.all(2.0),
//                  color: Colors.grey,
//                  child: const Text(
//                    "long image",
//                    style: TextStyle(color: Colors.white, fontSize: 10.0),
//                  ),
//                ),
//              )
//            ],
//          ),
//        );
//      }
//      return imageWidget;
//    }
//    return Container();
  }
}