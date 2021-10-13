import 'package:flutter/material.dart';
import 'package:flutter_pink/navigator/bottom_navigator.dart';
import 'package:flutter_pink/page/account_info_desc_page.dart';
import 'package:flutter_pink/page/account_info_page.dart';
import 'package:flutter_pink/page/account_info_username_page.dart';
import 'package:flutter_pink/page/chat.dart';
import 'package:flutter_pink/page/contact.dart';
import 'package:flutter_pink/page/dark_mode_page.dart';
import 'package:flutter_pink/page/dynamic_page.dart';
import 'package:flutter_pink/page/follow_fans_page.dart';
import 'package:flutter_pink/page/home_page.dart';
import 'package:flutter_pink/page/login_page.dart';
import 'package:flutter_pink/page/post_detail_page.dart';
import 'package:flutter_pink/page/publish.dart';
import 'package:flutter_pink/page/registration_page.dart';
import 'package:flutter_pink/page/search_page.dart';
import 'package:flutter_pink/page/setting_page.dart';
import 'package:flutter_pink/page/star_coin_like_post_page.dart';
import 'package:flutter_pink/page/user_center_page.dart';
import 'package:flutter_pink/page/video_detail_page.dart';

typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo? pre);

///创建页面
pageWrap(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}

///获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

///自定义路由封装 路由状态
enum RouteStatus {
  login,
  registration,
  dynamic,
  contact,
  chat,
  home,
  video,
  post,
  search,
  publish,
  setting,
  userCenter,
  followFans,
  darkMode,
  starCoinLikePost,
  accountInfo,
  accountInfoDesc,
  accountInfoUsername,
  unknown,
}

///获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is DarkModePage) {
    return RouteStatus.darkMode;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.video;
  } else if (page.child is PostDetailPage) {
    return RouteStatus.post;
  } else if (page.child is DynamicPage) {
    return RouteStatus.dynamic;
  } else if (page.child is ContactPage) {
    return RouteStatus.contact;
  } else if (page.child is ChatPage) {
    return RouteStatus.chat;
  } else if (page.child is SearchPage) {
    return RouteStatus.search;
  } else if (page.child is PublishPage) {
    return RouteStatus.publish;
  } else if (page.child is SettingPage) {
    return RouteStatus.setting;
  } else if (page.child is UserCenterPage) {
    return RouteStatus.userCenter;
  } else if (page.child is FollowFansPage) {
    return RouteStatus.followFans;
  } else if (page.child is StarCoinLikePostPage) {
    return RouteStatus.starCoinLikePost;
  } else if (page.child is AccountInfoPage) {
    return RouteStatus.accountInfo;
  } else if (page.child is AccountInfoDescPage) {
    return RouteStatus.accountInfoDesc;
  } else if (page.child is AccountInfoUsernamePage) {
    return RouteStatus.accountInfoUsername;
  } else {
    return RouteStatus.unknown;
  }
}

///路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

///监听路由页面跳转
///感知当前页面是否被压后台

class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;

  RouteJumpListener? _routeJump;
  List<RouteChangeListener> _listeners = [];

  //首页底部tab
  RouteStatusInfo? _bottomTab;
  RouteStatusInfo? _current;

  HiNavigator._();

  static HiNavigator getInstance() {
    if (_instance == null) {
      _instance = HiNavigator._();
    }
    return _instance!;
  }

  RouteStatusInfo? getCurrent() {
    return _current;
  }

  ///首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
  }

  ///注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  ///监听路由页面跳转
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  ///移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  ///通知路由页面变化
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    if (current.page is BottomNavigator && _bottomTab != null) {
      current = _bottomTab!;
    }
    _listeners.forEach((listener) {
      listener(current, _current);
    });
    _current = current;
  }
}

///抽象类供HiNavigator实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

///定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}
