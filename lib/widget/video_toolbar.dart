import 'package:flutter/material.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/model/video_detail_mo.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/format_util.dart';
import 'package:flutter_pink/util/view_util.dart';

///视频点赞分享收藏等工具栏
class VideoToolBar extends StatelessWidget {
  final VideoDetailMo? detailMo;
  final PostMo videoModel;
  final VoidCallback? onLike;
  final VoidCallback? onUnLike;
  final VoidCallback? onCoin;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const VideoToolBar(
      {Key? key,
      required this.detailMo,
      required this.videoModel,
      this.onLike,
      this.onUnLike,
      this.onCoin,
      this.onFavorite,
      this.onShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 10),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(border: borderLine(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText(Icons.thumb_up_alt_rounded,
              videoModel.likes == 0 ? "喜欢" : videoModel.likes,
              onClick: onLike, tint: detailMo!.isLike ? true : false),
          _buildIconText(Icons.thumb_down_alt_rounded,
              videoModel.un_likes == 0 ? "讨厌" : videoModel.un_likes,
              onClick: onUnLike, tint: detailMo!.isUnLike ? true : false),
          _buildIconText(Icons.monetization_on, videoModel.coin,
              onClick: onCoin, tint: detailMo!.isCoin ? true : false),
          _buildIconText(Icons.grade_rounded, videoModel.favorite,
              onClick: onFavorite, tint: detailMo!.isFavorite),
          _buildIconText(Icons.share_rounded, videoModel.share,
              onClick: onShare),
        ],
      ),
    );
  }

  _buildIconText(IconData iconData, text, {onClick, bool tint = false}) {
    if (text is int) {
      text = countFormat(text);
    } else if (text == null) {
      text = "";
    }
    tint = tint == null ? false : tint;
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        child: Column(
          children: [
            Icon(
              iconData,
              size: 20,
              color: tint ? primary : Colors.grey,
            ),
            hiSpace(height: 5),
            Text(
              text,
              style: TextStyle(color: Colors.grey, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
