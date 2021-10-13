import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pink/db/hi_cache.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:vibration/vibration.dart';

/// 即时通讯设置未读消息红点
void noReadMsg(value) async {
  int num;
  if (HiCache.getInstance()!.get("contact_send_id_${value.userId}") != null &&
      HiCache.getInstance()!.get("contact_send_id_${value.userId}") != 0) {
    num = HiCache.getInstance()!.get("contact_send_id_${value.userId}");
  } else {
    num = 0;
  }
  HiCache.getInstance()!.setInt("contact_send_id_${value.userId}", num + 1);
  //检查是否支持振动
  bool? hasVi = await Vibration.hasVibrator();
  if (hasVi!) {
    Vibration.vibrate(duration: 200);
  }
}

/// contact顶部按钮
Widget headerTextButton(String text, IconData icon, Color color) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      color: Colors.white,
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          hiSpace(height: 5),
          Text(
            text,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          )
        ],
      ),
    ),
  );
}
