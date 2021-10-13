import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pink/http/dao/profile_dao.dart';
import 'package:flutter_pink/model/user_center_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/provider/theme_provider.dart';
import 'package:flutter_pink/util/bottom_sheet.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/format_util.dart';
import 'package:flutter_pink/util/hi_constants.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserMeta? _profileMo;
  Color _color = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>().isDark();
    if (themeProvider) {
      _color = HiColor.dark_bg;
    } else {
      _color = Colors.white;
    }
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            NavigationBar(
              child: _appBar(),
            ),
            _profileMo != null
                ? Container(
                    color: _color,
                    child: _tabBar(),
                  )
                : Container(),
          ],
        ),
      ],
    ));
  }

  void _loadData() async {
    try {
      UserMeta result = await ProfileDao.get();
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      showToast(e.message);
    } on NeedLogin catch (e) {
      showToast(e.message);
    } on HiNetError catch (e) {
      showToast(e.message);
    }
  }

  _appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        appBarButton(Icons.bedtime_outlined, () {
          HiNavigator.getInstance().onJumpTo(RouteStatus.darkMode);
        }),
        appBarButton(Icons.color_lens_outlined, () {}),
        hiSpace(width: 15)
      ],
    );
  }

  _tabBar() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            HiNavigator.getInstance().onJumpTo(RouteStatus.userCenter,
                args: {"profileMo": _profileMo, "type": "current_user"});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child:
                        cachedImage(_profileMo!.avatar, width: 60, height: 60)),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          "${_profileMo!.username}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      hiSpace(width: 2),
                      Icon(
                        Icons.male_outlined,
                        size: 14,
                        color: Colors.blue,
                      ),
                      hiSpace(width: 2),
                      Text(
                        "LV5",
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                  _profileMo!.isVip == "1"
                      ? Container(
                          margin: EdgeInsets.only(left: 15, top: 5),
                          padding: EdgeInsets.only(
                              left: 2, right: 2, top: 0, bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: primary,
                          ),
                          child: Text(
                            "年度大会员",
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 5),
                    child: Text(
                      "B币：${_profileMo!.coin}    硬币：${_profileMo!.coin}",
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ],
              )),
              Text(
                "空间",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 20,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 30, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              mySpaceFollow(_profileMo!.active.toString(), "动态", onTap: () {
                HiNavigator.getInstance().onJumpTo(RouteStatus.starCoinLikePost,
                    args: {
                      "post_type": "dynamic",
                      "user_id": _profileMo!.userId
                    });
              }),
              longString(),
              mySpaceFollow(_profileMo!.fans.toString(), "粉丝", onTap: () {
                HiNavigator.getInstance()
                    .onJumpTo(RouteStatus.followFans, args: {"type": "fans"});
              }),
              longString(),
              mySpaceFollow(_profileMo!.follows.toString(), "关注", onTap: () {
                HiNavigator.getInstance()
                    .onJumpTo(RouteStatus.followFans, args: {"type": "follow"});
              }),
            ],
          ),
        ),
        _myServer(),
        _creationCenter(),
        _moreServer()
      ],
    );
  }

  _myServer() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText(Icons.cloud_download_outlined, "离线缓存",
              onClick: () {}, tint: true),
          _buildIconText(Icons.restore_outlined, "历史记录",
              onClick: () {}, tint: true),
          _buildIconText(Icons.star_outline, "我的收藏", onClick: () {
            HiNavigator.getInstance().onJumpTo(RouteStatus.starCoinLikePost,
                args: {"post_type": "star", "user_id": _profileMo!.userId});
          }, tint: true),
          _buildIconText(Icons.watch_later_outlined, "稍后再看",
              onClick: () {}, tint: true),
        ],
      ),
    );
  }

  _creationCenter() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "创作中心",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                      onTap: _openPublish,
                      child: Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          color: primary,
                          child: Row(
                            children: [
                              Icon(
                                Icons.file_upload,
                                color: Colors.white,
                                size: 18,
                              ),
                              Text(
                                "发布",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white),
                              ),
                            ],
                          ))),
                )
              ],
            )),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconText(Icons.article_outlined, "稿件管理",
                  onClick: () {}, tint: true),
              _buildIconText(Icons.people_alt_outlined, "我的粉丝", onClick: () {
                HiNavigator.getInstance()
                    .onJumpTo(RouteStatus.followFans, args: {"type": "fans"});
              }, tint: true),
              _buildIconText(Icons.supervised_user_circle, "我的关注", onClick: () {
                HiNavigator.getInstance()
                    .onJumpTo(RouteStatus.followFans, args: {"type": "follow"});
              }, tint: true),
              _buildIconText(Icons.star_border_outlined, "我的收藏", onClick: () {
                HiNavigator.getInstance().onJumpTo(RouteStatus.starCoinLikePost,
                    args: {"post_type": "star", "user_id": _profileMo!.userId});
              }, tint: true),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconText(Icons.thumb_up_alt_outlined, "我的喜欢", onClick: () {
                HiNavigator.getInstance().onJumpTo(RouteStatus.starCoinLikePost,
                    args: {"post_type": "like", "user_id": _profileMo!.userId});
              }, tint: true),
              _buildIconText(Icons.thumb_down_alt_outlined, "我的讨厌",
                  onClick: () {
                HiNavigator.getInstance().onJumpTo(RouteStatus.starCoinLikePost,
                    args: {
                      "post_type": "unlike",
                      "user_id": _profileMo!.userId
                    });
              }, tint: true),
              _buildIconText(Icons.monetization_on_outlined, "我的投币",
                  onClick: () {
                HiNavigator.getInstance().onJumpTo(RouteStatus.starCoinLikePost,
                    args: {"post_type": "coin", "user_id": _profileMo!.userId});
              }, tint: true),
              _buildIconText(Icons.drive_file_move_outline, "我的视频",
                  onClick: () {
                HiNavigator.getInstance().onJumpTo(RouteStatus.starCoinLikePost,
                    args: {
                      "post_type": "video",
                      "user_id": _profileMo!.userId
                    });
              }, tint: true),
            ],
          ),
        ),
      ],
    );
  }

  _moreServer() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "更多服务",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            )),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              _bottomMenu("更多服务", Icons.support_agent_outlined, () async {
                // android 和 ios 的 QQ 启动 url scheme 是不同的
                var url;
                if (Platform.isAndroid) {
                  url = 'mqqwpa://im/chat?chat_type=wpa&uin=${HiConstants.qq}';
                } else {
                  url =
                      'mqq://im/chat?chat_type=wpa&uin=${HiConstants.qq}&version=1&src_type=web';
                }
                // 确认一下url是否可启动
                if (await canLaunch(url)) {
                  await launch(url); // 启动QQ
                } else {
                  // 自己封装的一个 Toast
                  showWarnToast('无法启动QQ');
                }
              }),
              _bottomMenu("设置", Icons.settings_outlined, () {
                HiNavigator.getInstance().onJumpTo(RouteStatus.setting);
              })
            ],
          ),
        ),
      ],
    );
  }

  _buildIconText(IconData iconData, text, {onClick, bool tint = false}) {
    if (text is int) {
      text = countFormat(text);
    } else if (text == null) {
      text = "";
    }
    tint = tint == null ? false : tint;
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Icon(
            iconData,
            size: 26,
            color: tint ? primary : Colors.grey,
          ),
          hiSpace(height: 5),
          Text(
            text,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }

  _bottomMenu(String text, IconData icon, GestureTapCallback onTap) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: primary,
            ),
            hiSpace(width: 10),
            Expanded(child: Text(text)),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  _openPublish() {
    moreHandleDialog(
        context,
        1,
        Container(
          color: Color.fromRGBO(242, 242, 242, 1),
          child: Stack(
            children: [
              Positioned(
                bottom: 30,
                left: 5,
                right: 5,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 21,
                          margin: EdgeInsets.all(8),
                          child: publishButton("发布文章", Icons.post_add_outlined,
                              () {
                            Navigator.of(context).pop();
                            HiNavigator.getInstance().onJumpTo(
                                RouteStatus.publish,
                                args: {"type": "post"});
                          }, isSpace: true),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2 - 21,
                          margin: EdgeInsets.all(8),
                          child:
                              publishButton("发布视频", Icons.movie_outlined, () {
                            Navigator.of(context).pop();
                            HiNavigator.getInstance().onJumpTo(
                                RouteStatus.publish,
                                args: {"type": "video"});
                          }, isSpace: true),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 19.33,
                          margin: EdgeInsets.all(8),
                          child: publishButton(
                              "写动态", Icons.dynamic_feed_outlined, () {
                            Navigator.of(context).pop();
                            HiNavigator.getInstance().onJumpTo(
                                RouteStatus.publish,
                                args: {"type": "dynamic"});
                          }),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 19.33,
                          margin: EdgeInsets.all(8),
                          child: publishButton(
                              "发音乐", Icons.music_note_outlined, () {}),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 - 19.34,
                          margin: EdgeInsets.all(8),
                          child: publishButton(
                              "发剧集", Icons.video_call_outlined, () {}),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 30,
                  left: 10,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.close_outlined),
                    style: ButtonStyle(
                      //定义文本的样式 这里设置的颜色是不起作用的
                      textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 18, color: Colors.white)),
                      //设置按钮上字体与图标的颜色
                      //foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
                      //更优美的方式来设置
                      foregroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          if (states.contains(MaterialState.focused) &&
                              !states.contains(MaterialState.pressed)) {
                            //获取焦点时的颜色
                            return Colors.grey[400];
                          } else if (states.contains(MaterialState.pressed)) {
                            //按下时的颜色
                            return Colors.grey[400];
                          }
                          //默认状态使用灰色
                          return Colors.grey[400];
                        },
                      ),
                      //背景颜色
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        //设置按下时的背景颜色
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.grey[300];
                        }
                        //默认不使用背景颜色
                        return Colors.grey[300];
                      }),
                      //设置水波纹颜色
                      overlayColor: MaterialStateProperty.all(Colors.grey[300]),
                      //设置阴影  不适用于这里的TextButton
                      elevation: MaterialStateProperty.all(0),
                      //设置按钮内边距
                      padding: MaterialStateProperty.all(EdgeInsets.all(4)),
                      //设置按钮的大小
                      minimumSize: MaterialStateProperty.all(Size(20, 20)),

                      //外边框装饰 会覆盖 side 配置的样式
                      shape: MaterialStateProperty.all(StadiumBorder()),
                    ),
                  ))
            ],
          ),
        ));
  }
}
