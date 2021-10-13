import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:flutter_pink/http/dao/coin_dao.dart';
import 'package:flutter_pink/http/dao/comment_dao.dart';
import 'package:flutter_pink/http/dao/favorite_dao.dart';
import 'package:flutter_pink/http/dao/follow_dao.dart';
import 'package:flutter_pink/http/dao/like_dao.dart';
import 'package:flutter_pink/http/dao/video_detail_dao.dart';
import 'package:flutter_pink/http/request/barrage_switch.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/model/video_detail_mo.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/hi_constants.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/appbar.dart';
import 'package:flutter_pink/widget/barrage_input.dart';
import 'package:flutter_pink/widget/expandable_content.dart';
import 'package:flutter_pink/widget/hi_tab.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:flutter_pink/widget/video_header.dart';
import 'package:flutter_pink/widget/video_large_card.dart';
import 'package:flutter_pink/widget/video_toolbar.dart';
import 'package:flutter_pink/widget/video_view.dart';
import 'package:hi_barrage/hi_barrage.dart';
import 'package:hi_net/core/hi_error.dart';

import 'comment_tab_page.dart';

class VideoDetailPage extends StatefulWidget {
  final PostMo videoModel;

  const VideoDetailPage(this.videoModel, {Key? key}) : super(key: key);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论"];
  VideoDetailMo? videoDetailMo;
  late PostMo videoModel;
  List<PostMo> videoList = [];
  var _barrageKey = GlobalKey<HiBarrageState>();
  bool _inoutShowing = false;
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    //黑色状态栏
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
      removeTop: Platform.isIOS,
      context: context,
      child: videoModel.video != null
          ? Column(
              children: [
                NavigationBar(
                  color: Colors.black,
                  statusStyle: StatusStyle.LIGHT_CONTENT,
                  height: Platform.isAndroid ? 0 : 46,
                ),
                _buildVideoView(),
                _buildTabNavigation(),
                Flexible(
                  child: TabBarView(
                    controller: _controller,
                    children: [
                      _buildDetailList(),
                      RefreshIndicator(
                          color: primary,
                          onRefresh: _loadComment,
                          child: Column(
                            children: [
                              Expanded(
                                child: CommentTabPage(
                                  postId: videoModel.postId,
                                ),
                              ),
                              SafeArea(
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      hiSpace(width: 15),
                                      _buildInput(context),
                                      _buildSendBtn(context)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            )
          : Container(),
    ));
  }

  _buildInput(BuildContext context) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(26)),
      child: TextField(
        controller: textEditingController,
        onSubmitted: (value) {
          _send(value);
        },
        cursorColor: primary,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
          hintText: "发送一条评论!",
        ),
      ),
    ));
  }

  Future<void> _send(String value) async {
    try {
      if (value.length > 0) {
        textEditingController.text = "";
        var result = await CommentDao.post(videoModel.postId, value, "post");
        if (result["code"] == 1000) {
          setState(() {});
          showToast("评论成功");
        } else {
          showWarnToast("评论失败");
        }
      } else {
        showWarnToast("评论为空");
      }
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    }
  }

