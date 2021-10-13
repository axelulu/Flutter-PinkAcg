import 'package:flutter/material.dart';
import 'package:flutter_pink/core/hi_base_tab_state.dart';
import 'package:flutter_pink/http/dao/ranking_dao.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/model/ranking_mo.dart';
import 'package:flutter_pink/widget/not_found.dart';
import 'package:flutter_pink/widget/video_large_card.dart';

class RankingTabPage extends StatefulWidget {
  final String sort;

  const RankingTabPage({Key? key, required this.sort}) : super(key: key);

  @override
  _RankingTabPageState createState() => _RankingTabPageState();
}

class _RankingTabPageState
    extends HiBaseTabState<RankingMo, PostMo, RankingTabPage> {
  @override
  // TODO: implement contentChild
  get contentChild => dataList.length > 0
      ? Container(
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10),
              itemCount: dataList.length,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) =>
                  VideoLargeCard(videoModel: dataList[index])),
        )
      : Container(
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10),
              itemCount: 1,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) => NotFound()),
        );

  @override
  Future<RankingMo> getData(int page) async {
    var result = await RankingDao.get(widget.sort, size: 10, page: page);
    return result;
  }

  @override
  List<PostMo>? parseList(RankingMo result) {
    return result.list;
  }
}
