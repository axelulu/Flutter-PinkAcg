import 'package:flutter/material.dart';
import 'package:flutter_pink/util/color.dart';
import 'package:flutter_pink/util/view_util.dart';

///弹幕输入界面
class BarrageInput extends StatelessWidget {
  final VoidCallback onTabClose;
  final String text;

  const BarrageInput({Key? key, required this.onTabClose, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          //空白区域点击关闭
          Expanded(
              child: GestureDetector(
            onTap: () {
              if (onTabClose != null) {
                onTabClose();
              }
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
            ),
          )),
          SafeArea(
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  hiSpace(width: 15),
                  _buildInput(TextEditingController(), context),
                  _buildSendBtn(TextEditingController(), context)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildInput(
      TextEditingController textEditingController, BuildContext context) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(26)),
      child: TextField(
        autofocus: true,
        controller: textEditingController,
        onSubmitted: (value) {
          _send(value, context);
        },
        cursorColor: primary,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
          hintText: text,
        ),
      ),
    ));
  }

  ///发送消息
  void _send(String value, BuildContext context) {
    if (value.isNotEmpty) {
      if (onTabClose != null) onTabClose();
      Navigator.pop(context, value);
    }
  }

  _buildSendBtn(
      TextEditingController textEditingController, BuildContext context) {
    return InkWell(
      onTap: () {
        var text = textEditingController.text.isNotEmpty
            ? textEditingController.text.trim()
            : "";
        _send(text, context);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          Icons.send_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }
}
