import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:social_project/model/menu.dart';
import 'package:social_project/model/wordpress/wp_post_source.dart';
import 'package:social_project/model/wordpress/wp_rep.dart';
import 'package:social_project/model/wordpress/wp_user.dart';
import 'package:social_project/ui/page/profile/profile_one_page.dart';
import 'package:social_project/ui/widgets/wp/user_header.dart';
import 'package:social_project/utils/bottom_sheet.dart';
import 'package:social_project/utils/cache_center.dart';
import 'package:social_project/utils/net_util.dart';
import 'package:social_project/utils/uidata.dart';
import 'package:url_launcher/url_launcher.dart';

/// 根据所给 UserId 获取信息
class ProfilePage extends StatefulWidget {
  final int _wpUserId;

  ProfilePage(this._wpUserId);

  @override
  State<StatefulWidget> createState() {
    return ProfilePageState(_wpUserId);
  }
}

class ProfilePageState extends State<ProfilePage> {
  Size deviceSize;

  final int _wpUserId;

  WpUser wpUser = WpUser.defaultUser;

  bool _destroy = false;

  final List<Widget> _posts = [];

  ProfilePageState(this._wpUserId);

  Widget profileHeader() => Container(
        height: deviceSize.height / 4,
        width: double.infinity,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(width: 2.0, color: Colors.white)),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(wpUser.avatarUrls.s96)),
//                    WpUserHeader(
//                      radius: 40,
//                      userId: wpUser.id,
//                      showUserName: false,
//                      wpSource: WordPressRep.wpSource,
//                      canClick: false,
//                    ),
                  ),
                  Text(
                    wpUser.name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Text(
                    // TODO: building
                    "Building...",
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget imagesCard() => Container(
        height: deviceSize.height / 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Photos",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
              ),
              Expanded(
                child: Card(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        "https://cdn.pixabay.com/photo/2016/10/31/18/14/ice-1786311_960_720.jpg",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget postCard() => Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Posts (Latest 5 articles)",
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18.0),
                    ),
                    MaterialButton(
                      child: Text(
                        "More",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        //TODO: more
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: _posts,
              )
            ],
          ),
        ),
      );

  Widget articleCard(final WpPost post) {
    var content = post.content.rendered;

    content =
        content.substring(0, content.length >= 1000 ? 1000 : content.length);

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, UIData.wpPostDetail, arguments: {
            "content": post.content.rendered,
            "title": post.title.rendered,
          });
        },
        onLongPress: () {
          BottomSheetUtil.showSheetBottom(
              context,
              wpUser,
              Menu(title: "Title", items: [
                "Open source url",
                "Share",
                "Add to favourite",
                "Hide",
              ]), (i, menu) {
            switch (i) {
              case 0:
                {
                  launch(post.link);
                }
                break;
              case 1:
                Share.share(post.title.rendered + ":" + " \r\n" + post.link);
                break;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            10,
            010,
            10,
            10,
          ),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      WpUserHeader(
                        canClick: false,
                        radius: 20,
                        userId: wpUser.id,
                        showUserName: true,
                        wpSource: WordPressRep.wpSource,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              post.title.rendered,
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              post.date,
                            ),
                          ],
                        ),
                      ),
                      Text(content)
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Body
  Widget bodyData() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            profileHeader(),
            followColumn(deviceSize),
            imagesCard(),
            postCard(),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    if (_wpUserId != -1) {
      NetTools.getWpUserInfoAuto(_wpUserId).then((user) {
        CacheCenter.putUser(_wpUserId, user);
        wpUser = user;

        NetTools.getPostsAuto(wpUser.id, 5).then((wpPostsSource) {
          if (!_destroy) {
            wpPostsSource.feedList.forEach((post) {
              _posts.add(articleCard(post));
            });
            setState(() {});
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: bodyData(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _destroy = true;
  }
}
