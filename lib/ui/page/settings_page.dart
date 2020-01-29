import 'package:flutter/material.dart';
import 'package:social_project/rebuild/helper/constants.dart';
import 'package:social_project/ui/widgets/common_scaffold.dart';
import 'package:social_project/utils/uidata.dart';

class SettingsOnePage extends StatelessWidget {
  Widget bodyData(BuildContext context) => SingleChildScrollView(
        child: Theme(
          data: ThemeData(fontFamily: UIData.ralewayFont),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //1
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "一般设置",
                ),
              ),
              Card(
                color: Theme.of(context).backgroundColor,
                elevation: 2.0,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      title: buildText(context, "账号"),
                      trailing: buildArrowIcon(context, Icons.arrow_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.green,
                      ),
                      title: buildText(context, "通知"),
                      trailing: buildArrowIcon(context, Icons.arrow_right),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              //2
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "其他",
                ),
              ),
              Card(
                color: Theme.of(context).backgroundColor,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                elevation: 2.0,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.help,
                        color: Colors.indigoAccent,
                      ),
                      title: buildText(context, "帮助与反馈"),
                      trailing: buildArrowIcon(context, Icons.arrow_right),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.textsms,
                        color: Colors.blueGrey,
                      ),
                      title: buildText(context, "用户协议"),
                      trailing: buildArrowIcon(context, Icons.arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, UIData.webPage, arguments: {"title" : "用户协议", "url" : UserAgreementUrl});
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.security,
                        color: Colors.orange,
                      ),
                      title: buildText(context, "隐私政策"),
                      trailing: buildArrowIcon(context, Icons.arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, UIData.webPage, arguments: {"title" : "隐私政策", "url" : PrivacyPolicyUrl});
                      },
                    ),
//                    ListTile(
//                      leading: Icon(
//                        Icons.lock,
//                        color: Colors.red,
//                      ),
//                      title: buildText(context, "安全条款"),
//                      trailing: buildArrowIcon(context, Icons.arrow_right),
//                      onTap: () {},
//                    ),
                    ListTile(
                      leading: Icon(
                        Icons.info,
                        color: Colors.blue,
                      ),
                      title: buildText(context, "关于 ${UIData.appName}"),
                      trailing: buildArrowIcon(context, Icons.arrow_right),
                      onTap: () {
                        Navigator.pushNamed(context, UIData.aboutPage);
                      },
                    )
                  ],
                ),
              ),

//              //2
//              Padding(
//                padding: const EdgeInsets.all(16.0),
//                child: Text(
//                  "Network",
//                ),
//              ),
//              Card(
//                color: Theme.of(context).backgroundColor,
//                elevation: 2.0,
//                child: Column(
//                  children: <Widget>[
//                    ListTile(
//                      leading: Icon(
//                        Icons.sim_card,
//                        color: Colors.grey,
//                      ),
//                      title: buildText(context, "Simcard & Network"),
//                      trailing: buildArrowIcon(context, Icons.arrow_right),
//                      onTap: (){},
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        Icons.wifi,
//                        color: Colors.amber,
//                      ),
//                      title: buildText(context, "Wifi"),
//                      trailing: CommonSwitch(
//                        defValue: true,
//                      ),
//                      onTap: () {
//                      },
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        Icons.bluetooth,
//                        color: Colors.blue,
//                      ),
//                      title: buildText(context, "Bluetooth"),
//                      trailing: CommonSwitch(
//                        defValue: false,
//                      ),
//                      onTap: () {},
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        Icons.more_horiz,
//                        color: Colors.grey,
//                      ),
//                      title: buildText(context, "More"),
//                      trailing: buildArrowIcon(context, Icons.arrow_right),
//                      onTap: () {},
//                    ),
//                  ],
//                ),
//              ),

//              //3
//              Padding(
//                padding: const EdgeInsets.all(16.0),
//                child: Text(
//                  "Sound",
//                ),
//              ),
//              Card(
//                color: Theme.of(context).backgroundColor,
//                elevation: 2.0,
//                child: Column(
//                  children: <Widget>[
//                    ListTile(
//                      leading: Icon(
//                        Icons.do_not_disturb_off,
//                        color: Colors.orange,
//                      ),
//                      title: buildText(context, "Silent Mode"),
//                      trailing: CommonSwitch(
//                        defValue: false,
//                      ),
//                      onTap: () {},
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        Icons.vibration,
//                        color: Colors.purple,
//                      ),
//                      title: buildText(context, "Vibrate Mode"),
//                      trailing: CommonSwitch(
//                        defValue: true,
//                      ),
//                      onTap: () {},
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        Icons.volume_up,
//                        color: Colors.green,
//                      ),
//                      title: buildText(context, "Sound Volume"),
//                      trailing: buildArrowIcon(context, Icons.arrow_right),
//                      onTap: () {},
//                    ),
//                    ListTile(
//                      leading: Icon(
//                        Icons.phonelink_ring,
//                        color: Colors.grey,
//                      ),
//                      title: buildText(context, "Ringtone"),
//                      trailing: buildArrowIcon(context, Icons.arrow_right),
//                      onTap: () {},
//                    )
//                  ],
//                ),
//              ),
            ],
          ),
        ),
      );

  Text buildText(BuildContext context, String content) {
    return Text(
      content,
      style: TextStyle(color: Theme.of(context).textTheme.title.color),
    );
  }

  Icon buildArrowIcon(BuildContext context, IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).textTheme.title.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("应用设置"),
        elevation: 4.0,
      ),
      body: bodyData(context),
    );
  }
}
