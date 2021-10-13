import 'package:flutter_pink/http/request/follow_request.dart';
import 'package:hi_net/hi_net.dart';

class FollowDao {
  static get(int followId) async {
    FollowRequest request = FollowRequest();
    request.add("follow_id", followId);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static remove(int followId) async {
    UnFollowRequest request = UnFollowRequest();
    request.add("follow_id", followId);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static status(int followId) async {
    FollowStatusRequest request = FollowStatusRequest();
    request.pathParams = followId;
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return result;
  }
}
