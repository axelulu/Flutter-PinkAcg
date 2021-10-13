import 'package:flutter/material.dart';
import 'package:flutter_pink/http/dao/user_update_dao.dart';
import 'package:flutter_pink/model/user_center_mo.dart';
import 'package:flutter_pink/util/button.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/toast.dart';
import 'package:flutter_pink/widget/navigation_bar.dart';
import 'package:hi_net/core/hi_error.dart';

class AccountInfoDescPage extends StatefulWidget {
  final UserMeta profileMo;

  const AccountInfoDescPage(this.profileMo, {Key? key}) : super(key: key);

  @override
  _AccountInfoDescPageState createState() => _AccountInfoDescPageState();
}

class _AccountInfoDescPageState extends State<AccountInfoDescPage>
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
          alignment: Alignment.center,
          child: Text(
            "个性签名",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        )),
        InkWell(
            onTap: () async {
              try {
                var result =
                    await UserUpdateDao.update("descr", widget.profileMo.descr);
                if (result["code"] == 1000) {
                  showToast("修改成功");
                  Navigator.of(context).pop();
                } else {
                  showToast("修改失败");
                }
              } on NeedLogin catch (e) {
                showWarnToast(e.message);
              } on NeedAuth catch (e) {
                showWarnToast(e.message);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(right: 12),
              child: Text(
                "保存",
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ))
      ],
    );
  }

  _buildTabView() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
      child: TextField(
        maxLines: 5,
        maxLength: 60,
        cursorColor: primary,
        cursorHeight: 20,
        onChanged: (value) {
          setState(() {
            widget.profileMo.descr = value;
          });
        },
        style: TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
          isCollapsed: true,
          //内容内边距，影响高度
          border: OutlineInputBorder(
            ///用来配置边框的样式
            borderSide: BorderSide.none,
          ),
        ),
        controller: TextEditingController.fromValue(TextEditingValue(
            text: '${widget.profileMo.descr}', //判断keyword是否为空
            // 保持光标在最后

            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: '${widget.profileMo.descr}'.length)))),
      ),
    );
  }
}
