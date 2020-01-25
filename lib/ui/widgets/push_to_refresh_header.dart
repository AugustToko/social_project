import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:intl/intl.dart';

import 'package:social_project/utils/screen_util.dart';

double get maxDragOffset => ScreenUtil.getInstance().setWidth(180);
double hideHeight = maxDragOffset / 2.3;
double refreshHeight = maxDragOffset / 1.5;

class PullToRefreshHeader extends StatelessWidget {
  final PullToRefreshScrollNotificationInfo info;
  final DateTime lastRefreshTime;
  final Color color;

  PullToRefreshHeader(this.info, this.lastRefreshTime, {this.color});

  @override
  Widget build(BuildContext context) {
    if (info == null) return Container();
    String text = "";
    if (info.mode == RefreshIndicatorMode.armed) {
      text = "释放刷新";
    } else if (info.mode == RefreshIndicatorMode.refresh ||
        info.mode == RefreshIndicatorMode.snap) {
      text = "加载中...";
    } else if (info.mode == RefreshIndicatorMode.done) {
      text = "刷新完成";
    } else if (info.mode == RefreshIndicatorMode.drag) {
      text = "下拉以便刷新";
    } else if (info.mode == RefreshIndicatorMode.canceled) {
      text = "取消刷新";
    }

    final TextStyle ts = TextStyle(
      color: Colors.grey,
    ).copyWith(fontSize: ScreenUtil.getInstance().setSp(26));

    double dragOffset = info?.dragOffset ?? 0.0;

    DateTime time = lastRefreshTime ?? DateTime.now();
    final top = -hideHeight + dragOffset;
    return Container(
      height: dragOffset,
      color: color ?? Colors.transparent,
      //padding: EdgeInsets.only(top: dragOffset / 3),
      //padding: EdgeInsets.only(bottom: 5.0),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: top,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: RefreshImage(top),
                    margin: EdgeInsets.only(right: 12.0),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Text(
                      text,
                      style: ts,
                    ),
                    Text(
                      "上次更新:" +
                          DateFormat("yyyy-MM-dd hh:mm").format(time),
                      style: ts.copyWith(
                          fontSize: ScreenUtil.getInstance().setSp(24)),
                    )
                  ],
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

///TODO: 刷新图像
class RefreshImage extends StatelessWidget {
  final double top;

  RefreshImage(this.top);

  @override
  Widget build(BuildContext context) {
    final double imageSize = ScreenUtil.getInstance().setWidth(80);
    return FlutterLogo(size: 40,);
  }
}
