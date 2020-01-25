/// 滚动展示图数据
class BannerPost {
  int postPreviewType = BannerPostCommentType.DEFAULT;
  String title;
  String assetUrl;
  String subTitle;
  String messageText;
  String assetAuthorName;

  BannerPost({
    this.postPreviewType,
    this.title,
    this.assetUrl,
    this.subTitle,
    this.messageText,
    this.assetAuthorName,
  });
}

/// 帖子预览类型
class BannerPostCommentType {
  static const int AUDIO = 1;
  static const int VIDEO = 3;
  /// 文本类型无需更多其它内容
  static const int TEXT_IMAGE = 6;
  static const int DEFAULT = TEXT_IMAGE;
}
