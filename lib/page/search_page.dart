import 'package:flutter/material.dart';
import 'package:flutter_pink/page/search_tab_page.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/hi_tab.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:hi_net/core/hi_error.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  static var categoryList = [
    {"key": "all", "name": "全部"},
    {"key": "video", "name": "视频"},
    {"key": "post", "name": "文章"},
    {"key": "user", "name": "用户"},
  ];
  late TabController _controller;
  String searchWord = "";

  @override
  void initState() {
    _controller = TabController(length: categoryList.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SearchPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavigationBar(
            child: _appBar(),
            height: 50,
            color: Colors.white,
            statusStyle: StatusStyle.DARK_CONTENT,
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: bottomBoxShadow(context),
                    child: _tabBar(),
                  ),
                )
              ],
            ),
          ),
          Flexible(
              child: TabBarView(
            controller: _controller,
            children: categoryList.map((tab) {
              return SearchTabPage(
                type: tab["key"]!,
                word: searchWord,
              );
            }).toList(),
          ))
        ],
      ),
    );
  }

  _tabBar() {
    return HiTab(
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          text: tab["name"],
        );
      }).toList(),
      controller: _controller,
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      insets: 13,
    );
  }

  void loadData() async {
    try {} on NeedAuth catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.center,
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {});
                  },
                  onChanged: (value) {
                    searchWord = value;
                  },
                  decoration: InputDecoration(
                      hintText: "动漫游戏galgame",
                      hintStyle: TextStyle(fontSize: 12),
                      icon: Container(
                        width: 5,
                        child: Icon(Icons.search, color: Colors.grey),
                      ),
                      isCollapsed: true, //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0), //内容内边距，影响高度

                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
                decoration: BoxDecoration(color: Colors.grey[100]),
              ),
            ),
          )),
          Padding(
              padding: EdgeInsets.only(left: 12),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.grey),
                ),
              ))
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
