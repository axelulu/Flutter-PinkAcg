import 'package:flutter_pink/http/request/follow_list_request.dart';
import 'package:flutter_pink/model/follow_list_mo.dart';
import 'package:hi_net/hi_net.dart';

class FollowListDao {
  static followList(int page) async {
    FollowListRequest request = FollowListRequest();
    request.add("page", page);
    var result = await HiNet.getInstance().fire(request);
    return FansListMo.fromJson(result['data']);
  }

  static fansList(int page) async {
    FansListRequest request = FansListRequest();
    request.add("page", page);
    var result = await HiNet.getInstance().fire(request);
    return FansListMo.fromJson(result['data']);
  }
}
