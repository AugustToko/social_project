import 'dart:async';

import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide CircularProgressIndicator;
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:shared/model/wordpress/wp_post_source.dart';
import 'package:shared/rep/wp_rep_argments_posts.dart';
import 'package:shared/ui/widget/loading_more_list_widget/list_config.dart';
import 'package:shared/ui/widget/loading_more_list_widget/loading_more_sliver_list.dart';
import 'package:shared/ui/widget/push_to_refresh_header.dart';
import 'package:social_project/rebuild/view/page/wp_page.dart';

/// 通用文章展示页面（列表）
/// TODO: 进一步简化代码
class PostsPage extends StatefulWidget {

  static const argPostsPage = '/argPostsPage';

  final String _url;
  final AppBar _appBar;

  PostsPage(this._url, this._appBar);

  @override
  _WordPressPageState createState() => _WordPressPageState(_url, _appBar);
}

class _WordPressPageState extends State<PostsPage> {
  ArgPostsRep listSourceRepository;

  final String _url;

  final AppBar _appBar;

  _WordPressPageState(this._url, this._appBar);

  @override
  void initState() {
    listSourceRepository = ArgPostsRep(_url);
    super.initState();
  }

  // if you can't know image size before build,
  // you have to handle copy when image is loaded.
  bool knowImageSize = true;
  DateTime dateTimeNow = DateTime.now();

  @override
  void dispose() {
    listSourceRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = Material(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Expanded(
            child: PullToRefreshNotification(
              pullBackOnRefresh: false,
              maxDragOffset: maxDragOffset,
              armedDragUpCancel: false,
              onRefresh: onRefresh,
              child: LoadingMoreCustomScrollView(
                showGlowLeading: false,
                physics: ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: PullToRefreshContainer((info) {
                      return PullToRefreshHeader(info, dateTimeNow);
                    }),
                  ),
                  LyLoadingMoreSliverList(
                    LySliverListConfig<WpPost>(
                      indicatorBuilder: (p, q) {
                        return WordPressPageContentState.buildIndicator(
                            listSourceRepository.length);
                      },
                      collectGarbage: (List<int> indexes) {
                        ///TODO: collectGarbage
                        indexes.forEach((index) {});
                      },
                      itemBuilder: (context, item, index) {
                        return WordPressPageContentState.buildCard(
                            context, item, index);
                      },
                      sourceList: listSourceRepository,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );

    return Scaffold(
      appBar: _appBar,
      body: ExtendedTextSelectionPointerHandler(
        //default behavior
        // child: result,
        //custom your behavior
        builder: (states) {
          return Listener(
            child: result,
            behavior: HitTestBehavior.translucent,
            onPointerDown: (value) {
              for (var state in states) {
                if (!state.containsPosition(value.position)) {
                  //clear other selection
                  state.clearSelection();
                }
              }
            },
            onPointerMove: (value) {
              //clear other selection
              for (var state in states) {
                state.clearSelection();
              }
            },
          );
        },
      ),
    );
  }

  Future<bool> onRefresh() {
    return listSourceRepository.refresh().whenComplete(() {
      dateTimeNow = DateTime.now();
    });
  }
}
