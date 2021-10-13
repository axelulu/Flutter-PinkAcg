import 'package:hi_net/request/hi_base_request.dart';

import 'hi_net_adapter.dart';

///测试适配器，mock数据
class MockAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) {
    // TODO: implement send
    return Future<HiNetResponse<T>>.delayed(Duration(milliseconds: 1000), () {
      return HiNetResponse(
          request: request,
          data: {"code": 0, "message": 'success'} as T,
          statusCode: 403);
    });
  }
}
