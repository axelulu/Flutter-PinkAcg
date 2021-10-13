import 'package:flutter_pink/http/request/ranking_request.dart';
import 'package:flutter_pink/model/ranking_mo.dart';
import 'package:hi_net/hi_net.dart';

class RankingDao {
  static get(String ranking, {int page = 1, size = 10}) async {
    RankingRequest request = RankingRequest();
    request.add("ranking", ranking).add("page", page).add("size", size);
    var result = await HiNet.getInstance().fire(request);
    return RankingMo.fromJson(result["data"]);
  }
}
