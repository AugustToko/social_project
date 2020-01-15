class Post {
  int postPreviewType = PostCommentType.DEFAULT;
  String personName;
  String personImage;
  String address;
  String message;
  String messageImage;
  int likesCount;
  int commentsCount;
  String postTime;
  List<String> photos;

  Post({
    this.postPreviewType,
    this.personName,
    this.personImage,
    this.address,
    this.message,
    this.commentsCount,
    this.likesCount,
    this.messageImage,
    this.postTime,
    this.photos,
  });
}

/// 帖子预览类型
class PostCommentType {
  /// 默认为文本类型
  static const int DEFAULT = 0;
  static const int AUDIO = 1;
  static const int VIDEO = 3;
  static const int IMAGE = 4;

  /// 文本类型无需更多其它内容
  static const int TEXT = DEFAULT;
  static const int TEXT_IMAGE = 6;
}
