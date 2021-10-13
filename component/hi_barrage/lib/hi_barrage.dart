import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'barrage_item.dart';
import 'barrage_model.dart';
import 'barrage_view_util.dart';
import 'hi_socket.dart';
import 'ibarrage.dart';

enum BarrageStatus { play, pause }

class HiBarrage extends StatefulWidget {
  final int lineCount;
  final String vid;
  final int speed;
  final double top;
  final bool autoPlay;
  final Map<String, dynamic> headers;

  const HiBarrage(
      {Key? key,
      this.lineCount = 4,
      required this.vid,
      this.speed = 800,
      this.top = 0,
      this.autoPlay = false,
      required this.headers})
      : super(key: key);

  @override
  HiBarrageState createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  late HiSocket _hiSocket;
  late double _height;
  late double _width;
  List<BarrageItem> _barrageItemList = [];
  List<BarrageModel> _barrageModelList = [];

  //默认第几条弹幕
  int _barrageIndex = 0;
  Random _random = Random();
  BarrageStatus? _barrageStatus;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hiSocket = HiSocket(widget.headers);
    _hiSocket.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    if (_hiSocket != null) {
      _hiSocket.close();
    }
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = _width / 16 * 9;
    return Container(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          Container(),
        ]..addAll(_barrageItemList), //dart语法(放在上层)
      ),
    );
  }

  void _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      _barrageModelList.insertAll(0, modelList);
    } else {
      _barrageModelList.addAll(modelList);
    }
    //弹幕状态判断
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }
    //收到新弹幕后播放
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  @override
  void play() {
    _barrageStatus = BarrageStatus.play;
    if (_timer != null && _timer!.isActive) return;
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
      } else {
        _timer!.cancel();
      }
    });
  }

  void addBarrage(BarrageModel model) {
    double perRowHeight = 30;
    var line = _barrageIndex % widget.lineCount;
    _barrageIndex++;
    var top = line * perRowHeight + widget.top;
    //为每条弹幕生成一个id
    String id = '${_random.nextInt(10000)}:${model.content}';
    var item = BarrageItem(
      id: id,
      top: top,
      child: BarrageViewUtil.barrageView(model),
      onComplate: _onComplate,
    );
    _barrageItemList.add(item);
    setState(() {});
  }

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    _barrageModelList.clear();
    setState(() {});
    _timer!.cancel();
  }

  @override
  void send(String message) {
    if (message == null) return;
    _hiSocket.send(message);
    _handleMessage(
        [BarrageModel(content: message, vid: "-1", priority: 1, type: 1)]);
  }

  void _onComplate(value) {
    _barrageItemList.removeWhere((element) => element.id == value);
  }
}
