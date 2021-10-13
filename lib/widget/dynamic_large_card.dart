import 'package:flutter/material.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/util/bottom_sheet.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/format_util.dart';
import 'package:flutter_pink/util/view_util.dart';

class DynamicLargeCard extends StatelessWidget {
  final videoModel;
  const DynamicLargeCard({Key? key, this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onLongPress: () {
          moreHandleDialog(
              context,
              0.2,
              Container(
                color: Colors.white,
                height: 200,
              ));
        },
        onTap: () {
          switch (videoModel.postType) {
            case "post":
              HiNavigator.getInstance()
                  .onJumpTo(RouteStatus.post, args: {"videoMo": videoModel});
              break;
            case "video":
              HiNavigator.getInstance()
                  .onJumpTo(RouteStatus.video, args: {"videoMo": videoModel});
              break;
            case "dynamic":
              HiNavigator.getInstance()
                  .onJumpTo(RouteStatus.post, args: {"videoMo": videoModel});
              break;
          }
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(50)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: cachedImage(videoModel.userMeta.avatar,
                        height: 40, width: 40),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      videoModel.userMeta.username,
                      style: TextStyle(
                          color: primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800),
                    ),
                    hiSpace(height: 2),
                    Text(
                      "${formatDate(DateTime.parse("${videoModel.updateTime.substring(0, 19)}"))} · 进行了投稿",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                )),
                Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.all(0),
                    iconSize: 20,
                    color: Colors.grey,
                    icon: Icon(Icons.more_vert_sharp),
                    onPressed: () {
                      moreHandleDialog(
                          context,
                          0.2,
                          Container(
                            color: Colors.white,
                            height: 200,
                          ));
                    },
                  ),
                ),
              ],
            ),
            videoModel.postType == "dynamic" || videoModel.postType == "video"
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Text(
                      videoModel.content,
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                : Container(),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: cachedImage(videoModel.cover,
                  width: MediaQuery.of(context).size.width - 20, height: 200),
            ),
            videoModel.postType == "post" || videoModel.postType == "video"
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    child: Text(
                      videoModel.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _synamicIcon(Icons.reply_all_outlined),
                _synamicIcon(Icons.mail_outline),
                _synamicIcon(Icons.thumb_up_alt_outlined),
              ],
            )
          ],
        ),
      ),
    );
  }

  _synamicIcon(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.all(0),
        iconSize: 20,
        color: Colors.grey,
        icon: Icon(icon),
        onPressed: () {},
      ),
    );
  }
}
