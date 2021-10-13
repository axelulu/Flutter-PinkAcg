import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pink/db/hi_cache.dart';
import 'package:flutter_pink/http/dao/contact_dao.dart';
import 'package:flutter_pink/http/dao/profile_dao.dart';
import 'package:flutter_pink/model/contact.dart';
import 'package:flutter_pink/model/user_center_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/provider/websocket_provider.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/contact.dart';
import 'package:flutter_pink/util/format_util.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:flutter_pink/widget/not_found.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static var tabs = [
    {"key": "likes", "name": "消息"},
    {"key": "update_time", "name": "通知"},
  ];
  late TabController _controller;
  UserMeta? _userMeta;
  ContactMo? _contactList;

  @override
  void initState() {
    _controller = TabController(length: tabs.length, vsync: this);
    _userAvatar();
    _loadData();

    super.initState();
    //接收未读消息
    final model = Provider.of<WebSocketProvider>(context, listen: false);
    model.listen((value) {
      noReadMsg(value);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Color.fromRGBO(242, 242, 242, 1),
        child: Column(
          children: [
            _buildNavigationBar(),
            Row(
              children: [
                headerTextButton("回复我的", Icons.mail_rounded, Colors.green),
                headerTextButton(
                    "@我", Icons.alternate_email_rounded, Colors.yellow),
                headerTextButton(
                    "收到的赞", Icons.thumb_up_alt_rounded, Colors.red),
                headerTextButton("系统通知", Icons.volume_up_rounded, Colors.blue),
              ],
            ),
            hiSpace(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
              child: Text(
                "聊天列表",
                style: TextStyle(fontSize: 14),
              ),
            ),
            Divider(
              height: 1,
            ),
            _buildTabView(),
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    try {
      ContactMo result = await ContactDao.get();
      setState(() {
        _contactList = result;
      });
    } on NeedAuth catch (e) {
      showToast(e.message);
    } on NeedLogin catch (e) {
      showToast(e.message);
    } on HiNetError catch (e) {
      showToast(e.message);
    }
  }

  _userAvatar() async {
    try {
      UserMeta result = await ProfileDao.get();
      setState(() {
        _userMeta = result;
      });
    } on NeedAuth catch (e) {
      showToast(e.message);
    } on NeedLogin catch (e) {
      showToast(e.message);
    } on HiNetError catch (e) {
      showToast(e.message);
    }
  }

  _tabBar() {
    return Row(
      children: [
        appBarButton(Icons.group_add_outlined, () async {
          final text = await showTextInputDialog(
            textFields: [DialogTextField(hintText: "请输入用户uid")],
            context: context,
            title: "请输入好友uid",
            message: "输入uid以发起对话!",
            okLabel: "发起对话",
            cancelLabel: "关闭",
          );
          if (text != null) {
            var result = await ContactDao.post(text[0]);
            if (result["code"] == 1000) {
              setState(() {
                _loadData();
              });
              showToast("添加成功!");
            } else {
              showWarnToast("添加失败");
            }
          }
        }),
        Expanded(
            child: Container(
          alignment: Alignment.center,
          child: Text("消息"),
        )),
        appBarButton(Icons.people_alt_outlined, () {}),
        hiSpace(width: 15)
      ],
    );
  }

  _buildNavigationBar() {
    return NavigationBar(
      child: Container(
        alignment: Alignment.center,
        child: _tabBar(),
      ),
    );
  }

  _buildTabView() {
    return _userMeta != null
        ? Expanded(
            child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: RefreshIndicator(
                    color: primary,
                    child: _contactList != null && _contactList!.list.length > 0
                        ? Material(
                            color: Colors.white,
                            child: _contactLists(),
                          )
                        : Container(),
                    onRefresh: _loadData)),
          )
        : NotFound();
  }

  _getNoReadMsg(int sendId) {
    return HiCache.getInstance()!.get("contact_send_id_$sendId") != null &&
            HiCache.getInstance()!.get("contact_send_id_$sendId") != 0
        ? Container(
            child: Text(
              HiCache.getInstance()!.get("contact_send_id_$sendId") != null &&
                      HiCache.getInstance()!.get("contact_send_id_$sendId") != 0
                  ? "${HiCache.getInstance()!.get("contact_send_id_$sendId")}"
                  : "",
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40), color: Colors.red),
            padding: EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 1),
            margin: EdgeInsets.only(top: 5),
          )
        : Container();
  }

  _contactLists() {
    return ListView(
      children: _contactList!.list.map((contactMeta) {
        return InkWell(
          onTap: () {
            HiNavigator.getInstance().onJumpTo(RouteStatus.chat, args: {
              "currentUserMeta": _userMeta,
              "sendUserMeta": contactMeta
            });
          },
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: cachedImage(contactMeta.sendUserMeta.avatar,
                        width: 40, height: 40),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      hiSpace(height: 5),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          contactMeta.sendUserMeta.username,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 2, bottom: 10),
                        child: Text(
                          "1234567890",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      hiSpace(height: 5),
                      Divider(
                        height: 1,
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      formatDate(DateTime.parse(
                          "${contactMeta.updateTime.substring(0, 19)}")),
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    _getNoReadMsg(contactMeta.sendUserMeta.userId),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
