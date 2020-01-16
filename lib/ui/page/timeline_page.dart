import 'package:chewie/chewie.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:oktoast/oktoast.dart';
import 'package:share/share.dart';
import 'package:social_project/logic/bloc/post_bloc.dart';
import 'package:social_project/model/menu.dart';
import 'package:social_project/model/post.dart';
import 'package:social_project/utils/bottom_sheet.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:video_player/video_player.dart';

class TimelineTwoPage extends StatefulWidget {
  @override
  TimelineTwoPageState createState() {
    return TimelineTwoPageState();
  }
}

class TimelineTwoPageState extends State<TimelineTwoPage> {
  PostBloc _postBloc;

  ScrollController _listController;

  List<ChangeNotifier> needDispose = [];

  List<Post> _posts = [];

  Widget bodyData() {
    return StreamBuilder<List<Post>>(
        stream: _postBloc.postItems,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? bodyList(snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  /// TODO: 按钮按下的操作逻辑及count数据填充
  /// 按钮栏
  Widget actionRow(Post post) {
    const double iconSize = 18.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        LikeButton(
          likeCount: 999,
          onTap: (bool val) {
            Navigator.pushNamed(
              context,
              UIData.sendPage,
            );
            return Future.value(true);
          },
          likeBuilder: (bool isClicked) {
            return Icon(
              FontAwesomeIcons.comment,
              color: isClicked ? Colors.deepPurpleAccent : Colors.grey,
              size: iconSize,
            );
          },
        ),
        LikeButton(
          likeCount: 999,
          likeBuilder: (bool isClicked) {
            return Icon(
              FontAwesomeIcons.retweet,
              color: isClicked ? Colors.deepOrange : Colors.grey,
              size: iconSize,
            );
          },
        ),
        LikeButton(
          likeCount: 999,
          size: iconSize,
        ),
        LikeButton(
          likeCount: 999,
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

  /// card 右侧
  Widget rightColumn(Post post) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text("${post.personName}  "),
                    RichText(
                      maxLines: 1,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "@${post.address} · ",
                            style: ThemeUtil.subtitle),
                        TextSpan(
                            text: "${post.postTime}", style: ThemeUtil.subtitle)
                      ]),
                    )
                  ],
                ),
              ),
              post.message == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        post.message,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: UIData.quickFont),
                      ),
                    ),
              SizedBox(
                height: 10.0,
              ),
              // 放置图片
              checkPost(post),
              SizedBox(
                height: 10.0,
              ),
              actionRow(post),
            ],
          ),
        ),
      );

  Widget checkPost(final Post post) {
    switch (post.postPreviewType) {
      case PostCommentType.AUDIO:
        {
          return _buildAudioCard(post);
        }
        break;
      case PostCommentType.IMAGE:
        {
          return _buildImageCard(post);
        }
        break;
      case PostCommentType.VIDEO:
        {
          return _buildVideoCard(post);
        }
        break;
      default:
        {
          return Container();
        }
    }
  }

  Widget _buildVideoCard(final Post post) {
    final videoPlayerController = VideoPlayerController.network(
        'https://static.weiran.org.cn/video/Stellarium%20%E6%BC%94%E7%A4%BA%E5%9B%9B%E6%98%9F%E8%BF%9E%E7%8F%A0.mp4');

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

    return _uCard(playerWidget, null);
  }

  Widget _buildAudioCard(final Post post) {
    return Card();
  }

  Widget _buildImageCard(final Post post) {
    if (post.messageImage == null) return Container();
    return _uCard(
//        FadeInImage.assetNetwork(
//          placeholder: AssetsManager.IMAGE_PLACE_HOLDER,
//          image: post.messageImage,
//          fit: BoxFit.cover,
//          imageScale: 0.1,
//        ),
        ExtendedImage.network(
          post.messageImage,
          fit: BoxFit.cover,
          cache: true,
          scale: 0.5,
          clearMemoryCacheIfFailed: true,
          //cancelToken: cancellationToken,
        ), () {
      showToast("Building...");
    });
  }

  /// 通用组件
  Widget _uCard(final Widget child, GestureTapCallback onTap) {
    List<Widget> widgets = [];
    widgets.add(
      ClipRRect(
        borderRadius: ThemeUtil.clipRRectBorderRadius,
        child: child,
      ),
    );

    if (onTap != null) {
      // TODO: 可否使用 {Ink.image} ?
      // 在图像上使用水波
      widgets.add(Positioned.fill(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ));
    }

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: widgets,
      ),
    );
  }

  /// 列表
  Widget bodyList(List<Post> posts) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      child: Scrollbar(
        child: ListView.builder(
          controller: _listController,
          itemCount: posts.length + 1,
          itemBuilder: (context, i) {
            if (i < posts.length) {
              final Post post = posts[i];

              var card = ThemeUtil.materialCard(InkWell(
                onTap: () {
                  Navigator.pushNamed(context, UIData.commentDetail);
                },
                onLongPress: () {
                  BottomSheetUtil.showSheetBottom(
                      context, null, Menu(title: "Title", items: ["data"]),
                      (i, menu) {
                    showToast("You clicked ${menu.items[i]}",
                        position: ToastPosition.bottom);
                  });
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // LEFT
                        Stack(
                          children: <Widget>[
                            CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                  post.personImage,
                                )),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      UIData.profile,
                                    );
                                  },
                                  customBorder: CircleBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // RIGHT
                        rightColumn(post),
                      ],
                    ),
                  ),
                ),
              ));

              //TODO: 置顶信息
              if (i == 0) {
                return Column(
                  children: <Widget>[
                    ThemeUtil.materialCard(Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Image.asset("assets/images/timeline.jpeg"),
                    )),
                    card
                  ],
                );
              } else {
                return card;
              }
            } else {
              return Card(
                child: Center(
                  child: Text("Load more."),
                ),
              );
            }
          },
        ),
      ),
      onRefresh: _pullToRefresh,
    );
  }

  /// TimeLine 刷新操作
  /// TODO: 待完善
  Future<Null> _pullToRefresh() async {
//    final PostViewModel postViewModel = PostViewModel();
//    _posts.addAll(postViewModel.getPosts());
//    _postBloc.postController.sink.add(_posts);
  }

  @override
  void initState() {
    // TODO: 默认值待完善
    _postBloc = PostBloc();
    _posts.addAll(_postBloc.defaultPostViewModel.getPosts());

    _listController = ScrollController();
    _listController.addListener(() {
      if (_listController.position.userScrollDirection ==
          ScrollDirection.reverse) _postBloc.fabSink.add(false);
      if (_listController.position.userScrollDirection ==
          ScrollDirection.forward) _postBloc.fabSink.add(true);

      // TODO: 上拉加载新内容
      // TODO: 上拉加载新内容时保持滚动位置
//      var maxScroll = _listController.position.maxScrollExtent;
//      var pixels = _listController.position.pixels;
//
//      if (maxScroll == pixels) {
//        final PostViewModel postViewModel = PostViewModel();
//        _posts.addAll(postViewModel.getPosts());
//        _postBloc.postController.add(_posts);
//      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _postBloc?.dispose();
    _listController?.dispose();
    needDispose.forEach((item) {
      item?.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyData(),
//      floatingActionButton: StreamBuilder<bool>(
//        stream: _postBloc.fabVisible,
//        initialData: true,
//        builder: (context, snapshot) => AnimatedOpacity(
//          duration: Duration(milliseconds: 200),
//          opacity: snapshot.data ? 1.0 : 0.0,
//          child: FloatingActionButton(
//            onPressed: () {
//              Navigator.pushNamed(
//                context,
//                UIData.sendPage,
//              );
//            },
//            backgroundColor: Colors.white,
//            child: CustomPaint(
//              child: Container(),
//              foregroundPainter: FloatingPainter(),
//            ),
//          ),
//        ),
//      ),
    );
  }
}
