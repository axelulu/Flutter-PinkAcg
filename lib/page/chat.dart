import 'package:flutter/material.dart';
import 'package:flutter_pink/db/hi_cache.dart';
import 'package:flutter_pink/http/dao/chat_dao.dart';
import 'package:flutter_pink/model/chat_mo.dart';
import 'package:flutter_pink/model/contact.dart';
import 'package:flutter_pink/model/user_center_mo.dart';
import 'package:flutter_pink/provider/websocket_provider.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/clipboard_tool.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:flutter_pink/widget/not_found.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final UserMeta currentUserMeta;
  final ContactList sendUserMeta;

  const ChatPage(this.currentUserMeta, this.sendUserMeta, {Key? key})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  String _msg = "";
  ChatList? _msgList;
  ScrollController _controller = ScrollController();
  var model;

  @override
  void initState() {
    _loadData();

    HiCache.getInstance()!.setInt(
        "contact_send_id_${widget.sendUserMeta.sendUserMeta.userId}", 0);
    //先在启动时初始化
    final model = Provider.of<WebSocketProvider>(context, listen: false);
    model.listen((value) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (value.userId == widget.sendUserMeta.sendUserMeta.userId) {
          setState(() {
            _msgList!.list.add(value);
          });
          HiCache.getInstance()!.setInt(
              "contact_send_id_${widget.sendUserMeta.sendUserMeta.userId}", 0);
        }
        _gotoBottom(100);
      });
    });
    _gotoBottom(500);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _gotoBottom(int time) {
    Future.delayed(Duration(milliseconds: time), () {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildNavigationBar(),
          Expanded(
            child: _buildTabView(),
          )
        ],
      ),
    );
  }

  _appBar() {
    return Container(
      decoration: bottomBoxShadow(context),
      child: Row(
        children: [
          appBarButton(Icons.arrow_back_ios_outlined, () {
            Navigator.of(context).pop();
          }),
          hiSpace(width: 15),
          Expanded(child: Text(widget.sendUserMeta.sendUserMeta.username)),
          appBarButton(Icons.settings_outlined, () {}),
          hiSpace(width: 15)
        ],
      ),
    );
  }

  _buildNavigationBar() {
    return NavigationBar(
      child: _appBar(),
    );
  }

  _buildTabView() {
    return Container(
      color: Color.fromRGBO(242, 242, 242, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: MediaQuery.removePadding(
                removeTop: true,
                removeBottom: true,
                context: context,
                child: ListView(
                  controller: _controller,
                  children: [_msgList != null ? _chatList() : NotFound()],
                )),
          ),
          _bottomSendBar()
        ],
      ),
    );
  }

  void sendMsg() {
    if (_msg == null || _msg == "") {
      showWarnToast("请输入内容！");
      return;
    }
    final model = Provider.of<WebSocketProvider>(context, listen: false);
    model.send(_msg, widget.currentUserMeta.userId, widget.sendUserMeta.sendId);
    Map<String, dynamic> msg = {
      "cmd": 10,
      "send_id": widget.sendUserMeta.sendId,
      "user_id": widget.currentUserMeta.userId,
      "content": _msg,
      "media": 1,
    };
    setState(() {
      _msgList!.list.add(ChatMo.fromJson(msg));
      _msg = "";
    });
    _gotoBottom(100);
  }

  _chatAvatar() {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              offset: Offset(5, 5), //xy轴偏移
              blurRadius: 5.0, //阴影模糊程度
              spreadRadius: 1, //阴影扩散程度
            )
          ],
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(35)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child:
            cachedImage(widget.currentUserMeta.avatar, width: 35, height: 35),
      ),
    );
  }

  void _loadData() async {
    try {
      ChatList result =
          await ChatDao.get(widget.sendUserMeta.sendUserMeta.userId);
      setState(() {
        _msgList = result;
      });
    } on NeedAuth catch (e) {
      showToast(e.message);
    } on NeedLogin catch (e) {
      showToast(e.message);
    } on HiNetError catch (e) {
      showToast(e.message);
    }
  }

  _chatBubble(value) {
    return InkWell(
      onLongPress: () {
        ClipboardTool.setDataToast(value.content);
      },
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                offset: Offset(5, 5), //xy轴偏移
                blurRadius: 5.0, //阴影模糊程度
                spreadRadius: 1, //阴影扩散程度
              )
            ],
            color: value.userId == widget.currentUserMeta.userId
                ? Color.fromRGBO(235, 249, 255, 1)
                : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                  value.userId == widget.currentUserMeta.userId ? 20 : 0),
              topRight: Radius.circular(
                  value.userId == widget.currentUserMeta.userId ? 0 : 20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            )),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Text(
          value.content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          maxLines: 200,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  _chatList() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: _msgList!.list.map((value) {
          return Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              children: [
                value.userId == widget.currentUserMeta.userId
                    ? Container()
                    : _chatAvatar(),
                Expanded(
                    child: Row(
                  mainAxisAlignment:
                      value.userId == widget.currentUserMeta.userId
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment:
                          value.userId == widget.currentUserMeta.userId
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      crossAxisAlignment:
                          value.userId == widget.currentUserMeta.userId
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Text(
                            value.userId == widget.currentUserMeta.userId
                                ? "${widget.currentUserMeta.username}"
                                : "${widget.sendUserMeta.sendUserMeta.username}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                        _chatBubble(value)
                      ],
                    )
                  ],
                )),
                value.userId == widget.currentUserMeta.userId
                    ? _chatAvatar()
                    : Container(),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  _bottomSendBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.image_outlined,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.center,
                child: TextField(
                  onSubmitted: (value) {
                    sendMsg();
                  },
                  onChanged: (value) {
                    setState(() {
                      _msg = value;
                    });
                  },
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  controller: TextEditingController.fromValue(TextEditingValue(
                      text: _msg, //判断keyword是否为空
                      // 保持光标在最后

                      selection: TextSelection.fromPosition(TextPosition(
                          affinity: TextAffinity.downstream,
                          offset: _msg.length)))),
                  decoration: InputDecoration(
                      hintText: "发个消息聊聊呗!",
                      hintStyle: TextStyle(fontSize: 12),
                      isCollapsed: true,
                      //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      //内容内边距，影响高度

                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
                decoration: BoxDecoration(color: Colors.grey[100]),
              ),
            ),
          )),
          InkWell(
            onTap: sendMsg,
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 32,
                  alignment: Alignment.center,
                  child: Text(
                    "发送",
                    style: TextStyle(
                        color: _msg.length > 0 ? Colors.white : Colors.grey),
                  ),
                  decoration: BoxDecoration(
                      color: _msg.length > 0 ? primary : Colors.grey[100]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
