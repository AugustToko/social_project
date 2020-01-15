import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';
import 'package:social_project/model/tuchong/tu_chong_source.dart';
import 'package:social_project/ui/page/photo_view.dart';

/// For [PhotoViewDemo]
class ItemBuilder {
//  static Widget itemBuilder(
//      final BuildContext context, final TuChongItem item, final int index) {
//    return Container(
//      height: 200.0,
//      child: Stack(
//        children: <Widget>[
//          Positioned(
//            child: ExtendedImage.network(
//              item.imageUrl,
//              fit: BoxFit.fill,
//              width: double.infinity,
//              //height: 200.0,
//              height: double.infinity,
//            ),
//          ),
//          Positioned(
//            left: 0.0,
//            right: 0.0,
//            bottom: 0.0,
//            child: Container(
//              padding: EdgeInsets.only(left: 8.0, right: 8.0),
//              height: 40.0,
//              color: Colors.grey.withOpacity(0.5),
//              alignment: Alignment.center,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      Icon(
//                        Icons.comment,
//                        color: Colors.amberAccent,
//                      ),
//                      Text(
//                        item.comments.toString(),
//                        style: TextStyle(color: Colors.white),
//                      )
//                    ],
//                  ),
//                  LikeButton(
//                    size: 20.0,
//                    isLiked: item.isFavorite,
//                    likeCount: item.favorites,
//                    countBuilder: (int count, bool isLiked, String text) {
//                      var color = isLiked ? Colors.pinkAccent : Colors.grey;
//                      Widget result;
//                      if (count == 0) {
//                        result = Text(
//                          "love",
//                          style: TextStyle(color: color),
//                        );
//                      } else
//                        result = Text(
//                          count >= 1000
//                              ? (count / 1000.0).toStringAsFixed(1) + "k"
//                              : text,
//                          style: TextStyle(color: color),
//                        );
//                      return result;
//                    },
//                    likeCountAnimationType: item.favorites < 1000
//                        ? LikeCountAnimationType.part
//                        : LikeCountAnimationType.none,
//                    onTap: (bool isLiked) {
//                      return onLikeButtonTap(isLiked, item);
//                    },
//                  ),
//                ],
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
}

//Widget buildWaterfallFlowItem(BuildContext c, TuChongItem item, int index) {
//  final double fontSize = 12.0;
//  return Column(
//    crossAxisAlignment: CrossAxisAlignment.start,
//    children: <Widget>[
//      AspectRatio(
//        aspectRatio: item.imageSize.width / item.imageSize.height,
//        child: Stack(
//          children: <Widget>[
//            ExtendedImage.network(
//              item.imageUrl,
//              shape: BoxShape.rectangle,
//              border:
//                  Border.all(color: Colors.grey.withOpacity(0.4), width: 1.0),
//              borderRadius: BorderRadius.all(
//                Radius.circular(10.0),
//              ),
//              loadStateChanged: (value) {
//                if (value.extendedImageLoadState == LoadState.loading) {
//                  return Container(
//                    alignment: Alignment.center,
//                    color: Colors.grey.withOpacity(0.8),
//                    child: CircularProgressIndicator(
//                      strokeWidth: 2.0,
//                      valueColor:
//                          AlwaysStoppedAnimation(Theme.of(c).primaryColor),
//                    ),
//                  );
//                }
//                return null;
//              },
//            ),
//            Positioned(
//              top: 5.0,
//              right: 5.0,
//              child: Container(
//                padding: EdgeInsets.all(3.0),
//                decoration: BoxDecoration(
//                  color: Colors.grey.withOpacity(0.6),
//                  border: Border.all(
//                      color: Colors.grey.withOpacity(0.4), width: 1.0),
//                  borderRadius: BorderRadius.all(
//                    Radius.circular(5.0),
//                  ),
//                ),
//                child: Text(
//                  "${index + 1}",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(fontSize: fontSize, color: Colors.white),
//                ),
//              ),
//            )
//          ],
//        ),
//      ),
//      SizedBox(
//        height: 5.0,
//      ),
//      buildTagsWidget(item),
//      SizedBox(
//        height: 5.0,
//      ),
//      buildBottomWidget(item),
//    ],
//  );
//}

/// 标签
Widget buildTagsWidget(TuChongItem item, BuildContext context) {
  final fontSize = 12.0;
  return Wrap(
      runSpacing: 5.0,
      spacing: 5.0,
      children: item.tags.map<Widget>((tag) {
        // TODO: 是否需要标签颜色
//        final color = item.tagColors[item.tags.indexOf(tag)];
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
                tag,
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
      }).toList());
}