  _buildSendBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        var text = textEditingController.text.isNotEmpty
            ? textEditingController.text.trim()
            : "";
        _send(text);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.send_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }

  _buildVideoView() {
    return VideoView(
      videoModel.video,
      cover: videoModel.cover,
      overlayUI: videoAppBar(onBack: () {}),
      barrageUI: HiBarrage(
        headers: HiConstants.header(),
        key: _barrageKey,
        vid: videoModel.postId.toString(),
        autoPlay: true,
      ),
    );
  }

  _buildTabNavigation() {
    return Container(
      decoration: bottomBoxShadow(context),
      height: 40,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_tabBar(), _buildBarrageBtn()],
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs: tabs.map<Tab>((tab) {
        return Tab(
          text: tab,
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents(), ..._buildVideoList()],
    );
  }

  buildContents() {
    return [
      videoDetailMo != null
          ? VideoHeader(
              userMeta: videoModel.userMeta,
              time: videoModel.updateTime,
              isFollow: videoDetailMo!.isFollow,
              isSelf: videoDetailMo!.isSelf,
              onFollow: videoDetailMo!.isFollow ? _unFollow : _follow,
            )
          : Container(),
      ExpandableContent(mo: videoModel),
      videoDetailMo != null
          ? VideoToolBar(
              detailMo: videoDetailMo,
              videoModel: videoModel,
              onLike: _doLike,
              onUnLike: _doUnLike,
              onFavorite: _onFavorite,
              onCoin: _onCoin,
            )
          : Container(),
    ];
  }

  void _loadDetail() async {
    try {
      VideoDetailMo result =
          await VideoDetailDao.get(videoModel.postId.toString());
      setState(() {
        videoDetailMo = result;
        videoModel = result.postInfo!;
        videoList = result.postList!;
      });
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    }
  }

  _follow() async {
    try {
      var res = await FollowDao.get(videoModel.userMeta.userId);
      if (res["code"] == 1000) {
        setState(() {
          videoDetailMo!.isFollow = !videoDetailMo!.isFollow;
          showToast("关注成功!");
        });
      } else {
        showWarnToast("关注失败!");
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  _unFollow() async {
    try {
      var res = await FollowDao.remove(videoModel.userMeta.userId);
      if (res["code"] == 1000) {
        setState(() {
          videoDetailMo!.isFollow = !videoDetailMo!.isFollow;
          showToast("取消关注成功!");
        });
      } else {
        showWarnToast("取消关注失败!");
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  ///点赞
  _doLike() async {
    try {
      var res = await LikeDao.get(videoModel.postId);
      if (res["code"] == 1000) {
        setState(() {
          videoDetailMo!.isLike = true;
          videoDetailMo!.isUnLike = false;
          if (videoModel.likes >= 0) {
            videoModel.likes += 1;
          }
          if (videoModel.un_likes >= 1) {
            videoModel.un_likes -= 1;
          }
          showToast("喜欢成功!");
        });
      } else {
        showWarnToast("喜欢失败!");
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  ///取消点赞
  _doUnLike() async {
    try {
      var res = await LikeDao.remove(videoModel.postId);
      if (res["code"] == 1000) {
        setState(() {
          videoDetailMo!.isLike = false;
          videoDetailMo!.isUnLike = true;
          if (videoModel.likes >= 1) {
            videoModel.likes -= 1;
          }
          if (videoModel.un_likes >= 0) {
            videoModel.un_likes += 1;
          }
          showToast("讨厌成功!");
        });
      } else {
        showWarnToast("讨厌失败!");
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  ///投币
  void _onCoin() async {
    try {
      var res = await CoinDao.get(videoModel.postId);
      if (res["code"] == 1000) {
        setState(() {
          videoDetailMo!.isCoin = true;
          videoModel.coin += 1;
        });
        showToast("投币成功!");
      } else {
        showWarnToast("投币失败!");
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  ///收藏
  void _onFavorite() async {
    try {
      var res;
      if (videoDetailMo!.isFavorite) {
        res = await FavoriteDao.remove(videoModel.postId);
      } else {
        res = await FavoriteDao.get(videoModel.postId);
      }
      if (res["code"] == 1000) {
        setState(() {
          if (videoDetailMo!.isFavorite) {
            videoDetailMo!.isFavorite = false;
            if (videoModel.favorite >= 1) {
              videoModel.favorite -= 1;
            }
            showToast("取消收藏成功!");
          } else {
            videoDetailMo!.isFavorite = true;
            if (videoModel.favorite >= 0) {
              videoModel.favorite += 1;
            }
            showToast("收藏成功!");
          }
        });
      } else {
        showWarnToast("收藏失败!");
      }
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  _buildVideoList() {
    return videoList.map((PostMo mo) => VideoLargeCard(videoModel: mo));
  }

  _buildBarrageBtn() {
    return BarrageSwitch(
        inoutShowing: _inoutShowing,
        onShowInput: () {
          setState(() {
            _inoutShowing = true;
          });
          HiOverlay.show(context,
              child: BarrageInput(
                onTabClose: () {
                  setState(() {
                    _inoutShowing = false;
                  });
                },
                text: "发送友善的弹幕见证当下!",
              )).then((value) {
            _barrageKey.currentState!.send(value!);
          });
        },
        onBarrageSwitch: (open) {
          if (open) {
            _barrageKey.currentState!.play();
          } else {
            _barrageKey.currentState!.pause();
          }
        });
  }

  Future<void> _loadComment({loadMore = false}) async {}
}
