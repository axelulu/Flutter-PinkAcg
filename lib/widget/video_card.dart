import 'package:flutter/material.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/provider/theme_provider.dart';
import 'package:flutter_pink/util/bottom_sheet.dart';
import 'package:flutter_pink/util/format_util.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:provider/provider.dart';

class VideoCard extends StatelessWidget {
  final PostMo videoMo;
  const VideoCard({Key? key, required this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color textColor = themeProvider.isDark() ? Colors.white70 : Colors.black87;
    return SizedBox(
      height: 200,
      child: Card(
        // margin: EdgeInsets.only(left: 4, right: 4, bottom: 8),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
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
                HiNavigator.getInstance()
                    .onJumpTo(RouteStatus.video, args: {"videoMo": videoMo});
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [_itemImage(context), _infoText(textColor)],
              ),
            )),
      ),
    );
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cachedImage(videoMo.cover, width: size.width / 2 - 8, height: 120),
        Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
              decoration: BoxDecoration(
                  //渐变
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconText(Icons.ondemand_video, videoMo.view.toString()),
                  _iconText(Icons.favorite_border, videoMo.favorite.toString()),
                  _iconText(Icons.date_range_outlined, videoMo.updateTime,
                      isDate: true),
                ],
              ),
            ))
      ],
    );
  }

  _iconText(IconData? iconData, String count, {isDate = false}) {
    String views = "";
    if (isDate == false) {
      views = countFormat(int.parse(count));
    } else {
      views =
          formatDate(DateTime.parse("${videoMo.updateTime.substring(0, 19)}"));
    }
    return Row(
      children: [
        if (iconData != null)
          Icon(
            iconData,
            color: Colors.white,
            size: 12,
          ),
        Padding(
          padding: EdgeInsets.only(left: 3),
          child: Text(
            views,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        )
      ],
    );
  }

  _infoText(Color textColor) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            videoMo.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: textColor, fontSize: 12),
          ),
          _owner(textColor)
        ],
      ),
    ));
  }

  _owner(Color textColor) {
    var owner = videoMo.userMeta;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cachedImage(owner.avatar, width: 24, height: 24),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                owner.username,
                style: TextStyle(fontSize: 11, color: textColor),
              ),
            )
          ],
        ),
        Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        )
      ],
    );
  }
}
