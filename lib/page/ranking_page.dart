import 'package:flutter/material.dart';
import 'package:flutter_pink/http/dao/ranking_dao.dart';
import 'package:flutter_pink/page/ranking_tab_page.dart';
import 'package:flutter_pink/util/view_util.dart';
import 'package:flutter_pink/widget/hi_tab.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with SingleTickerProviderStateMixin {
  static var tabs = [
    {"key": "likes", "name": "最热"},
    {"key": "update_time", "name": "最新"},
    {"key": "favorite", "name": "收藏"},
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
      body: Column(
        children: [
          _buildNavigationBar(),
          _buildTabView(),
        ],
      ),
    );
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
      child: Container(
        alignment: Alignment.center,
        child: _tabBar(),
        decoration: bottomBoxShadow(context),
      ),
    );
  }

  _buildTabView() {
    return Flexible(
      child: TabBarView(
        controller: _controller,
        children: tabs.map((tab) {
          return RankingTabPage(sort: tab['key'] as String);
        }).toList(),
      ),
    );
  }
}
