import 'package:flutter/material.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/format_util.dart';
import 'package:flutter_pink/util/view_util.dart';

import '../util/bottom_sheet.dart';

///关联视频，视频列表卡片
class VideoLargeCard extends StatelessWidget {
  final PostMo videoModel;

  const VideoLargeCard({Key? key, required this.videoModel}) : super(key: key);

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
            case "dynamic":
              HiNavigator.getInstance()
                  .onJumpTo(RouteStatus.post, args: {"videoMo": videoModel});
              break;
            case "video":
              HiNavigator.getInstance()
                  .onJumpTo(RouteStatus.video, args: {"videoMo": videoModel});
              break;
          }
        },
        child: Container(
          height: 106,
          decoration: BoxDecoration(border: borderLine(context, bottom: true)),
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            children: [_itemImage(context), _buildContent(context)],
          ),
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    double height = 90;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Stack(
        children: [
          cachedImage(videoModel.cover,
              width: height * (16 / 9), height: height),
          Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: EdgeInsets.only(bottom: 2, left: 4, right: 4),
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(2)),
                child: Text(
                  formatDate(DateTime.parse(
                      "${videoModel.updateTime.substring(0, 19)}")),
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  _buildContent(context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 5, left: 8, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            videoModel.postType == "dynamic"
                ? videoModel.content
                : videoModel.title,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          _buildBottomContent(context)
        ],
      ),
    ));
  }

  _buildBottomContent(context) {
    return Column(
      children: [
        _owner(),
        hiSpace(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                videoModel.postType != "video"
                    ? videoModel.postType == "dynamic"
                        ? postTypeButton("动态")
                        : postTypeButton("文章")
                    : Container(),
                hiSpace(width: 5),
                ...smallIconText(Icons.ondemand_video, videoModel.view),
                hiSpace(width: 5),
                ...smallIconText(Icons.list_alt, videoModel.reply),
              ],
            ),
            Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.all(0),
                iconSize: 15,
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
      ],
    );
  }

  _owner() {
    var owner = videoModel.userMeta;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.grey)),
          child: Text(
            "UP",
            style: TextStyle(
                color: Colors.grey, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        ),
        hiSpace(width: 2),
        Text(
          owner.username,
          style: TextStyle(fontSize: 11, color: Colors.grey),
        )
      ],
    );
  }
}
