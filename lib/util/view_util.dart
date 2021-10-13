import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/page/profile_page.dart';
import 'package:flutter_pink/page/video_detail_page.dart';
import 'package:flutter_pink/provider/theme_provider.dart';
import 'package:flutter_pink/util/format_util.dart';
import 'package:flutter_pink/util/hi_constants.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:provider/provider.dart';

import 'color.dart';

/// 带缓存的image
Widget cachedImage(String url, {double width = 200, double height = 150}) {
  return CachedNetworkImage(
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (BuildContext context, String url) =>
          Image.asset('assets/images/logo.png'),
      errorWidget: (
        BuildContext context,
        String url,
        dynamic error,
      ) =>
          Image.asset('assets/images/logo.png'),
      imageUrl: HiConstants.ossDomain + '/' + url);
}

/// 黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent,
      ]);
}

/// 修改状态栏
void changeStatusBar(
    {color: Colors.white,
    StatusStyle statusStyle: StatusStyle.DARK_CONTENT,
    BuildContext? context}) {
  if (context != null) {
    // fix Tried to listen to a value exposed with provider, from outside of the widget tree.
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (themeProvider.isDark()) {
      statusStyle = StatusStyle.LIGHT_CONTENT;
      color = HiColor.dark_bg;
    }
  }
  var page = HiNavigator.getInstance().getCurrent()?.page;
  // fix Android切换 profile页面状态栏变白问题
  if (page is ProfilePage) {
    color = Colors.transparent;
  } else if (page is VideoDetailPage) {
    color = Colors.black;
    statusStyle = StatusStyle.LIGHT_CONTENT;
  }
  // 沉浸式状态栏样式
  var brightness;
  if (Platform.isIOS) {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT
        ? Brightness.dark
        : Brightness.light;
  } else {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT
        ? Brightness.light
        : Brightness.dark;
  }
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ),
  );
}

/// 带文字的小图标
smallIconText(IconData iconData, var text) {
  var style = TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countFormat(text);
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    Padding(padding: EdgeInsets.only(right: 2)),
    Text("$text", style: style),
  ];
}

/// border线
borderLine(BuildContext context, {bottom: true, top: false}) {
  BorderSide borderSide = BorderSide(width: 0.3, color: Colors.grey);
  return Border(
      bottom: bottom ? borderSide : BorderSide.none,
      top: top ? borderSide : BorderSide.none);
}

/// 空格
SizedBox hiSpace({double height: 0.5, double width: 1}) {
  return SizedBox(
    height: height,
    width: width,
  );
}

/// 底部阴影
BoxDecoration? bottomBoxShadow(BuildContext context) {
  var themeProvider = context.watch<ThemeProvider>();
  if (themeProvider.isDark()) return null;
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey[100]!,
        offset: Offset(0, 5), //xy轴偏移
        blurRadius: 5.0, //阴影模糊程度
        spreadRadius: 1, //阴影扩散程度
      )
    ],
  );
}

/// 个人空间粉丝关注
mySpaceFollow(String num, String label, {required GestureTapCallback onTap}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            "$num",
            style: TextStyle(fontSize: 14),
          ),
          hiSpace(height: 2),
          Text(
            "$label",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        ],
      ),
    ),
  );
}

/// 竖线
longString(
    {double width = 0.5, double height = 20, Color color = Colors.grey}) {
  return SizedBox(
    width: width,
    height: height,
    child: DecoratedBox(
      decoration: BoxDecoration(color: color),
    ),
  );
}
