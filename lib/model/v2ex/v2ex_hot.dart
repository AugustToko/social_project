class V2exHot {
  Node node;
  Member member;
  String lastReplyBy;
  int lastTouched;
  String title;
  String url;
  int created;
  String content;
  String contentRendered;
  int lastModified;
  int replies;
  int id;

  V2exHot(
      {this.node,
        this.member,
        this.lastReplyBy,
        this.lastTouched,
        this.title,
        this.url,
        this.created,
        this.content,
        this.contentRendered,
        this.lastModified,
        this.replies,
        this.id});

  V2exHot.fromJson(Map<String, dynamic> json) {
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
    member =
    json['member'] != null ? new Member.fromJson(json['member']) : null;
    lastReplyBy = json['last_reply_by'];
    lastTouched = json['last_touched'];
    title = json['title'];
    url = json['url'];
    created = json['created'];
    content = json['content'];
    contentRendered = json['content_rendered'];
    lastModified = json['last_modified'];
    replies = json['replies'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.node != null) {
      data['node'] = this.node.toJson();
    }
    if (this.member != null) {
      data['member'] = this.member.toJson();
    }
    data['last_reply_by'] = this.lastReplyBy;
    data['last_touched'] = this.lastTouched;
    data['title'] = this.title;
    data['url'] = this.url;
    data['created'] = this.created;
    data['content'] = this.content;
    data['content_rendered'] = this.contentRendered;
    data['last_modified'] = this.lastModified;
    data['replies'] = this.replies;
    data['id'] = this.id;
    return data;
  }
}

class Node {
  String avatarLarge;
  String name;
  String avatarNormal;
  String title;
  String url;
  int topics;
  String footer;
  String header;
  String titleAlternative;
  String avatarMini;
  int stars;
  bool root;
  int id;
  String parentNodeName;

  Node(
      {this.avatarLarge,
        this.name,
        this.avatarNormal,
        this.title,
        this.url,
        this.topics,
        this.footer,
        this.header,
        this.titleAlternative,
        this.avatarMini,
        this.stars,
        this.root,
        this.id,
        this.parentNodeName});

  Node.fromJson(Map<String, dynamic> json) {
    avatarLarge = json['avatar_large'];
    name = json['name'];
    avatarNormal = json['avatar_normal'];
    title = json['title'];
    url = json['url'];
    topics = json['topics'];
    footer = json['footer'];
    header = json['header'];
    titleAlternative = json['title_alternative'];
    avatarMini = json['avatar_mini'];
    stars = json['stars'];
    root = json['root'];
    id = json['id'];
    parentNodeName = json['parent_node_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar_large'] = this.avatarLarge;
    data['name'] = this.name;
    data['avatar_normal'] = this.avatarNormal;
    data['title'] = this.title;
    data['url'] = this.url;
    data['topics'] = this.topics;
    data['footer'] = this.footer;
    data['header'] = this.header;
    data['title_alternative'] = this.titleAlternative;
    data['avatar_mini'] = this.avatarMini;
    data['stars'] = this.stars;
    data['root'] = this.root;
    data['id'] = this.id;
    data['parent_node_name'] = this.parentNodeName;
    return data;
  }
}

class Member {
  String username;
  String website;
  String github;
  String psn;
  String avatarNormal;
  String bio;
  String url;
  String tagline;
  String twitter;
  int created;
  String avatarLarge;
  String avatarMini;
  String location;
  String btc;
  int id;

  Member(
      {this.username,
        this.website,
        this.github,
        this.psn,
        this.avatarNormal,
        this.bio,
        this.url,
        this.tagline,
        this.twitter,
        this.created,
        this.avatarLarge,
        this.avatarMini,
        this.location,
        this.btc,
        this.id});

  Member.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    website = json['website'];
    github = json['github'];
    psn = json['psn'];
    avatarNormal = json['avatar_normal'];
    bio = json['bio'];
    url = json['url'];
    tagline = json['tagline'];
    twitter = json['twitter'];
    created = json['created'];
    avatarLarge = json['avatar_large'];
    avatarMini = json['avatar_mini'];
    location = json['location'];
    btc = json['btc'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['website'] = this.website;
    data['github'] = this.github;
    data['psn'] = this.psn;
    data['avatar_normal'] = this.avatarNormal;
    data['bio'] = this.bio;
    data['url'] = this.url;
    data['tagline'] = this.tagline;
    data['twitter'] = this.twitter;
    data['created'] = this.created;
    data['avatar_large'] = this.avatarLarge;
    data['avatar_mini'] = this.avatarMini;
    data['location'] = this.location;
    data['btc'] = this.btc;
    data['id'] = this.id;
    return data;
  }
}
