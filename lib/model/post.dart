class Post {
  int commentType = 0;
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
    this.commentType,
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

/// 帖子类型
class PostCommentType {
  static const int DEFAULT = 0;
  static const int AUDIO = 1;
  static const int VIDEO = 3;
  static const int IMAGE = 4;
  static const int TEXT = 5;
  static const int TEXT_IMAGE = 6;
}