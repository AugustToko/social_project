//TODO: 使用完整的登陆返回数据
class WpLoginResult {
  // 成功数据
  WpLoginResultDone done;
  // 失败数据
  WpLoginResultFail fail;
}

class WpLoginResultDone {
  String token;
  int userId;
  String userEmail;
  String userNicename;
  String userDisplayName;
  UserCaps userCaps;

  WpLoginResultDone(
      {this.token,
      this.userId,
      this.userEmail,
      this.userNicename,
      this.userDisplayName,
      this.userCaps});

  WpLoginResultDone.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userId = json['user_id'];
    userEmail = json['user_email'];
    userNicename = json['user_nicename'];
    userDisplayName = json['user_display_name'];
    userCaps = json['user_caps'] != null
        ? new UserCaps.fromJson(json['user_caps'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user_id'] = this.userId;
    data['user_email'] = this.userEmail;
    data['user_nicename'] = this.userNicename;
    data['user_display_name'] = this.userDisplayName;
    if (this.userCaps != null) {
      data['user_caps'] = this.userCaps.toJson();
    }
    return data;
  }
}

class UserCaps {
  bool administrator;
  bool subscriber;

  UserCaps({this.administrator,this.subscriber});

  UserCaps.fromJson(Map<String, dynamic> json) {
    administrator = json['administrator'];
    subscriber = json['subscriber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['administrator'] = this.administrator;
    data['subscriber'] = this.subscriber;
    return data;
  }
}

/// -------------------

/// 错误信息
class WpLoginResultFail {
  String code;
  String message;
  Data data;

  WpLoginResultFail({this.code, this.message, this.data});

  WpLoginResultFail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int status;

  Data({this.status});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}
