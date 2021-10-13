import 'package:flutter/material.dart';
import 'package:flutter_nested/flutter_nested.dart';
import 'package:flutter_pink/core/hi_base_tab_state.dart';
import 'package:flutter_pink/http/dao/search_dao.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/model/search.dart';
import 'package:flutter_pink/widget/not_found.dart';
import 'package:flutter_pink/widget/post_card.dart';
import 'package:flutter_pink/widget/video_card.dart';

class SearchTabPage extends StatefulWidget {
  final String type;
  final String word;

  const SearchTabPage({Key? key, required this.type, required this.word})
      : super(key: key);

  @override
  SearchTabPageState createState() => SearchTabPageState();
}

class SearchTabPageState
    extends HiBaseTabState<SearchPostMo, PostMo, SearchTabPage> {
  String word = "";

  @override
  void initState() {
    // TODO: implement initState
    word = widget.word;
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant SearchTabPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      word = widget.word;
      loadData();
    });
  }

  @override
  // TODO: implement contentChild
  get contentChild => dataList.length > 0
      ? HiNestedScrollView(
          itemCount: dataList.length,
          controller: scrollController,
          padding: EdgeInsets.only(top: 8, right: 8, left: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.95),
          itemBuilder: (BuildContext context, int index) {
            if (widget.type == "post") {
              if (dataList[index].postType == "post") {
                return PostCard(videoMo: dataList[index]);
              } else {
                return dataList[index].postType == "video"
                    ? VideoCard(videoMo: dataList[index])
                    : PostCard(videoMo: dataList[index]);
              }
            } else if (widget.type == "video") {
              if (dataList[index].postType == "video") {
                return VideoCard(videoMo: dataList[index]);
              } else {
                return dataList[index].postType == "video"
                    ? VideoCard(videoMo: dataList[index])
                    : PostCard(videoMo: dataList[index]);
              }
            } else {
              return dataList[index].postType == "video"
                  ? VideoCard(videoMo: dataList[index])
                  : PostCard(videoMo: dataList[index]);
            }
          })
      : HiNestedScrollView(
          itemCount: 1,
          controller: scrollController,
          padding: EdgeInsets.only(top: 8, right: 8, left: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.95),
          itemBuilder: (BuildContext context, int index) {
            return NotFound();
          });

  @override
  Future<SearchPostMo> getData(int pageIndex) async {
    SearchPostMo result =
        await SearchDao.get(widget.type, word, page: pageIndex, size: 10);
    return result;
  }

  @override
  List<PostMo>? parseList(SearchPostMo result) {
    return result.post;
  }
}
