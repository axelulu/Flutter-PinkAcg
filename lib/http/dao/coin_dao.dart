import 'package:flutter_pink/http/request/coin_request.dart';
import 'package:hi_net/hi_net.dart';

class CoinDao {
  static get(int postId) async {
    CoinRequest request = CoinRequest();
    request.add("coin", "1").add("post_id", postId);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
