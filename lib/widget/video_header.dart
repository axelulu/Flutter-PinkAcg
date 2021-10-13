import 'package:flutter/material.dart';
import 'package:flutter_pink/model/user_center_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/format_util.dart';
import 'package:flutter_pink/util/view_util.dart';

///详情页 作者widget
class VideoHeader extends StatelessWidget {
  final UserMeta? userMeta;
  final String time;
  final bool isFollow;
  final bool isSelf;
  final VoidCallback onFollow;
  const VideoHeader(
      {Key? key,
      this.userMeta,
      required this.time,
      required this.isFollow,
      required this.isSelf,
      required this.onFollow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String Time = formatDate(DateTime.parse("${time.substring(0, 19)}"));
    return Container(
      padding: EdgeInsets.only(top: 15, right: 15, left: 15),
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
                  child: cachedImage(userMeta!.avatar, height: 30, width: 30),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userMeta!.username,
                        style: TextStyle(
                            fontSize: 13,
                            color: primary,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            "$Time",
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                          hiSpace(width: 5),
                          Text(
                            "·",
                            style: TextStyle(color: Colors.grey),
                          ),
                          hiSpace(width: 5),
                          Text(
                            "${countFormat(userMeta!.fans)}粉丝",
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          !isSelf
              ? MaterialButton(
                  onPressed: onFollow,
                  color: !isFollow ? primary : Colors.grey[100],
                  height: 22,
                  minWidth: 50,
                  padding: EdgeInsets.only(bottom: 2),
                  child: Text(
                    !isFollow ? "+ 关注" : "已关注",
                    style: TextStyle(
                        color: !isFollow ? Colors.white : primary,
                        fontSize: 10),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
