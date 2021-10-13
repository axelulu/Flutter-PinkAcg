import 'package:flutter_pink/http/request/search_request.dart';
import 'package:flutter_pink/model/search.dart';
import 'package:hi_net/hi_net.dart';

class SearchDao {
  static get(String type, String word,
      {String postType = "post", int page = 1, int size = 10}) async {
    SearchRequest request = SearchRequest();
    if (type == "all") {
      request
          .add("type", "all")
          .add("word", word)
          .add("page", page)
          .add("size", size);
    } else if (type == "post" || type == "video") {
      request
          .add("type", type)
          .add("word", word)
          .add("page", page)
          .add("size", size);
    } else if (type == "user") {
      request
          .add("type", type)
          .add("word", word)
          .add("page", page)
          .add("size", size);
    }
    var result = await HiNet.getInstance().fire(request);
    return SearchPostMo.fromJson(result["data"]);
  }
}
