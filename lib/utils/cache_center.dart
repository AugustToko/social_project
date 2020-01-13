import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/utils/log.dart';

/// 缓存中心
class CacheCenter {
  /// ERROR CODE
  static String error = "ERROR";

  static Map<int, WpUser> _userCache = Map();

  static WpUser getUser(int userId) {
    if (!_userCache.containsKey(userId)) {
      LogUtils.d("CacheCenter", "未匹配到 UserID");
      return WpUser(name: "User", id: -1, avatarUrls: AvatarUrls(s24: "", s48: "", s96: ""));
    } else {
      LogUtils.d("CacheCenter", "匹配到 UserID");
      return _userCache[userId];
    }
  }

  static void putUser(int userId, WpUser user) {
    _userCache[userId] = user;
  }
}