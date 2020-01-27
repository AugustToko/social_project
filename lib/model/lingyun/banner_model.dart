class LingYunBannerSource {

  List<LingYunBanner> data = [];

  LingYunBannerSource.fromJson(List<dynamic> json) {
    json.forEach((j){
      data.add(LingYunBanner.fromJson(j));
    });
  }
}

class LingYunBanner {
  int id;
  String title;
  String assetUrl;
  String subTitle;
  String messageText;
  String assetAuthorName;
  String publisher;
  String onTapAction;

  LingYunBanner(
      {this.id,
        this.title,
        this.assetUrl,
        this.subTitle,
        this.messageText,
        this.assetAuthorName,
        this.publisher,
        this.onTapAction});

  LingYunBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    assetUrl = json['assetUrl'];
    subTitle = json['subTitle'];
    messageText = json['messageText'];
    assetAuthorName = json['assetAuthorName'];
    publisher = json['publisher'];
    onTapAction = json['onTapAction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['assetUrl'] = this.assetUrl;
    data['subTitle'] = this.subTitle;
    data['messageText'] = this.messageText;
    data['assetAuthorName'] = this.assetAuthorName;
    data['publisher'] = this.publisher;
    data['onTapAction'] = this.onTapAction;
    return data;
  }
}
