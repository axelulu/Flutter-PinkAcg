import 'package:flutter_pink/http/request/profile_request.dart';
import 'package:flutter_pink/model/user_center_mo.dart';
import 'package:hi_net/hi_net.dart';

class ProfileDao {
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    return UserMeta.fromJson(result["data"]);
  }
}
