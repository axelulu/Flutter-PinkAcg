import 'package:flutter_pink/http/request/home_request.dart';
import 'package:flutter_pink/model/home_mo.dart';
import 'package:hi_net/hi_net.dart';

class HomeDao {
  static get(String categoryName, {int size = 10, int page = 1}) async {
    HomeRequest request = HomeRequest();
    request
        .add("category_slug", categoryName)
        .add("page", page)
        .add("size", size)
        .add("cSize", size);
    var result = await HiNet.getInstance().fire(request);
    return HomeMo.fromJson(result['data']);
  }
}
