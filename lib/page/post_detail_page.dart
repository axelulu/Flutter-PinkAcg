import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
import 'package:flutter_pink/http/dao/comment_dao.dart';
import 'package:flutter_pink/http/dao/favorite_dao.dart';
import 'package:flutter_pink/http/dao/follow_dao.dart';
import 'package:flutter_pink/http/dao/like_dao.dart';
import 'package:flutter_pink/http/dao/video_detail_dao.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/model/video_detail_mo.dart';
import 'package:flutter_pink/page/publish.dart';
import 'package:flutter_pink/provider/theme_provider.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:flutter_pink/widget/video_header.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:provider/provider.dart';
import 'package:underline_indicator/underline_indicator.dart';
import 'package:zefyrka/zefyrka.dart';

import 'comment_tab_page.dart';

class PostDetailPage extends StatefulWidget {
  final PostMo videoModel;

  const PostDetailPage(this.videoModel, {Key? key}) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage>
    with TickerProviderStateMixin {
  /// Allows to control the editor and the document.
  ZefyrController? _controllerContent;

  late TabController _controller;
  VideoDetailMo? videoDetailMo;
  late PostMo videoModel;
  List<PostMo> videoList = [];
  late TabController _tabController;
  late TextEditingController textEditingController;
  var categoryList = [
    "评论",
    "转发",
  ];

  @override
  void initState() {
    textEditingController = TextEditingController();
    _tabController = TabController(length: categoryList.length, vsync: this);
    //黑色状态栏
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: categoryList.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _controller.dispose();
    super.dispose();
  }

  NotusDocument _loadDocument(content) {
    return NotusDocument.fromJson(content);
  }

  Widget customZefyrEmbedBuilder(BuildContext context, EmbedNode node) {
    if (node.value.type.contains('image')) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          child: Image.network(node.value.data["source"], fit: BoxFit.fill),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(node.value.data["source"]);
            }));
          },
        ),
      );
    }

    return Container();
  }

  _tabBar() {
    var themeProvider = context.watch<ThemeProvider>();
    var unselectedLabelColor = Colors.black54;
    var _unselectedLabelColor =
        themeProvider.isDark() ? Colors.white70 : unselectedLabelColor;
    return TabBar(
      controller: _tabController,
      labelColor: primary,
      isScrollable: true,
      unselectedLabelColor: _unselectedLabelColor,
      labelStyle: TextStyle(fontSize: 12),
      indicator: UnderlineIndicator(
          strokeCap: StrokeCap.square,
          borderSide: BorderSide(color: primary, width: 3),
          insets: EdgeInsets.only(left: 15, right: 15)),
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          text: tab,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (videoModel.postType == "post") {
      final document = _loadDocument(jsonDecode(videoModel.content));
      _controllerContent = ZefyrController(document);
    }
    return Scaffold(
        body: Stack(
      children: [
        Container(
          color: Color.fromRGBO(242, 242, 242, 1),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 40,
                expandedHeight: 126,
                pinned: true,
                floating: false,
                snap: false,
                elevation: 0,
                shadowColor: Colors.white,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground
                  ],
                  collapseMode: CollapseMode.parallax,
                  titlePadding: EdgeInsets.only(left: 0),
                  background: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                      child: cachedImage(videoModel.cover)),
                ),
                leading: Container(
                  margin:
                      EdgeInsets.only(left: 13, right: 13, top: 6, bottom: 6),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                  ),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 16,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                actions: <Widget>[
                  Container(
                    width: 30,
                    margin:
                        EdgeInsets.only(left: 5, right: 5, top: 6, bottom: 6),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                    ),
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    color: Colors.white,
                    child: Column(
                      children: [
                        videoModel.postType == "post"
                            ? Container(
                                padding: EdgeInsets.only(
                                    top: 20, bottom: 10, left: 10, right: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  videoModel.title,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800),
                                ),
                              )
                            : Container(),
                        videoDetailMo != null
                            ? VideoHeader(
                                userMeta: videoModel.userMeta,
                                time: videoModel.updateTime,
                                isFollow: videoDetailMo!.isFollow,
                                isSelf: videoDetailMo!.isSelf,
                                onFollow: videoDetailMo!.isFollow
                                    ? _unFollow
                                    : _follow,
                              )
                            : Container(),
                        videoModel.postType == "post"
                            ? Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: ZefyrEditor(
                                  readOnly: true,
                                  showCursor: false,
                                  controller: _controllerContent!,
                                  embedBuilder: customZefyrEmbedBuilder,
                                ),
                              )
                            : Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: Text(videoModel.content),
                              ),
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 10, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${videoModel.view}阅读",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                              Text(
                                "文本禁止转载",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1,
              )),
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyTabBarDelegate(
                  child: _tabBar(),
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400.0,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  childAspectRatio: 0.5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return TabBarView(
                        controller: this._tabController,
                        children: [
                          CommentTabPage(
                            postId: videoModel.postId,
                          ),
                          Container(
                            color: Colors.white,
                            child: Text("暂无"),
                          ),
                        ]);
                  },
                  childCount: 1,
                ),
              )
            ],
          ),
        ),
        videoDetailMo != null
            ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: InkWell(
                          onTap: () {
                            HiOverlay.show(context,
                                child: Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: Column(
                                    children: [
                                      //空白区域点击关闭
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      )),
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
                                      )
                                    ],
                                  ),
                                ));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  hiSpace(width: 5),
                                  Text(
                                    "发送一条友善的消息",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  )
                                ],
                              ),
                              decoration:
                                  BoxDecoration(color: Colors.grey[100]),
                            ),
                          ),
                        ),
                      )),
                      Container(
                        padding: EdgeInsets.only(right: 12, left: 12),
                        child: Icon(
                          Icons.mail_outline,
                          size: 22,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(right: 12, left: 12),
                          child: InkWell(
                            onTap: _onFavorite,
                            child: Icon(
                              Icons.star_border_outlined,
                              size: 22,
                              color: videoDetailMo!.isFavorite
                                  ? primary
                                  : Colors.grey,
                            ),
                          )),
                      Container(
                        padding: EdgeInsets.only(right: 12, left: 12),
                        child: Icon(
                          Icons.share_outlined,
                          color: Colors.grey,
                          size: 22,
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(right: 12, left: 12),
                          child: InkWell(
                            onTap: _doLike,
                            child: Icon(
                              Icons.thumb_up_alt_outlined,
                              color:
                                  videoDetailMo!.isLike ? primary : Colors.grey,
                              size: 22,
                            ),
                          ))
                    ],
                  ),
                ))
            : Container()
      ],
    ));
  }

  _buildInput(BuildContext context) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(26)),
      child: TextField(
        autofocus: true,
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
        showWarnToast("评论不能为空");
      }
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    }
  }
}

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  StickyTabBarDelegate({
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 38,
          color: Colors.white,
          child: this.child,
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
