import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pink/core/hi_state.dart';
import 'package:flutter_pink/db/hi_cache.dart';
import 'package:flutter_pink/http/dao/home_dao.dart';
import 'package:flutter_pink/http/dao/profile_dao.dart';
import 'package:flutter_pink/model/home_mo.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/model/profile_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/page/home_tab_page.dart';
import 'package:flutter_pink/page/profile_page.dart';
import 'package:flutter_pink/page/video_detail_page.dart';
import 'package:flutter_pink/provider/theme_provider.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/update.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/hi_tab.dart';
import 'package:flutter_pink/widget/loading_container.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:flutter_pink/widget/update.dart';
import 'package:hi_net/core/hi_error.dart';
import 'package:provider/provider.dart';
import 'package:r_upgrade/r_upgrade.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  var listener;
  late TabController _controller;
  List<CategoryMo> categoryList = [];
  List<PostMo> bannerList = [];
  String _avatar = "";

  bool _isLoading = true;
  late Widget _currentPage;
  bool update = false;
  String serverAndroidVersion = "";
  String serverAndroidUrl = "";
  String serverAndroidMsg = "";
  @override
  void initState() {
    super.initState();
    checkUpdate();
    WidgetsBinding.instance!.addObserver(this);
    _controller = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(this.listener = (current, pre) {
      this._currentPage = current.page;
      if (widget == current.page || current.page is HomePage) {
      } else if (widget == pre?.page || pre?.page is HomePage) {}
      if (pre?.page is VideoDetailPage && !(current.page is ProfilePage)) {
        var statusStyle = StatusStyle.DARK_CONTENT;
        changeStatusBar(color: Colors.white, statusStyle: statusStyle);
      }
    });
    loadData();
    _UserAvatar();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    HiNavigator.getInstance().removeListener(this.listener);
    _controller.dispose();
    super.dispose();
  }

  //监听系统dark mode变化
  @override
  void didChangePlatformBrightness() {
    context.read<ThemeProvider>().darModeChange();
    super.didChangePlatformBrightness();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //处于这种状态的应用程序应该假设它们可能在任何时候暂停
      case AppLifecycleState.inactive:
        break;
      //从后台切换前台，界面可见
      case AppLifecycleState.resumed:
        if (!(_currentPage is VideoDetailPage)) {
          changeStatusBar(
              color: Colors.white,
              statusStyle: StatusStyle.DARK_CONTENT,
              context: context);
        }
        break;
      //界面不可见，后台
      case AppLifecycleState.paused:
        break;
      //App结束调用
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromRGBO(242, 242, 242, 1),
      child: Stack(
        children: [
          LoadingContainer(
            child: Column(
              children: [
                NavigationBar(
                  child: _appBar(),
                  height: 50,
                  color: Colors.white,
                  statusStyle: StatusStyle.DARK_CONTENT,
                ),
                Container(
                  decoration: bottomBoxShadow(context),
                  child: _tabBar(),
                ),
                Flexible(
                    child: TabBarView(
                  controller: _controller,
                  children: categoryList.map((tab) {
                    return HomeTabPage(
                      categoryName: tab.categorySlug,
                      bannerList:
                          tab.categorySlug == "recommend" ? bannerList : null,
                    );
                  }).toList(),
                ))
              ],
            ),
            isLoading: _isLoading,
          ),
          (update && HiCache.getInstance()!.get("update_time") == null) ||
                  (update &&
                      HiCache.getInstance()!.get("update_time") <
                          new DateTime.now().millisecondsSinceEpoch)
              ? Update(
                  serverAndroidMsg: serverAndroidMsg,
                  serverAndroidVersion: serverAndroidVersion,
                  close: () {
                    setState(() {
                      update = false;
                      HiCache.getInstance()!.setInt("update_time",
                          new DateTime.now().millisecondsSinceEpoch + 86400000);
                    });
                  },
                  update: () async {
                    setState(() {
                      update = false;
                    });
                    await RUpgrade.upgrade(serverAndroidUrl,
                        fileName: 'app-release.apk',
                        isAutoRequestInstall: true);
                  },
                )
              : Container(),
        ],
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return HiTab(
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          text: tab.categoryName,
        );
      }).toList(),
      controller: _controller,
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      insets: 13,
    );
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get("recommend");
      if (result.categoryList != null) {
        _controller =
            TabController(length: result.categoryList.length, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList;
        bannerList = result.bannerList;
        _isLoading = false;
      });
    } on NeedAuth catch (e) {
      setState(() {
        _isLoading = false;
      });
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      setState(() {
        _isLoading = false;
      });
      showWarnToast(e.message);
    }
  }

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(4);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: cachedImage(_avatar, width: 32, height: 32),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: () {
                  HiNavigator.getInstance().onJumpTo(RouteStatus.search);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 32,
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.search, color: Colors.grey),
                  decoration: BoxDecoration(color: Colors.grey[100]),
                ),
              ),
            ),
          )),
          appBarButton(Icons.explore_outlined, () {}),
          appBarButton(Icons.mail_outline, () {}),
        ],
      ),
    );
  }

  _UserAvatar() async {
    try {
      ProfileMo result = await ProfileDao.get();
      setState(() {
        _avatar = result.avatar;
      });
    } on NeedAuth catch (e) {
      showToast(e.message);
    } on NeedLogin catch (e) {
      showToast(e.message);
    } on HiNetError catch (e) {
      showToast(e.message);
    }
  }

  void checkUpdate() async {
    Map res = await UpdateUtil.getUpgrade();
    if (res["update"] == true) {
      setState(() {
        update = true;
        serverAndroidVersion = res["version"];
        serverAndroidMsg = res["msg"];
        serverAndroidUrl = res["url"];
      });
    }
  }
}
