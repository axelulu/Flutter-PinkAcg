import 'package:flutter/material.dart';
import 'package:flutter_pink/core/hi_base_tab_state.dart';
import 'package:flutter_pink/http/dao/user_post_dao.dart';
import 'package:flutter_pink/model/dynamic_mo.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/widget/dynamic_large_card.dart';
import 'package:flutter_pink/widget/not_found.dart';
import 'package:flutter_pink/widget/video_large_card.dart';

class UserCenterTabPage extends StatefulWidget {
  final String slug;
  final int userId;

  const UserCenterTabPage({Key? key, required this.slug, required this.userId})
      : super(key: key);

  @override
  _UserCenterTabPageState createState() => _UserCenterTabPageState();
}

class _UserCenterTabPageState
    extends HiBaseTabState<DynamicMo, PostMo, UserCenterTabPage> {
  @override
  // TODO: implement contentChild
  get contentChild => dataList.length > 0
      ? Container(
          color: Color.fromRGBO(242, 242, 242, 1),
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: dataList.length,
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) => dataList[index]
                            .postType ==
                        "dynamic" &&
                    widget.slug == "dynamic"
                ? Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: DynamicLargeCard(videoModel: dataList[index]))
                : Container(child: VideoLargeCard(videoModel: dataList[index])),
          ),
        )
      : Container(
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: 1,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) => NotFound()),
        );

  @override
  Future<DynamicMo> getData(int page) async {
    DynamicMo result =
        await UserPostDao.get(widget.userId, widget.slug, page, 10);
    return result;
  }

  @override
  List<PostMo>? parseList(DynamicMo result) {
    return result.list;
  }
}
