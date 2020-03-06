class EditorData {
  String title;
  String insert;

  EditorData({this.title, this.insert});

  EditorData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    insert = json['insert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['insert'] = this.insert;
    return data;
  }
}