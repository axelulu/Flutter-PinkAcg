import 'package:flutter/material.dart';
import 'package:flutter_pink/page/user_center_tab_page.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';

class StarCoinLikePostPage extends StatefulWidget {
  final String postType;
  final int userId;

  const StarCoinLikePostPage(this.postType, this.userId, {Key? key})
      : super(key: key);

  @override
  _StarCoinLikePostPageState createState() => _StarCoinLikePostPageState();
}

class _StarCoinLikePostPageState extends State<StarCoinLikePostPage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
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

  _buildNavigationBar() {
    return NavigationBar(
      child: Container(
        alignment: Alignment.center,
        child: _tabBar(),
      ),
    );
  }

  _tabBar() {
    return Row(
      children: [
        appBarButton(Icons.arrow_back_ios_outlined, () {
          Navigator.of(context).pop();
        }),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(right: 30),
          alignment: Alignment.center,
          child: Text(_title()),
        )),
      ],
    );
  }

  _buildTabView() {
    return Expanded(
      child: UserCenterTabPage(
        slug: widget.postType,
        userId: widget.userId,
      ),
    );
  }

  String _title() {
    var title;
    if (widget.postType == "star") {
      title = "收藏";
    } else if (widget.postType == "like") {
      title = "喜欢";
    } else if (widget.postType == "unlike") {
      title = "不喜欢";
    } else if (widget.postType == "coin") {
      title = "投币";
    } else if (widget.postType == "dynamic") {
      title = "动态";
    } else if (widget.postType == "video") {
      title = "视频";
    } else if (widget.postType == "post") {
      title = "文章";
    }
    return title;
  }
}
