import 'package:flutter_pink/http/request/dynamic_request.dart';
import 'package:flutter_pink/model/dynamic_mo.dart';
import 'package:hi_net/hi_net.dart';

class DynamicDao {
  static get(String dynamic, {int page = 1, size = 10}) async {
    DynamicRequest request = DynamicRequest();
    request.add("dynamic", dynamic).add("page", page).add("size", size);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return DynamicMo.fromJson(result["data"]);
  }
}
