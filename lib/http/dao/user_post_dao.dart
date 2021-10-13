import 'package:flutter_pink/http/request/user_post_request.dart';
import 'package:flutter_pink/model/dynamic_mo.dart';
import 'package:hi_net/hi_net.dart';

class UserPostDao {
  static get(int userId, String type, int page, int size) async {
    UserPostRequest request = UserPostRequest();
    request.add("user_id", userId);
    request.add("post_type", type);
    request.add("page", page);
    request.add("size", size);
    var result = await HiNet.getInstance().fire(request);
    return DynamicMo.fromJson(result["data"]);
  }
}
