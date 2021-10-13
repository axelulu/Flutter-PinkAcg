import 'package:flutter/material.dart';
import 'package:flutter_pink/core/hi_base_tab_state.dart';
import 'package:flutter_pink/http/dao/dynamic_dao.dart';
import 'package:flutter_pink/model/dynamic_mo.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/widget/dynamic_large_card.dart';
import 'package:flutter_pink/widget/not_found.dart';

class DynamicTabPage extends StatefulWidget {
  final String slug;

  const DynamicTabPage({Key? key, required this.slug}) : super(key: key);

  @override
  _DynamicTabPageState createState() => _DynamicTabPageState();
}

class _DynamicTabPageState
    extends HiBaseTabState<DynamicMo, PostMo, DynamicTabPage> {
  @override
  // TODO: implement contentChild
  get contentChild => dataList.length > 0
      ? Container(
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemCount: dataList.length,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) => Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: DynamicLargeCard(videoModel: dataList[index]),
                  )),
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
    var result = await DynamicDao.get(widget.slug, size: 10, page: page);
    return result;
  }

  @override
  List<PostMo>? parseList(DynamicMo result) {
    return result.list;
  }
}
