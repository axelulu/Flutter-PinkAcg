import 'package:flutter_pink/http/request/user_center_request.dart';
import 'package:flutter_pink/model/user_center_mo.dart';
import 'package:hi_net/hi_net.dart';

class UserCenterDao {
  static get(int userId) async {
    UserCenterRequest request = UserCenterRequest();
    request.pathParams = userId;
    var result = await HiNet.getInstance().fire(request);
    return UserCenterMo.fromJson(result["data"]);
  }
}
