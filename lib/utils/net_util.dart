import 'package:http_client_helper/http_client_helper.dart';
import 'package:social_project/model/wordpress/wp_login_result.dart';
import 'dart:async';
import 'dart:convert';

import 'package:social_project/model/wordpress/wp_user.dart';

class NetTools {
  /// 此段介绍WP REST API 常用的获取数据（GET）的接口，提交数据因涉及到较为复杂的认证，此篇文章限于篇幅，后面看情况，再计划出一篇专门的WP REST API认证的文章单独介绍。
  ///
  /// 注：本文介绍的是WP REST API V2 版本，wordpress 4.4以上版本
  ///
  /// 1、文章
  /// （1）获取最新文章（默认获取到最新的10篇文章）
  ///
  /// http://www.website.com/wp-json/wp/v2/posts
  ///
  /// 与
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?page=1
  ///
  /// 效果相同，page用于指定页数，WP REST API 默认返回10条数据，用page指定数据获取的游标。如
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?page=2
  ///
  /// 可取回最新的第11条数据到第20条数据，以此类推。
  ///
  /// （2）设置获取的每页文章数量及分页
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[posts_per_page]=5
  ///
  /// filter[posts_per_page]=5 用于指定返回文章每页的数量，这里指定每页数量为5篇。
  ///
  /// filter[posts_per_page]与page联合使用：
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[posts_per_page]=5&page=2
  ///
  /// （3）获取指定分类的文章
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[cat]=2
  ///
  /// filter[cat]=2 指定分类ID为2 ，返回分类ID为2的文章。
  ///
  /// 分类ID是每个分类目录在创建时自动生成的ID，在wordpress后台“文章”==》“分类目录”中，把鼠标放在分类名称上面，页面下方会出现一个网址，网址中的参数tag_ID=2就是这个分类名称的分类ID。如果没有出现网址，可以点击分类名称下的“编辑”，然后查看网页地址栏，同样可以得到tag_ID=2。下面的标签ID的获得方法也一样。
  ///
  /// （4）获取指定标签的文章
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[tag]=library
  ///
  /// filter[tag]=library 指定标签名为“library”的文章
  ///
  /// （5）获取指定分类和有指定标签的文章
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[cat]=2&filter[tag]=library
  ///
  /// 上面两个结合一起，可以得到更具体精确的文章。
  ///
  /// （6）获取指定日期的文章
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[year]=2016&filter[monthnum]=03
  ///
  /// filter[year]=2016&filter[monthnum]=03 设置指定的日期
  ///
  /// （7）获取指定作者的文章
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[author_name]=jinyun
  ///
  /// filter[author_name]=jinyun设置指定作者名字
  ///
  /// （8）按关键词搜索文章
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[s]=金云
  ///
  /// filter[s]=金云 ：按给定的关键词搜索文章，返回包含“金云”关键词的文章。
  ///
  /// （9）获取随机文章
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[orderby]=rand
  ///
  /// 其中orderby还可以为指定的字段排序
  ///
  /// （10）获取相关文章
  ///
  /// 在网站中，在做SEO优化和页面内容布局时，获取相关文章是比较常见的，可以通过以上几个条件组合来达到获取相关文章的效果。
  ///
  /// 按标签获取相关文章：
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[orderby]=rand&filter[tag]=library&filter[posts_per_page]=6
  ///
  /// 按分类获取相关文章：
  ///
  /// http://www.website.com/wp-json/wp/v2/posts?filter[orderby]=rand&filter[cat]=2&filter[posts_per_page]=6
  ///
  /// （11）获取指定文章的数据
  ///
  /// http://www.website.com/wp-json/wp/v2/posts/189
  ///
  /// 得到ID为189的文章数据
  ///
  /// 2、分类和标签
  /// （1）获取所有的分类
  ///
  /// http://www.website.com/wp-json/wp/v2/categories
  ///
  /// （2）获取指定分类ID的分类信息
  ///
  /// http://www.website.com/wp-json/wp/v2/categories/2
  ///
  /// （3）获取所有的标签
  ///
  /// http://www.website.com/wp-json/wp/v2/tags
  ///
  /// （4）获取指定标签ID的标签信息
  ///
  /// http://www.website.com/wp-json/wp/v2/tags/3
  ///
  /// 3、媒体文件
  /// （1）获取所有的媒体信息
  ///
  /// http://www.website.com/wp-json/wp/v2/media
  ///
  /// （2）获取指定媒体ID的媒体信息
  ///
  /// http://www.website.com/wp-json/wp/v2/media/17
  ///
  /// 4、页面
  /// （1）获取所有的页面信息
  ///
  /// http://www.website.com/wp-json/wp/v2/pages
  ///
  /// （2）获取指定页面ID的页面信息
  ///
  /// http://www.website.com/wp-json/wp/v2/pages/289
  ///
  /// 5、类型
  /// （1）获取当前wordpress所有的内容类型
  ///
  /// http://www.website.com/wp-json/wp/v2/types
  ///
  /// 一般情况下会返回post,page和attachment三种类型
  ///
  /// （2）获取指定类型
  ///
  /// http://www.website.com/wp-json/wp/v2/types/post
  ///
  /// 6、评论
  /// （1）获取所有评论信息
  ///
  /// http://www.website.com/wp-json/wp/v2/comments
  ///
  /// （2）获取指定评论ID的单条评论信息
  ///
  /// http://www.website.com/wp-json/wp/v2/comments/2
  ///
  /// 7、用户
  /// （1）获取所有的用户信息
  ///
  /// http://www.website.com/wp-json/wp/v2/users
  ///
  /// （2）获取指定用户ID的用户信息
  ///
  /// http://www.website.com/wp-json/wp/v2/users/1

  static Future<WpUser> getWpUserInfo(String webSite, int userId) async {
    // 解析 URL
    final String url = webSite + "/wp-json/wp/v2/users/" + userId.toString();

    WpUser data;
    try {
      var result = await HttpClientHelper.get(url);
      data = WpUser.fromJson(json.decode(result.body));
    } catch (exception, stack) {
      print(exception);
      print(stack);
    }
    return data;
  }

  static Future<WpLoginResult> getWpLoginResult(
      String webSite, String userName, String password) async {
    // 解析 URL
    final String url = webSite + "/wp-json/jwt-auth/v1/token";

    var aut = {
      'username': userName,
      'password': password,
    };

    WpLoginResult data;
    try {
      var result = await HttpClientHelper.post(url, body: aut);
      data = WpLoginResult.fromJson(json.decode(result.body));
    } catch (exception, stack) {
      print(exception);
      print(stack);
    }
    return data;
  }

  static Future<WpLoginResult> getTokenWpUserInfo(
      String webSite, String userName, String password) async {
    // 解析 URL
    final String url = webSite + "/wp-json/jwt-auth/v1/token";

    var aut = {
      'username': userName,
      'password': password,
    };

    WpLoginResult data;
    try {
      var result = await HttpClientHelper.post(url, body: aut);
      data = WpLoginResult.fromJson(json.decode(result.body));
    } catch (exception, stack) {
      print(exception);
      print(stack);
    }
    return data;
  }
}
