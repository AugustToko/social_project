import 'dart:async';

import 'package:social_project/logic/viewmodel/post_view_model.dart';
import 'package:social_project/model/post.dart';

class PostBloc {
  /// 默认值
  final PostViewModel defaultPostViewModel = PostViewModel();
  final postController = StreamController<List<Post>>();
  final fabController = StreamController<bool>();
  final fabVisibleController = StreamController<bool>();

  Sink<bool> get fabSink => fabController.sink;

  Stream<List<Post>> get postItems => postController.stream;

  Stream<bool> get fabVisible => fabVisibleController.stream;

  PostBloc() {
    postController.add(defaultPostViewModel.getPosts());
    fabController.stream.listen(onScroll);
  }

  onScroll(bool visible) {
    fabVisibleController.add(visible);
  }

  void dispose() {
    postController?.close();
    fabController?.close();
    fabVisibleController?.close();
  }
}
