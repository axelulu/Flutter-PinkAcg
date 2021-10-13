import 'package:hi_net/request/hi_base_request.dart';

import 'core/dio_adapter.dart';
import 'core/hi_error.dart';
import 'core/hi_net_adapter.dart';

class HiNet {
  HiNet._();
  static HiNet? _instance;
  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance!;
  }

  Future fire(HiBaseRequest request) async {
    late HiNetResponse response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
    } catch (e) {
      error = e;
    }
    if (response == null) {
      print(error);
    }
    var result = response.data;
    var status = response.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        return NeedLogin();
      case 403:
        return NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status!, result.toString(), data: result);
    }
  }

  Future<dynamic> send<T>(HiBaseRequest request) async {
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {}
}
