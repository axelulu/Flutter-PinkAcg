import 'package:flutter/material.dart';
import 'package:flutter_pink/core/hi_base_tab_state.dart';
import 'package:flutter_pink/http/dao/home_dao.dart';
import 'package:flutter_pink/model/home_mo.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/widget/dynamic_card.dart';
import 'package:flutter_pink/widget/hi_banner.dart';
import 'package:flutter_pink/widget/not_found.dart';
import 'package:flutter_pink/widget/post_card.dart';
import 'package:flutter_pink/widget/video_card.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<PostMo>? bannerList;

  const HomeTabPage({Key? key, this.categoryName = "", this.bannerList})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends HiBaseTabState<HomeMo, PostMo, HomeTabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _banner() {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
      child: HiBanner(widget.bannerList),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  // TODO: implement contentChild
  get contentChild => dataList.length > 0
      ? Container(
          padding: EdgeInsets.only(left: 5, right: 5),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            children: [
              if (widget.bannerList != null)
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(bottom: 0),
                  child: _banner(),
                ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 10),
                  itemCount: dataList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.95),
                  itemBuilder: (BuildContext context, int index) {
                    return dataList[index].postType == "video"
                        ? VideoCard(videoMo: dataList[index])
                        : dataList[index].postType == "post"
                            ? PostCard(videoMo: dataList[index])
                            : DynamicCard(videoMo: dataList[index]);
                  })
            ],
          ),
        )
      : Container(
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 10),
                  itemCount: 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1, childAspectRatio: 0.95),
                  itemBuilder: (BuildContext context, int index) {
                    return NotFound();
                  })
            ],
          ),
        );

  @override
  Future<HomeMo> getData(int pageIndex) async {
    HomeMo result =
        await HomeDao.get(widget.categoryName, page: pageIndex, size: 10);
    return result;
  }

  @override
  List<PostMo>? parseList(HomeMo result) {
    return result.postList;
  }
}
