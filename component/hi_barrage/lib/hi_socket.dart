import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

import 'barrage_model.dart';

///负责与后端进行websocket通信
class HiSocket implements ISocket {
  final Map<String, dynamic> headers;
  static const _URL = "wss://api.devio.org/uapi/fa/barrage/";
  late IOWebSocketChannel _channel;
  late ValueChanged<List<BarrageModel>> _callBack;

  ///心跳间隔秒数，根据服务器实际timeout进行调整
  int _intervalSeconds = 50;

  HiSocket(this.headers);

  @override
  void close() {
    if (_channel != null) {
      _channel.sink.close();
    }
  }

  @override
  ISocket listen(ValueChanged<List<BarrageModel>> callBack) {
    _callBack = callBack;
    return this;
  }

  @override
  ISocket open(String vid) {
    _channel = IOWebSocketChannel.connect(_URL + vid,
        headers: headers, pingInterval: Duration(seconds: _intervalSeconds));
    _channel.stream.handleError((error) {
      print(error);
    }).listen((event) {
      _handleMessage(event);
    });
    return this;
  }

  @override
  ISocket send(String message) {
    _channel.sink.add(message);
    return this;
  }

  ///处理服务端的返回
  void _handleMessage(event) {
    var result = BarrageModel.fromJsonString(event);
    if (result != null && _callBack != null) {
      _callBack(result);
    }
  }
}

abstract class ISocket {
  ///和服务器建立连接
  ISocket open(String vid);

  ///发送弹幕
  ISocket send(String message);

  ///关闭连接
  void close();

  ///接受弹幕
  ISocket listen(ValueChanged<List<BarrageModel>> callBack);
}
