import 'package:flutter/material.dart';
import 'package:flutter_pink/core/hi_base_tab_state.dart';
import 'package:flutter_pink/http/dao/comment_dao.dart';
import 'package:flutter_pink/model/comment_mo.dart';
import 'package:flutter_pink/util/format_util.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/not_found.dart';

class CommentTabPage extends StatefulWidget {
  final int postId;

  const CommentTabPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentTabPageState createState() => _CommentTabPageState();
}

class _CommentTabPageState
    extends HiBaseTabState<CommentMo, CommentList, CommentTabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  // TODO: implement contentChild
  get contentChild => dataList.length > 0
      ? Container(
          child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: dataList.length,
              controller: scrollController,
              itemBuilder: (BuildContext context, int index) => Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: ClipRRect(
                                    child: cachedImage(
                                        dataList[index].owner.avatar,
                                        height: 30,
                                        width: 30),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dataList[index].owner.username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black54,
                                          fontSize: 12),
                                    ),
                                    hiSpace(height: 4),
                                    Text(
                                      formatDate(
                                        DateTime.parse(
                                          "${dataList[index].updatedTime.substring(0, 19)}",
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 50, top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dataList[index].content),
                                  hiSpace(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.thumb_up_alt_outlined,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      hiSpace(width: 10),
                                      Icon(
                                        Icons.thumb_down_alt_outlined,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      hiSpace(width: 10),
                                      Icon(
                                        Icons.mail_outline,
                                        size: 16,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                      )
                    ],
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
  Future<CommentMo> getData(int pageIndex) async {
    CommentMo result = await CommentDao.get(widget.postId, pageIndex, 10);
    return result;
  }

  @override
  List<CommentList>? parseList(CommentMo result) {
    return result.list;
  }
}
