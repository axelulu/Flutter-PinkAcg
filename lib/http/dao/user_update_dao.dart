import 'package:flutter_pink/http/request/user_update_request.dart';
import 'package:hi_net/hi_net.dart';

class UserUpdateDao {
  static update(String slug, String value) async {
    UserInfoUpdateRequest request = UserInfoUpdateRequest();
    request.add("slug", slug);
    request.add("value", value);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return result;
  }
}
