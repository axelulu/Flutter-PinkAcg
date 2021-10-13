import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pink/http/dao/upload_dao.dart';
import 'package:flutter_pink/http/dao/user_update_dao.dart';
import 'package:flutter_pink/model/upload_mo.dart';
import 'package:flutter_pink/model/user_center_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/clipboard_tool.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:image_picker/image_picker.dart';

class AccountInfoPage extends StatefulWidget {
  final UserMeta profileMo;

  const AccountInfoPage(this.profileMo, {Key? key}) : super(key: key);

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromRGBO(242, 242, 242, 1),
      child: Column(
        children: [
          _buildNavigationBar(),
          _buildTabView(),
        ],
      ),
    ));
  }

  _buildNavigationBar() {
    return NavigationBar(
      child: Container(
        alignment: Alignment.center,
        child: _tabBar(),
      ),
    );
  }

  _tabBar() {
    return Row(
      children: [
        appBarButton(Icons.arrow_back_ios_outlined, () {
          Navigator.of(context).pop();
        }),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(right: 30),
          alignment: Alignment.center,
          child: Text("账号资料"),
        )),
      ],
    );
  }

  _buildTabView() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Divider(
              height: 0.5,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
                  var type =
                      await showModalActionSheet(context: context, actions: [
                    SheetAction(label: "从相册选择", key: 0),
                  ]);
                  if (type == 0) {
                    ImageSource gallerySource = ImageSource.gallery;
                    final ImagePicker _picker = ImagePicker();
                    final file = await _picker.pickImage(
                        source: gallerySource, imageQuality: 65);
                    if (file == null) return null;
                    UplaodMo url = await UploadDao.uploadImg(file);
                    setState(() {
                      widget.profileMo.avatar = url.data;
                    });
                    _updateInfo("avatar", widget.profileMo.avatar);
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "头像",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: cachedImage(widget.profileMo.avatar,
                                width: 60, height: 60),
                          ),
                          hiSpace(width: 3),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  HiNavigator.getInstance().onJumpTo(
                      RouteStatus.accountInfoUsername,
                      args: {"profileMo": widget.profileMo});
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "昵称",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.profileMo.username,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          hiSpace(width: 3),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
                  var text = (await showModalActionSheet(
                      context: context,
                      actions: [
                        SheetAction(label: "男", key: 0),
                        SheetAction(label: "女", key: 1)
                      ]))!;
                  setState(() {
                    widget.profileMo.gender = text;
                  });
                  _updateInfo("gender", widget.profileMo.gender.toString());
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "性别",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.profileMo.gender == 0 ? "男" : "女",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          hiSpace(width: 3),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
                  var text = await showDatePicker(
                      cancelText: "关闭",
                      confirmText: "确定",
                      context: context,
                      initialDate: DateTime(
                          int.parse(widget.profileMo.birth.substring(0, 4)),
                          int.parse(widget.profileMo.birth.substring(5, 7)),
                          int.parse(widget.profileMo.birth.substring(8, 10))),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  if (text != null) {
                    setState(() {
                      widget.profileMo.birth = text.toString();
                    });
                    _updateInfo("birth", widget.profileMo.birth);
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "出生年月",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.profileMo.birth.substring(0, 10),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          hiSpace(width: 3),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  HiNavigator.getInstance().onJumpTo(
                      RouteStatus.accountInfoDesc,
                      args: {"profileMo": widget.profileMo});
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "个性签名",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.profileMo.descr == ""
                                ? "介绍一下自己吧!"
                                : widget.profileMo.descr,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          hiSpace(width: 3),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            hiSpace(height: 10),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  ClipboardTool.setDataToast(
                      widget.profileMo.userId.toString());
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "UID",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        children: [
                          Text(
                            "${widget.profileMo.userId}",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          hiSpace(width: 3),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  showToast("正在开发中");
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "二维码名片",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  showToast("正在开发中");
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "购买邀请码",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.5,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateInfo(String slug, String value) async {
    try {
      var result = await UserUpdateDao.update(slug, value);
      if (result["code"] == 1000) {
        showToast("修改成功");
      } else {
        showToast("修改失败");
      }
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    }
  }
}
