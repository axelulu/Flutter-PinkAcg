import 'package:flutter/material.dart';
import 'package:flutter_pink/http/dao/ranking_dao.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/hi_tab.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';

import 'dynamic_tab_page.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage({Key? key}) : super(key: key);

  @override
  _DynamicPageState createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  static var tabs = [
    {"key": "video", "name": "视频"},
    {"key": "all", "name": "综合"},
  ];
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: tabs.length, vsync: this);
    RankingDao.get("likes");
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromRGBO(242, 242, 242, 1),
      child: Column(
        children: [
          _buildNavigationBar(),
          _buildTabView(),
        ],
      ),
    ));
  }

  _tabBar() {
    return HiTab(
      tabs: tabs.map<Tab>((e) {
        return Tab(
          text: e["name"],
        );
      }).toList(),
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      controller: _controller,
    );
  }

  _buildNavigationBar() {
    return NavigationBar(
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: bottomBoxShadow(context),
            child: _tabBar(),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 12),
                  child: appBarButton(Icons.post_add_outlined, () {
                    HiNavigator.getInstance().onJumpTo(RouteStatus.publish,
                        args: {"type": "dynamic"});
                  }),
                ),
              ],
            ),
            right: 0,
            bottom: 0,
            top: 0,
          )
        ],
      ),
    );
  }

  _buildTabView() {
    return Flexible(
      child: TabBarView(
        controller: _controller,
        children: tabs.map((tab) {
          return DynamicTabPage(slug: tab['key'] as String);
        }).toList(),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
