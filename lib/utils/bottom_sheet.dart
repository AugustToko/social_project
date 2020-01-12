import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:social_project/model/menu.dart';
import 'package:social_project/ui/widgets/profile_tile.dart';
import 'package:social_project/utils/uidata.dart';

import '../ui/widgets/about_tile.dart';

class BottomSheetUtil {
  static Widget header() => Ink(
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: UIData.kitGradients2)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(UIData.developerAvatar),
          ),
          SizedBox(width: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ProfileTile(
              title: UIData.developerName,
              subtitle: UIData.developerEmail,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    ),
  );

  static void showSheetBottom(BuildContext context, Menu menu) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Material(
//            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).backgroundColor,
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.only(
//                    topLeft: Radius.circular(15.0),
//                    topRight: Radius.circular(15.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                BottomSheetUtil.header(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: false,
                    itemCount: menu.items.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListTile(
                          title: Text(
                            menu.items[i],
                          ),
                          onTap: () {
                            showToast("You clicked ${menu.items[i]}", position: ToastPosition.bottom);
//                            Navigator.pop(context);
//                            Navigator.pushNamed(context, "/${menu.items[i]}");
                          }),
                    ),
                  ),
                ),
                MyAboutTile()
              ],
            )));
  }

}