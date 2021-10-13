import 'package:flutter/material.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:hi_net/core/hi_error.dart';

///通用底层带分页和刷新的页面框架
///M为Dao返回数据模型，L为列表数据模型，T为具体widget
abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  List<L> dataList = [];
  int pageIndex = 1;
  bool loading = false;
  ScrollController scrollController = ScrollController();
  get contentChild;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      //最大高度减去当前高度
      var dis = scrollController.position.maxScrollExtent -
          scrollController.position.pixels;
      //距离不足300时加载更多
      if (dis < 300 &&
          !loading &&
          scrollController.position.maxScrollExtent != 0) {
        loadData(loadMore: true);
      }
    });
    loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
      color: primary,
      onRefresh: loadData,
      child: MediaQuery.removePadding(
          removeTop: true, context: context, child: contentChild),
    ));
  }

  ///获取对应页码的数据
  Future<M> getData(int pageIndex);

  ///从MO中解析出list数据
  List<L>? parseList(M result);

  Future<void> loadData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      loading = true;
      var result = await getData(currentIndex);
      setState(() {
        if (loadMore) {
          dataList = [...dataList, ...?parseList(result)];
          if (parseList(result)!.length != 0) {
            pageIndex++;
          }
        } else {
          dataList = parseList(result)!;
        }
      });
      Future.delayed(Duration(milliseconds: 500), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      loading = false;
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      loading = false;
      showWarnToast(e.message);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
