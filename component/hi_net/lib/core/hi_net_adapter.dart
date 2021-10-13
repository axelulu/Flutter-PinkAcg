import 'dart:convert';

import 'package:hi_net/request/hi_base_request.dart';

///网络请求抽象类
abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request);
}

///统一网络层返回格式
class HiNetResponse<T> {
  T? data;
  HiBaseRequest request;
  int? statusCode;
  String? statusMessage;
  late dynamic extra;

  HiNetResponse(
      {this.data,
      required this.request,
      this.statusCode,
      this.statusMessage,
      this.extra});

  @override
  String toString() {
    if (data is Map) {
      return jsonEncode(data);
    }
    return data.toString();
  }
}
