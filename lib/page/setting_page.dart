import 'package:flutter/material.dart';
import 'package:flutter_pink/db/hi_cache.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/provider/websocket_provider.dart';
import 'package:flutter_pink/util/hi_constants.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const _ITEMS = [
    {"name": "关于我们", "mode": ThemeMode.system},
    {"name": "关于App", "mode": ThemeMode.dark},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            NavigationBar(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _ITEMS.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Divider(
                          height: 0.2,
                        ),
                        Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                    left: 40, top: 15, bottom: 15),
                                child: Text(_ITEMS[index]["name"] as String)),
                          ),
                        ),
                        Divider(
                          height: 0.2,
                        ),
                      ],
                    );
                  }),
            ),
            hiSpace(height: 20),
            Divider(
              height: 0.4,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  HiCache.getInstance()!
                      .setString(HiConstants.Authorization, "");
                  final model =
                      Provider.of<WebSocketProvider>(context, listen: false);
                  model.close();
                  showToast("退出登录成功!");
                  // 登出用户账号
                  UmengCommonSdk.onProfileSignOff();
                  Future.delayed(Duration(milliseconds: 1000), () {
                    HiNavigator.getInstance().onJumpTo(RouteStatus.login);
                  });
                },
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "退出登录",
                      style: TextStyle(color: Colors.red),
                    )),
              ),
            ),
            Divider(
              height: 0.8,
            ),
          ],
        ),
      ),
    );
  }
}