/// 操作栏
Widget buildBottomWidget(TuChongItem item, {bool showAvatar = true}) {
  final fontSize = 12.0;
  final iconSize = 18.0;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      showAvatar
          ? ExtendedImage.network(
              item.avatarUrl,
              width: 25.0,
              height: 25.0,
              shape: BoxShape.circle,
              //enableLoadState: false,
              border:
                  Border.all(color: Colors.grey.withOpacity(0.4), width: 1.0),
              loadStateChanged: (state) {
                if (state.extendedImageLoadState == LoadState.completed) {
                  return null;
                }
                return Image.asset("assets/avatar.jpg");
              },
            )
          : Container(),
      LikeButton(
        likeCount: item.comments,
        countBuilder: (int count, bool clicked, String text) {
          var color = clicked ? Colors.blue : Colors.grey;
          Widget result;
          if (count == 0) {
            result = Text(
              "Comment",
              style: TextStyle(color: color, fontSize: fontSize),
            );
          } else
            result = Text(
              count >= 1000 ? (count / 1000.0).toStringAsFixed(1) + "k" : text,
              style: TextStyle(color: color, fontSize: fontSize),
            );
          return result;
        },
        likeBuilder: (bool isClicked) {
          return Icon(
            FontAwesomeIcons.comment,
            color: isClicked ? Colors.blue : Colors.grey,
            size: iconSize,
          );
        },
      ),
      SizedBox(
        width: 20.0,
      ),
      LikeButton(
        size: iconSize,
        isLiked: item.isFavorite,
        likeCount: item.favorites,
        countBuilder: (int count, bool isLiked, String text) {
          var color = isLiked ? Colors.pinkAccent : Colors.grey;
          Widget result;
          if (count == 0) {
            result = Text(
              "Love",
              style: TextStyle(color: color, fontSize: fontSize),
            );
          } else
            result = Text(
              count >= 1000 ? (count / 1000.0).toStringAsFixed(1) + "k" : text,
              style: TextStyle(color: color, fontSize: fontSize),
            );
          return result;
        },
        likeCountAnimationType: item.favorites < 1000
            ? LikeCountAnimationType.part
            : LikeCountAnimationType.none,
        onTap: (bool isLiked) {
          return onLikeButtonTap(isLiked, item);
        },
      ),
      SizedBox(
        width: 20.0,
      ),
      LikeButton(
        likeCount: 999,
        countBuilder: (int count, bool clicked, String text) {
          var color = clicked ? Colors.blue : Colors.grey;
          Widget result;
          if (count == 0) {
            result = Text(
              "Retweet",
              style: TextStyle(color: color, fontSize: fontSize),
            );
          } else
            result = Text(
              count >= 1000 ? (count / 1000.0).toStringAsFixed(1) + "k" : text,
              style: TextStyle(color: color, fontSize: fontSize),
            );
          return result;
        },
        likeBuilder: (bool isClicked) {
          return Icon(
            FontAwesomeIcons.retweet,
            color: isClicked ? Colors.deepOrange : Colors.grey,
            size: iconSize,
          );
        },
      ),
      SizedBox(
        width: 20.0,
      ),
      LikeButton(
        likeCount: 999,
        countBuilder: (int count, bool clicked, String text) {
          var color = clicked ? Colors.blue : Colors.grey;
          Widget result;
          if (count == 0) {
            result = Text(
              "Share",
              style: TextStyle(color: color, fontSize: fontSize),
            );
          } else
            result = Text(
              count >= 1000 ? (count / 1000.0).toStringAsFixed(1) + "k" : text,
              style: TextStyle(color: color, fontSize: fontSize),
            );
          return result;
        },
        onTap: (bool val) {
          //TODO: Share库 支持平台问题
          Share.share("This is a test action by Social Project");
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

Future<bool> onLikeButtonTap(bool isLiked, TuChongItem item) {
  ///send your request here
  return Future<bool>.delayed(const Duration(milliseconds: 50), () {
    item.isFavorite = !item.isFavorite;
    item.favorites = item.isFavorite ? item.favorites + 1 : item.favorites - 1;
    return item.isFavorite;
  });
}

//  Future<bool> onLikeButtonTap(bool isLiked, TuChongItem item) {
//    /// send your request here
//    final Completer<bool> completer = new Completer<bool>();
//    Timer(const Duration(milliseconds: 200), () {
//      item.isFavorite = !item.isFavorite;
//      item.favorites =
//          item.isFavorite ? item.favorites + 1 : item.favorites - 1;
//
//      // if your request is failed,return null,
//      completer.complete(item.isFavorite);
//    });
//    return completer.future;
//  }

//  static Future<bool> onLikeButtonTap(bool isLiked, TuChongItem item) {
//    ///send your request here
//    ///
//    final Completer<bool> completer = new Completer<bool>();
//    Timer(const Duration(milliseconds: 200), () {
//      item.isFavorite = !item.isFavorite;
//      item.favorites =
//          item.isFavorite ? item.favorites + 1 : item.favorites - 1;
//
//      // if your request is failed,return null,
//      completer.complete(item.isFavorite);
//    });
//    return completer.future;
//  }
