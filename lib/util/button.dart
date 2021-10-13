import 'package:flutter/material.dart';
import 'package:flutter_pink/util/view_util.dart';

import 'color.dart';

/// app头部按钮
Widget appBarButton(IconData icon, GestureTapCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.only(left: 12),
      child: Icon(
        icon,
        color: Colors.grey,
      ),
    ),
  );
}

/// 文章类型按钮
Widget postTypeButton(String text) {
  return Padding(
    padding: EdgeInsets.only(left: 2),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: primary, width: 1),
        color: Color.fromRGBO(255, 226, 226, 0.5),
      ),
      padding: EdgeInsets.only(left: 6, right: 6, bottom: 1, top: 1),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.red, fontSize: 8, fontWeight: FontWeight.w400),
      ),
    ),
  );
}

/// 文章发布页面菜单按钮
Widget menuButton(String name, VoidCallback onPressed,
    {bool isSelect = false}) {
  return TextButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        //设置按下时的背景颜色
        if (states.contains(MaterialState.pressed)) {
          return primary;
        }
        //默认不使用背景颜色
        if (isSelect) {
          return primary;
        } else {
          return null;
        }
      }),
      //定义文本的样式 这里设置的颜色是不起作用的
      textStyle:
          MaterialStateProperty.all(TextStyle(fontSize: 14, color: primary)),
      //设置按钮上字体与图标的颜色
      //foregroundColor: MaterialStateProperty.all(Colors.deepPurple),
      //更优美的方式来设置
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.focused) &&
              !states.contains(MaterialState.pressed)) {
            //获取焦点时的颜色
            return primary;
          } else if (states.contains(MaterialState.pressed)) {
            //按下时的颜色
            return Colors.white;
          }
          //默认状态使用灰色
          if (isSelect) {
            return Colors.white;
          } else {
            return primary;
          }
        },
      ),
      //设置水波纹颜色
      overlayColor: MaterialStateProperty.all(primary),
      //设置阴影  不适用于这里的TextButton
      elevation: MaterialStateProperty.all(0),
      //设置按钮内边距
      padding: MaterialStateProperty.all(
          EdgeInsets.only(top: 5, bottom: 5, left: 12, right: 12)),
      //设置按钮的大小
      minimumSize: MaterialStateProperty.all(Size(20, 20)),

      //设置边框
      side: MaterialStateProperty.all(BorderSide(color: primary, width: 1)),
      //外边框装饰 会覆盖 side 配置的样式
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
    ),
    onPressed: onPressed,
    child: Text(name),
  );
}

/// 发布弹窗按钮
Widget publishButton(String text, IconData icon, VoidCallback onPressed,
    {bool isSpace = false}) {
  return TextButton(
    onPressed: onPressed,
    child: isSpace
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
              ),
              hiSpace(width: 5),
              Text(
                text,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              )
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
              ),
              hiSpace(width: 5),
              Text(
                text,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              )
            ],
          ),
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
            return Colors.black;
          } else if (states.contains(MaterialState.pressed)) {
            //按下时的颜色
            return Colors.black;
          }
          //默认状态使用灰色
          return Colors.black;
        },
      ),
      //背景颜色
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        //设置按下时的背景颜色
        if (states.contains(MaterialState.pressed)) {
          return Colors.white;
        }
        //默认不使用背景颜色
        return Colors.white;
      }),
      //设置水波纹颜色
      overlayColor: MaterialStateProperty.all(Colors.white),
      //设置阴影  不适用于这里的TextButton
      elevation: MaterialStateProperty.all(0),
      //设置按钮内边距
      padding: MaterialStateProperty.all(EdgeInsets.only(
          left: 20,
          right: 20,
          top: isSpace ? 30 : 15,
          bottom: isSpace ? 30 : 15)),
      //设置按钮的大小
      minimumSize: MaterialStateProperty.all(Size(20, 20)),

      //外边框装饰 会覆盖 side 配置的样式
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
    ),
  );
}
