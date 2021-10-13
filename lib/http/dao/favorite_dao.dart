import 'package:flutter_pink/http/request/favorite_request.dart';
import 'package:hi_net/hi_net.dart';

class FavoriteDao {
  static get(int postId) async {
    FavoriteRequest request = FavoriteRequest();
    request.add("post_id", postId);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }

  static remove(int postId) async {
    UnFavoriteRequest request = UnFavoriteRequest();
    request.add("post_id", postId);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
