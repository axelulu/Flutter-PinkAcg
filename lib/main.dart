import 'package:flutter/material.dart';
import 'package:flutter_pink/db/hi_cache.dart';
import 'package:flutter_pink/model/contact.dart';
import 'package:flutter_pink/navigator/bottom_navigator.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/page/account_info_desc_page.dart';
import 'package:flutter_pink/page/account_info_page.dart';
import 'package:flutter_pink/page/account_info_username_page.dart';
import 'package:flutter_pink/page/chat.dart';
import 'package:flutter_pink/page/contact.dart';
import 'package:flutter_pink/page/dark_mode_page.dart';
import 'package:flutter_pink/page/dynamic_page.dart';
import 'package:flutter_pink/page/follow_fans_page.dart';
import 'package:flutter_pink/page/login_page.dart';
import 'package:flutter_pink/page/post_detail_page.dart';
import 'package:flutter_pink/page/publish.dart';
import 'package:flutter_pink/page/registration_page.dart';
import 'package:flutter_pink/page/search_page.dart';
import 'package:flutter_pink/page/setting_page.dart';
import 'package:flutter_pink/page/star_coin_like_post_page.dart';
import 'package:flutter_pink/page/user_center_page.dart';
import 'package:flutter_pink/page/video_detail_page.dart';
import 'package:flutter_pink/provider/hi_provider.dart';
import 'package:flutter_pink/provider/theme_provider.dart';
import 'package:flutter_pink/provider/websocket_provider.dart';
import 'package:flutter_pink/util/contact.dart';
import 'package:flutter_pink/util/hi_defend.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:provider/provider.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

import 'http/dao/login_dao.dart';
import 'model/post_mo.dart';
import 'model/user_center_mo.dart';

void main() {
  HiDefend().run(BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  _BiliAppState createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  int? id;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //初始化组件化基础库, 所有友盟业务SDK都必须调用此初始化接口。
    UmengCommonSdk.initCommon(
        '615ee900ac9567566e8af254', '615ee900ac9567566e8af254', 'Umeng');
    //在app启动前进行初始化
    return FutureBuilder<HiCache>(
        //进行初始化
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          //定义route
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(
                  routerDelegate: _routeDelegate,
                )
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          return MultiProvider(
            providers: topProviders,
            child: Consumer<ThemeProvider>(builder: (BuildContext context,
                ThemeProvider themeProvider, Widget? child) {
              return MaterialApp(
                title: "PinkAcg",
                home: widget,
                theme: themeProvider.getTheme(),
                darkTheme: themeProvider.getTheme(isDarkMode: true),
                themeMode: themeProvider.getThemeMode(),
                debugShowCheckedModeBanner: false,
              );
            }),
          );
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  // 为Navigator设置一个Key，必要的时候可以通过navigatorKey.currentState来获取到NavigatorState对象
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    //实现路由跳转逻辑
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.video || routeStatus == RouteStatus.post) {
        this.videoModel = args!['videoMo'];
      }
      if (routeStatus == RouteStatus.publish) {
        this.publishType = args!['type'];
      }
      if (routeStatus == RouteStatus.userCenter) {
        this.profileMo = args!['profileMo'];
      }
      if (routeStatus == RouteStatus.accountInfo ||
          routeStatus == RouteStatus.accountInfoDesc ||
          routeStatus == RouteStatus.accountInfoUsername) {
        this.profileMo = args!['profileMo'];
      }
      if (routeStatus == RouteStatus.chat) {
        this.currentUserMeta = args!['currentUserMeta'];
        this.sendUserMeta = args['sendUserMeta'];
      }
      if (routeStatus == RouteStatus.followFans) {
        this.followType = args!['type'];
      }
      if (routeStatus == RouteStatus.starCoinLikePost) {
        this.postType = args!['post_type'];
        this.userId = args['user_id'];
      }
      notifyListeners();
    }));
  }

  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  PostMo? videoModel;
  UserMeta? profileMo;

  //
  ContactList? sendUserMeta;
  UserMeta? currentUserMeta;

  //
  String? publishType;
  String? followType;

  //
  String? postType;
  int? userId;

  bool get hasLogin =>
      LoginDao.getBoardingPass() != null && LoginDao.getBoardingPass() != "";

  @override
  Widget build(BuildContext context) {
    //先在启动时初始化
    if (hasLogin) {
      final model = Provider.of<WebSocketProvider>(context, listen: false);
      model.open();
      //接收未读消息
      model.listen((value) {
        noReadMsg(value);
      });
    }

    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      //要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      //tips具体规则可以根据需要进行调整，这里要求栈中只允许又一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    switch (routeStatus) {
      case RouteStatus.home:
        //跳转首页时将栈中其他页面进行出栈，因为首页不可回退
        pages.clear();
        page = pageWrap(BottomNavigator());
        break;
      case RouteStatus.darkMode:
        page = pageWrap(DarkModePage());
        break;
      case RouteStatus.video:
        page = pageWrap(VideoDetailPage(videoModel!));
        break;
      case RouteStatus.post:
        page = pageWrap(PostDetailPage(videoModel!));
        break;
      case RouteStatus.registration:
        page = pageWrap(RegistrationPage());
        break;
      case RouteStatus.dynamic:
        page = pageWrap(DynamicPage());
        break;
      case RouteStatus.contact:
        page = pageWrap(ContactPage());
        break;
      case RouteStatus.chat:
        page = pageWrap(ChatPage(currentUserMeta!, sendUserMeta!));
        break;
      case RouteStatus.search:
        page = pageWrap(SearchPage());
        break;
      case RouteStatus.publish:
        page = pageWrap(PublishPage(publishType!));
        break;
      case RouteStatus.setting:
        page = pageWrap(SettingPage());
        break;
      case RouteStatus.login:
        page = pageWrap(LoginPage());
        break;
      case RouteStatus.unknown:
        page = pageWrap(LoginPage());
        break;
      case RouteStatus.userCenter:
        page = pageWrap(UserCenterPage(profileMo!));
        break;
      case RouteStatus.starCoinLikePost:
        page = pageWrap(StarCoinLikePostPage(postType!, userId!));
        break;
      case RouteStatus.followFans:
        page = pageWrap(FollowFansPage(followType!));
        break;
      case RouteStatus.accountInfo:
        page = pageWrap(AccountInfoPage(profileMo!));
        break;
      case RouteStatus.accountInfoDesc:
        page = pageWrap(AccountInfoDescPage(profileMo!));
        break;
      case RouteStatus.accountInfoUsername:
        page = pageWrap(AccountInfoUsernamePage(profileMo!));
        break;
    }
    //重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    //通知路由变化
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;

    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (route.settings is MaterialPage) {
              //登录页未登录返回拦截
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showToast("请先登录");
                  return false;
                }
              }
            }
            //执行返回操作
            if (!route.didPop(result)) {
              return false;
            }
            var tempPages = [...pages];
            pages.removeLast();
            //通知路由变化
            HiNavigator.getInstance().notify(pages, tempPages);
            return true;
          },
        ),
        onWillPop: () async => !await navigatorKey.currentState!.maybePop());
  }

  //路由拦截
  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else {
      return _routeStatus;
    }
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {}
}

///定义路由数据，path
class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";
// BiliRoutePath.detail() : location = "/detail";
}

///创建页面
pageWrap(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}
