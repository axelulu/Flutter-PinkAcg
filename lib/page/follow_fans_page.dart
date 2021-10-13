import 'package:flutter/material.dart';
import 'package:flutter_pink/http/dao/follow_dao.dart';
import 'package:flutter_pink/http/dao/follow_list_dao.dart';
import 'package:flutter_pink/model/follow_list_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:flutter_pink/widget/not_found.dart';
import 'package:hi_net/core/hi_error.dart';

class FollowFansPage extends StatefulWidget {
  final String followType;

  const FollowFansPage(this.followType, {Key? key}) : super(key: key);

  @override
  _FollowFansPageState createState() => _FollowFansPageState();
}

class _FollowFansPageState extends State<FollowFansPage>
    with SingleTickerProviderStateMixin {
  List<FansList> fansListMo = [];
  ScrollController scrollController = ScrollController();
  int pageIndex = 1;
  bool loading = false;

  @override
  void initState() {
    _loadData();
    scrollController.addListener(() {
      //最大高度减去当前高度
      var dis = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;
      //距离不足300时加载更多
      if (dis < 300 &&
          !loading &&
          scrollController.position.maxScrollExtent != 0) {
        _loadData(loadMore: true);
      }
    });
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
          child: Text(widget.followType == "fans" ? "粉丝" : "关注"),
        )),
      ],
    );
  }

  _buildTabView() {
    return fansListMo != null
        ? Expanded(
            child: RefreshIndicator(
              color: primary,
              onRefresh: _loadData,
              child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: fansListMo.length > 0
                      ? ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          itemCount: fansListMo.length,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) =>
                              _userListMeta(fansListMo[index].userMeta,
                                  isFollow: fansListMo[index].isFollow,
                                  index: index))
                      : ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          itemCount: 1,
                          controller: scrollController,
                          itemBuilder: (BuildContext context, int index) =>
                              NotFound())),
            ),
          )
        : NotFound();
  }

  Future<void> _loadData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      loading = true;
      FansListMo result;
      if (widget.followType == "fans") {
        result = await FollowListDao.fansList(currentIndex);
      } else {
        result = await FollowListDao.followList(currentIndex);
      }
      setState(() {
        if (loadMore) {
          fansListMo = [...fansListMo, ...result.list];
        } else {
          fansListMo = result.list;
        }
      });
      Future.delayed(Duration(milliseconds: 500), () {
        loading = false;
      });
    } on NeedLogin catch (e) {
      loading = false;
      showWarnToast(e.message);
    } on NeedAuth catch (e) {
      loading = false;
      showWarnToast(e.message);
    }
  }

  _follow(userId) async {
    try {
      var res = await FollowDao.get(userId);
      if (res["code"] == 1000) {
        showToast("关注成功!");
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

  _unFollow(userId) async {
    try {
      var res = await FollowDao.remove(userId);
      if (res["code"] == 1000) {
        showToast("取消关注成功!");
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

  _userListMeta(userMeta, {isFollow, index}) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  HiNavigator.getInstance().onJumpTo(RouteStatus.userCenter,
                      args: {"profileMo": userMeta, "type": "other_user"});
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child:
                          cachedImage(userMeta.avatar, height: 40, width: 40),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userMeta.username,
                            style: TextStyle(
                                fontSize: 13,
                                color: primary,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                userMeta.descr != ""
                                    ? userMeta.descr
                                    : "这个人很懒，什么都没写!",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isFollow != null
                  ? MaterialButton(
                      onPressed: !isFollow
                          ? () {
                              _follow(userMeta.userId);
                              setState(() {
                                fansListMo[index].isFollow =
                                    !fansListMo[index].isFollow;
                              });
                            }
                          : () {
                              _unFollow(userMeta.userId);
                              setState(() {
                                fansListMo[index].isFollow =
                                    !fansListMo[index].isFollow;
                              });
                            },
                      color: !isFollow ? primary : Colors.grey[100],
                      height: 24,
                      minWidth: 50,
                      child: Text(
                        !isFollow ? "+ 关注" : "已关注",
                        style: TextStyle(
                            color: !isFollow ? Colors.white : primary,
                            fontSize: 13),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        Divider(
          height: 0.5,
        )
      ],
    );
  }
}
