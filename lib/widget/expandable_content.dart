import 'package:flutter/material.dart';
import 'package:flutter_pink/model/post_mo.dart';
import 'package:flutter_pink/util/view_util.dart';

class ExpandableContent extends StatefulWidget {
  final PostMo mo;

  const ExpandableContent({Key? key, required this.mo}) : super(key: key);

  @override
  _ExpandableContentState createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  bool _expand = false;
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _heightFactor = _controller.drive(_easeInTween);
    _controller.addListener(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        children: [
          _buildTitle(),
          Padding(padding: EdgeInsets.only(bottom: 8)),
          _buildInfo(),
          _buildDes()
        ],
      ),
    );
  }

  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(
            widget.mo.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
          Padding(padding: EdgeInsets.only(left: 15)),
          Icon(_expand
              ? Icons.keyboard_arrow_up_sharp
              : Icons.keyboard_arrow_down_sharp),
        ],
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  _buildInfo() {
    var style = TextStyle(fontSize: 12, color: Colors.grey);
    var dataStr = widget.mo.createTime.length > 10
        ? widget.mo.createTime.substring(5, 10)
        : widget.mo.createTime;
    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.mo.view),
        Padding(padding: EdgeInsets.only(left: 10)),
        ...smallIconText(Icons.list_alt, widget.mo.reply),
        Padding(padding: EdgeInsets.only(left: 10)),
        Text(
          "$dataStr",
          style: style,
        )
      ],
    );
  }

  _buildDes() {
    var child = _expand
        ? Text(
            widget.mo.content,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )
        : null;
    return AnimatedBuilder(
        animation: _controller.view,
        child: child,
        builder: (BuildContext context, Widget? child) {
          return Align(
            heightFactor: _heightFactor.value,
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 8),
              child: child,
            ),
          );
        });
  }
}
