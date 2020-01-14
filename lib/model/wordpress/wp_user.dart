class WpUser {

  static WpUser defaultUser = WpUser(
      url: "",
      name: "User",
      id: -1,
      avatarUrls: AvatarUrls(s24: "", s48: "", s96: ""));

  int id;
  String name;
  String url;
  String description;
  String link;
  String slug;
  AvatarUrls avatarUrls;
  Links lLinks;

  WpUser(
      {this.id,
        this.name,
        this.url,
        this.description,
        this.link,
        this.slug,
        this.avatarUrls,
//        this.meta,
        this.lLinks});

  WpUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    description = json['description'];
    link = json['link'];
    slug = json['slug'];
    avatarUrls = json['avatar_urls'] != null
        ? new AvatarUrls.fromJson(json['avatar_urls'])
        : null;
//    if (json['meta'] != null) {
//      meta = new List<Null>();
//      json['meta'].forEach((v) {
//        meta.add(new Null.fromJson(v));
//      });
//    }
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url'] = this.url;
    data['description'] = this.description;
    data['link'] = this.link;
    data['slug'] = this.slug;
    if (this.avatarUrls != null) {
      data['avatar_urls'] = this.avatarUrls.toJson();
    }
    if (this.lLinks != null) {
      data['_links'] = this.lLinks.toJson();
    }
    return data;
  }
}

class AvatarUrls {
  String s24;
  String s48;
  String s96;

  AvatarUrls({this.s24, this.s48, this.s96});

  AvatarUrls.fromJson(Map<String, dynamic> json) {
    s24 = json['24'];
    s48 = json['48'];
    s96 = json['96'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['24'] = this.s24;
    data['48'] = this.s48;
    data['96'] = this.s96;
    return data;
  }
}

class Links {
  List<Self> self;

  Links({this.self, /*this.collection*/});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['self'] != null) {
      self = new List<Self>();
      json['self'].forEach((v) {
        self.add(new Self.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.self != null) {
      data['self'] = this.self.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Self {
  String href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
