import 'package:flutter_pink/http/request/category_request.dart';
import 'package:flutter_pink/model/category_mo.dart';
import 'package:hi_net/hi_net.dart';

class CategoryDao {
  static get(int size) async {
    CategoryRequest request = CategoryRequest();
    request.add("size", size);
    var result = await HiNet.getInstance().fire(request);
    return CategoryModel.fromJson(result);
  }
}
