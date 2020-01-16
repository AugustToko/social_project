import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_properties.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/ui/page/pic_swiper.dart';
import 'package:social_project/utils/log.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;
import 'package:video_player/video_player.dart';

/// 用于显示 WordPress 文章
class WpDetailPage extends StatefulWidget {
  WpDetailPage(this.title, this.content);

  final String content;
  final String title;

  @override
  _WpPageState createState() {
    return _WpPageState(title, content);
  }
}

class _WpPageState extends State<WpDetailPage> {
  final String _content;
  final String _title;

  final List<ChangeNotifier> needDispose = [];

  _WpPageState(this._title, this._content);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  _title,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Html(
                data: _content,
                onLinkTap: (url) {
                  launch(url);
                },
                useRichText: false,
                customRender: (node, children) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      // 处理 <video>
                      case "video":
                        final videoPlayerController =
                            VideoPlayerController.network(
                          node.attributes["src"],
                        );

                        final chewieController = ChewieController(
                          videoPlayerController: videoPlayerController,
                          aspectRatio: 3 / 2,
                          autoPlay: true,
                          looping: true,
                        );

                        needDispose.add(videoPlayerController);
                        needDispose.add(chewieController);

                        final playerWidget = Chewie(
                          controller: chewieController,
                        );

                        return playerWidget;
                      case "img":
                        String imageUrl = node.attributes["data-original"];
                        return imageUrl == null
                            ? null
                            : Image.network(imageUrl);
                      default:
                        return null;
                    }
                  } else {
                    return null;
                  }
                },
                onImageTap: (url) {
                  LogUtils.d("WpDetailPage", "onImageTap");
                  Navigator.pushNamed(context, "fluttercandies://picswiper",
                      arguments: {
                        "index": 0,
                        "pics": [PicSwiperItem(url)],
                      });
                },
                onImageError: (p1, p2) {
                  print("Image Error---------------start-----------------");
                  print(p1);
                  print("---------------=======-----------------");
                  print(p2);
                  print("Image Error----------------end----------------");
                },
                showImages: true,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    needDispose.forEach((item) {
      item?.dispose();
    });
    super.dispose();
  }
}
