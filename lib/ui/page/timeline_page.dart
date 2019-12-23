import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_project/logic/bloc/post_bloc.dart';
import 'package:social_project/logic/viewmodel/post_view_model.dart';
import 'package:social_project/model/post.dart';
import 'package:social_project/utils/log.dart';
import 'package:social_project/utils/theme_util.dart';
import 'package:social_project/utils/uidata.dart';

class TimelineTwoPage extends StatefulWidget {
  @override
  TimelineTwoPageState createState() {
    return new TimelineTwoPageState();
  }
}

class TimelineTwoPageState extends State<TimelineTwoPage> {
  PostBloc _postBloc;

  ScrollController _listController;

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

  /// 按钮栏
  Widget actionRow(Post post) => Padding(
        padding: const EdgeInsets.only(right: 50.0), // 图标间距
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.comment,
                size: 15.0,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.retweet,
                size: 15.0,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 15.0,
                color: Colors.grey,
              ),
              onPressed: () {
                LogUtils.d("Click heart", "");
              },
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.share,
                size: 15.0,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          ],
        ),
      );

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
                        // 无法自动适应颜色模式切换
//                        TextSpan(
//                            text: "${post.personName}  ",
//                            style: App.isDarkMode(context)
//                                ? ThemeUtil.textDark
//                                : ThemeUtil.textLight),
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
              Padding(
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
              post.messageImage != null
                  ? Material(
                      color: Colors.transparent,
                      child: Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/Slider-Yellow.png",
                              image: post.messageImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // TODO: 可否使用 {Ink.image} ?
                          // 在图像上使用水波
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  _showAlertDialog();
                                },
                                customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20.0,
              ),
              actionRow(post),
            ],
          ),
        ),
      );

  /// 列表
  Widget bodyList(List<Post> posts) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        new GlobalKey<RefreshIndicatorState>();

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      child: Scrollbar(
        child: ListView.builder(
          controller: _listController,
          itemCount: posts.length + 1,
          itemBuilder: (context, i) {
            if (i < posts.length) {
              final Post post = posts[i];
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, UIData.commentDetail,
                        arguments: "Comment Detail Page");
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                          context, UIData.profile);
                                    },
                                    customBorder: CircleBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          rightColumn(post),
                        ],
                      ),
                    ),
                  ),
                ),
              );
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
    final PostViewModel postViewModel = PostViewModel();
    _posts.addAll(postViewModel.getPosts());
    _postBloc.postController.add(_posts);
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
      var maxScroll = _listController.position.maxScrollExtent;
      var pixels = _listController.position.pixels;

      if (maxScroll == pixels) {
        final PostViewModel postViewModel = PostViewModel();
        _posts.addAll(postViewModel.getPosts());
        _postBloc.postController.add(_posts);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _postBloc?.dispose();
    _listController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyData(),
      floatingActionButton: StreamBuilder<bool>(
        stream: _postBloc.fabVisible,
        initialData: true,
        builder: (context, snapshot) => AnimatedOpacity(
          duration: Duration(milliseconds: 200),
          opacity: snapshot.data ? 1.0 : 0.0,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.white,
            child: CustomPaint(
              child: Container(),
              foregroundPainter: FloatingPainter(),
            ),
          ),
        ),
      ),
    );
  }

  _showAlertDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Building'),
        content: Text("放大图片"),
        semanticLabel: 'Label',
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.pop(context), child: Text('Close')),
        ],
      ),
    );
  }
}

class FloatingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint amberPaint = Paint()
      ..color = Colors.amber
      ..strokeWidth = 5;

    Paint greenPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5;

    Paint bluePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5;

    Paint redPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    canvas.drawLine(Offset(size.width * 0.27, size.height * 0.5),
        Offset(size.width * 0.5, size.height * 0.5), amberPaint);
    canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width * 0.5, size.height - (size.height * 0.27)),
        greenPaint);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width - (size.width * 0.27), size.height * 0.5), bluePaint);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.5),
        Offset(size.width * 0.5, size.height * 0.27), redPaint);
  }

  @override
  bool shouldRepaint(FloatingPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(FloatingPainter oldDelegate) => false;
}
