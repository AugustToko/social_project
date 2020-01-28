import 'package:flutter/material.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';

import 'glow_notification_widget.dart';
import 'list_config.dart';

//loading more for listview and gridview
class LyLoadingMoreList<T> extends StatelessWidget {
  final LyListConfig<T> listConfig;

  /// Called when a ScrollNotification of the appropriate type arrives at this
  /// location in the tree.
  final NotificationListenerCallback<ScrollNotification> onScrollNotification;
  
  LyLoadingMoreList(this.listConfig, {Key key, this.onScrollNotification})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadingMoreBase>(
      builder: (d, s) {
        return NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: LyGlowNotificationWidget(
              listConfig.buildContent(context, s.data),
              showGlowLeading: listConfig.showGlowLeading,
              showGlowTrailing: listConfig.showGlowTrailing,
            ));
      },
      stream: listConfig.sourceList?.rebuild,
      initialData: listConfig.sourceList,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (onScrollNotification != null) onScrollNotification(notification);

    if (notification.depth != 0) return false;

    //reach the pixels to loading more
    if (notification.metrics.axisDirection == AxisDirection.down &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if (listConfig.hasMore && !listConfig.hasError && !listConfig.isLoading) {
        if (listConfig.sourceList.length == 0) {
          listConfig.sourceList.refresh();
        } else if (listConfig.autoLoadMore) {
          listConfig.sourceList.loadMore();
        }
      }
    }
    return false;
  }
}
