import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_pink/http/dao/follow_dao.dart';
import 'package:flutter_pink/http/dao/upload_dao.dart';
import 'package:flutter_pink/http/dao/user_center_dao.dart';
import 'package:flutter_pink/http/dao/user_update_dao.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/model/upload_mo.dart';
import 'package:flutter_pink/model/user_center_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/page/user_center_tab_page.dart';
import 'package:flutter_pink/provider/theme_provider.dart';
import 'package:flutter_pink/util/bottom_sheet.dart';
import 'package:flutter_pink/util/clipboard_tool.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/user_center_card.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:underline_indicator/underline_indicator.dart';

class UserCenterPage extends StatefulWidget {
  final UserMeta profileMo;

  const UserCenterPage(this.profileMo, {Key? key}) : super(key: key);

  @override
  _UserCenterPageState createState() => _UserCenterPageState();
}

class _UserCenterPageState extends State<UserCenterPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  UserCenterMo? userCenterMo;
  late UserMeta profileMo;
  var categoryList = [
    {"key": "main", "name": "主页"},
    {"key": "dynamic", "name": "动态"},
    {"key": "post", "name": "文章"},
    {"key": "video", "name": "视频"},
  ];
  double _headerHight = 138.0;
  bool _showDetail = false;
  bool _isHeader = true;
  int _isFollow = 3;

  @override
  void initState() {
    profileMo = widget.profileMo;
    _tabController = TabController(length: categoryList.length, vsync: this);
    _loadUserCenter();
    _loadFollowStatus();

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserCenter() async {
    try {
      UserCenterMo result = await UserCenterDao.get(profileMo.userId);
      setState(() {
        profileMo = result.user;
        userCenterMo = result;
      });
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    }
  }

  void _loadFollowStatus() async {
    try {
      var result = await FollowDao.status(profileMo.userId);
      setState(() {
        _isFollow = result["data"];
      });
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on NeedAuth catch (e) {
      showWarnToast(e.message);
    }
  }

  _tabBar() {
    var themeProvider = context.watch<ThemeProvider>();
    var unselectedLabelColor = Colors.black54;
    var _unselectedLabelColor =
        themeProvider.isDark() ? Colors.white70 : unselectedLabelColor;
    return TabBar(
      controller: _tabController,
      labelColor: primary,
      unselectedLabelColor: _unselectedLabelColor,
      labelStyle: TextStyle(fontSize: 12),
      indicator: UnderlineIndicator(
          strokeCap: StrokeCap.square,
          borderSide: BorderSide(color: primary, width: 3),
          insets: EdgeInsets.only(left: 15, right: 15)),
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          text: tab["name"],
        );
      }).toList(),
    );
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 40,
          expandedHeight: 126,
          pinned: true,
          floating: false,
          snap: false,
          elevation: 0,
          shadowColor: Colors.white,
          title: _isHeader
              ? Text(
                  profileMo.username,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                )
              : Container(),
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [
              StretchMode.zoomBackground,
              StretchMode.blurBackground
            ],
            collapseMode: CollapseMode.parallax,
            titlePadding: EdgeInsets.only(left: 0),
            background: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        child: cachedImage(profileMo.background)),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 35,
                          width: 35,
                          margin: EdgeInsets.only(bottom: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Color.fromRGBO(0, 0, 0, 0.3),
                          ),
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.wallpaper_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              ImageSource gallerySource = ImageSource.gallery;
                              final ImagePicker _picker = ImagePicker();
                              final file = await _picker.pickImage(
                                  source: gallerySource, imageQuality: 65);
                              if (file == null) return null;
                              UplaodMo url = await UploadDao.uploadImg(file);
                              setState(() {
                                profileMo.background = url.data;
                              });
                              _updateInfo("background", profileMo.background);
                            },
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
          leading: Container(
            margin: EdgeInsets.only(left: 13, right: 13, top: 6, bottom: 6),
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
              margin: EdgeInsets.only(left: 5, right: 5, top: 6, bottom: 6),
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
                  Icons.search,
                  color: Colors.white,
                  size: 16,
                ),
                onPressed: () {},
              ),
            ),
            Container(
              width: 30,
              margin: EdgeInsets.only(left: 5, right: 5, top: 6, bottom: 6),
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
        SliverFixedExtentList(
          itemExtent: _headerHight,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Stack(
                children: [
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(left: 30, top: 0),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey[100]!),
                        borderRadius: BorderRadius.circular(75),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: cachedImage(
                          profileMo.avatar,
                          height: 75,
                          width: 75,
                        ),
                      ),
                    ),
                    top: -10,
                  ),
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              color: Colors.white,
                              width: 230,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  mySpaceFollow("${profileMo.active}", "动态",
                                      onTap: () {}),
                                  longString(),
                                  mySpaceFollow("${profileMo.fans}", "粉丝",
                                      onTap: () {
                                    HiNavigator.getInstance().onJumpTo(
                                        RouteStatus.followFans,
                                        args: {"type": "fans"});
                                  }),
                                  longString(),
                                  mySpaceFollow("${profileMo.follows}", "关注",
                                      onTap: () {
                                    HiNavigator.getInstance().onJumpTo(
                                        RouteStatus.followFans,
                                        args: {"type": "follow"});
                                  }),
                                ],
                              ),
                            ),
                            _isFollow == 2
                                ? Container(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        HiNavigator.getInstance().onJumpTo(
                                            RouteStatus.accountInfo,
                                            args: {"profileMo": profileMo});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(top: 2, bottom: 2),
                                        margin: EdgeInsets.only(top: 5),
                                        alignment: Alignment.center,
                                        width: 210,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                width: 1, color: primary)),
                                        child: Text(
                                          "编辑资料",
                                          style: TextStyle(
                                              fontSize: 12, color: primary),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap:
                                          _isFollow == 1 ? _unFollow : _follow,
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(top: 2, bottom: 2),
                                        margin: EdgeInsets.only(top: 5),
                                        alignment: Alignment.center,
                                        width: 210,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: _isFollow == 1
                                                ? Colors.white
                                                : primary,
                                            border: Border.all(
                                                width: 1,
                                                color: _isFollow == 1
                                                    ? primary
                                                    : Colors.white)),
                                        child: Text(
                                          _isFollow == 1 ? "已关注" : "+ 关注",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: _isFollow == 1
                                                  ? primary
                                                  : Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ],
                    ),
                    top: 0,
                    right: 0,
                  ),
                  Positioned(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Container(
                                    child: Text(
                                      profileMo.username,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  profileMo.isVip == "1"
                                      ? Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(left: 8),
                                          padding: EdgeInsets.only(
                                              bottom: 2, left: 2, right: 2),
                                          decoration: BoxDecoration(
                                              color: primary,
                                              borderRadius:
                                                  BorderRadius.circular(2)),
                                          child: Text(
                                            "年度大会员",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            hiSpace(height: 6),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "LV5",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                            hiSpace(width: 6),
                                            Text(
                                              "${profileMo.exp}/28800",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 8),
                                            )
                                          ],
                                        ),
                                        hiSpace(height: 2),
                                        SizedBox(
                                          //限制进度条的高度
                                          height: 2.0,
                                          //限制进度条的宽度
                                          width: 100,
                                          child: LinearProgressIndicator(
                                              //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
                                              value: profileMo.exp / 28800,
                                              //背景颜色
                                              backgroundColor: Colors.grey,
                                              //进度颜色
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red)),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            setState(() {
                                              _showDetail = !_showDetail;
                                              if (_showDetail) {
                                                _headerHight = 178.0;
                                              } else {
                                                _headerHight = 138.0;
                                              }
                                            });
                                          },
                                          child: Text(
                                            _showDetail ? "收起" : "详情",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue),
                                          ),
                                        ))
                                  ],
                                )),
                            _showDetail
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 6, bottom: 6, left: 20),
                                        child: Text(
                                          profileMo.descr == ""
                                              ? "这个人很懒，什么都没写..."
                                              : profileMo.descr,
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                            child: Icon(
                                              profileMo.gender == 0
                                                  ? Icons.male_outlined
                                                  : Icons.female_outlined,
                                              color: profileMo.gender == 0
                                                  ? Colors.blue
                                                  : primary,
                                              size: 12,
                                            ),
                                            padding: EdgeInsets.only(
                                                top: 2,
                                                right: 2,
                                                bottom: 2,
                                                left: 2),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 8),
                                            child: InkWell(
                                              child: Text(
                                                "uid:${profileMo.userId}",
                                                style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              onLongPress: () {
                                                ClipboardTool.setDataToast(
                                                    '${profileMo.userId}');
                                              },
                                            ),
                                            padding: EdgeInsets.only(
                                                top: 2,
                                                right: 2,
                                                bottom: 2,
                                                left: 2),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                        hiSpace(height: 8),
                      ],
                    ),
                    top: 75,
                  ),
                ],
              );
            },
            childCount: 1,
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: StickyTabBarDelegate(
            child: _tabBar(),
          ),
        ),
        SliverFillRemaining(
          child: TabBarView(
              controller: _tabController,
              children: categoryList.map((value) {
                return value["key"]! == "main"
                    ? _homePage()
                    : UserCenterTabPage(
                        slug: value["key"]!,
                        userId: profileMo.userId,
                      );
              }).toList()),
        ),
      ],
    ));
  }

  _follow() async {
    try {
      var res = await FollowDao.get(profileMo.userId);
      if (res["code"] == 1000) {
        setState(() {
          _isFollow = 1;
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
      var res = await FollowDao.remove(profileMo.userId);
      if (res["code"] == 1000) {
        setState(() {
          _isFollow = 3;
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

  _homeTopBar(
      String name, int num, List<PostMo> posts, GestureTapCallback onTap) {
    return Container(
      height: 180,
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$name  $num",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: onTap,
                  child: Row(
                    children: [
                      Text(
                        "查看更多",
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      Icon(
                        Icons.chevron_right_outlined,
                        color: Colors.grey,
                        size: 18,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            children: posts.map((post) {
              return UserCenterCard(videoMo: post);
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _homePage() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: RefreshIndicator(
          color: primary,
          onRefresh: _loadUserCenter,
          child: userCenterMo != null
              ? ListView(
                  shrinkWrap: true,
                  children: [
                    userCenterMo!.starPostCount != 0
                        ? _homeTopBar("收藏", userCenterMo!.starPostCount,
                            userCenterMo!.starPosts, () {
                            moreHandleDialog(
                                context,
                                0.9,
                                Container(
                                  color: Colors.white,
                                  child: UserCenterTabPage(
                                    slug: "star",
                                    userId: profileMo.userId,
                                  ),
                                ));
                          })
                        : Container(),
                    userCenterMo!.coinPostCount != 0
                        ? _homeTopBar("投币", userCenterMo!.coinPostCount,
                            userCenterMo!.coinPosts, () {
                            moreHandleDialog(
                                context,
                                0.9,
                                Container(
                                  color: Colors.white,
                                  child: UserCenterTabPage(
                                    slug: "coin",
                                    userId: profileMo.userId,
                                  ),
                                ));
                          })
                        : Container(),
                    userCenterMo!.likePostCount != 0
                        ? _homeTopBar("喜欢", userCenterMo!.likePostCount,
                            userCenterMo!.likePosts, () {
                            moreHandleDialog(
                                context,
                                0.9,
                                Container(
                                  color: Colors.white,
                                  child: UserCenterTabPage(
                                    slug: "like",
                                    userId: profileMo.userId,
                                  ),
                                ));
                          })
                        : Container(),
                    userCenterMo!.unLikePostCount != 0
                        ? _homeTopBar("讨厌", userCenterMo!.unLikePostCount,
                            userCenterMo!.unLikePosts, () {
                            moreHandleDialog(
                                context,
                                0.9,
                                Container(
                                  color: Colors.white,
                                  child: UserCenterTabPage(
                                    slug: "unlike",
                                    userId: profileMo.userId,
                                  ),
                                ));
                          })
                        : Container(),
                    userCenterMo!.dynamicCount != 0
                        ? _homeTopBar("动态", userCenterMo!.dynamicCount,
                            userCenterMo!.dynamics, () {
                            setState(() {
                              _tabController.index = 1;
                            });
                          })
                        : Container(),
                    userCenterMo!.videoCount != 0
                        ? _homeTopBar("视频", userCenterMo!.videoCount,
                            userCenterMo!.videos, () {
                            setState(() {
                              _tabController.index = 3;
                            });
                          })
                        : Container(),
                    userCenterMo!.postCount != 0
                        ? _homeTopBar(
                            "文章", userCenterMo!.postCount, userCenterMo!.posts,
                            () {
                            setState(() {
                              _tabController.index = 2;
                            });
                          })
                        : Container()
                  ],
                )
              : Container(),
        ));
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
