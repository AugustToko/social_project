import 'package:social_project/model/wordpress/wp_login_result.dart';
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/utils/log.dart';
import 'package:social_project/utils/net_util.dart';

/// 缓存中心
class CacheCenter {
  /// ERROR CODE
  static String error = "ERROR";

  static Map<int, WpUser> _userCache = Map();

  /// 存储 [NetTools.getAllPosts(userId)]
  static Map<int, WpPostSource> _userPosts = Map();

  /// 用作历史记录
  static Map<String, WpLoginResultDone> _wpTokenCache = Map();

  static WpLoginResultDone tokenCache;

  static WpUser getUser(final int userId) {
    if (!_userCache.containsKey(userId)) {
      LogUtils.d("CacheCenter", "未匹配到 UserID: " + userId.toString());
      return WpUser.defaultUser;
    } else {
      LogUtils.d("CacheCenter", "匹配到 UserID: " + userId.toString());
      return _userCache[userId];
    }
  }

  static void putUser(final int userId, final WpUser user) {
    _userCache[userId] = user;
  }

  static void putToken(final WpLoginResultDone result) {
    _wpTokenCache[result.userDisplayName] = result;
    tokenCache = result;
  }

  static void putPosts(final int userId, final WpPostSource wpPostSource) {
    _userPosts[userId] = wpPostSource;
  }

  static WpPostSource getPosts(final int userId) {
    if (!_userPosts.containsKey(userId))
      return null;
    else
      return _userPosts[userId];
  }
}
