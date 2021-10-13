import 'package:flutter/material.dart';
import 'package:flutter_pink/navigator/hi_navigator.dart';
import 'package:flutter_pink/page/contact.dart';
import 'package:flutter_pink/page/dynamic_page.dart';
import 'package:flutter_pink/page/home_page.dart';
import 'package:flutter_pink/page/profile_page.dart';
import 'package:flutter_pink/page/ranking_page.dart';
import 'package:flutter_pink/util/color.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  static int initialPage = 0;
  final PageController _controller = PageController(initialPage: initialPage);
  late List<Widget> _pages;
  bool _hasBuild = false;

  @override
  Widget build(BuildContext context) {
    _pages = [
      HomePage(
        onJumpTo: (index) => _onJumpTo(index, pageChange: false),
      ),
      RankingPage(),
      DynamicPage(),
      ContactPage(),
      ProfilePage()
    ];
    if (!_hasBuild) {
      //页面第一次打开时通知打开的是哪个tab
      HiNavigator.getInstance()
          .onBottomTabChange(initialPage, _pages[initialPage]);
      _hasBuild = true;
    }
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: _pages,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _activeColor,
        items: [
          _bottomItem("首页", Icons.home, 0),
          _bottomItem("排行", Icons.local_fire_department_outlined, 1),
          _bottomItem("动态", Icons.sports_volleyball_outlined, 2),
          _bottomItem("消息", Icons.notifications_outlined, 3),
          _bottomItem("我的", Icons.account_circle_outlined, 4)
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        label: title);
  }

  _onJumpTo(int index, {pageChange = false}) {
    if (!pageChange) {
      //让PageView展示对应的tab
      _controller.jumpToPage(index);
    } else {
      HiNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
