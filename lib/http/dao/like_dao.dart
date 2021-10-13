import 'package:flutter_pink/http/request/like_request.dart';
import 'package:hi_net/hi_net.dart';

class LikeDao {
  static get(int postId) async {
    LikeRequest request = LikeRequest();
    request.add("post_id", postId);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static remove(int postId) async {
    UnLikeRequest request = UnLikeRequest();
    request.add("post_id", postId);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
