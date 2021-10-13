import 'package:flutter_pink/http/request/comment_request.dart';
import 'package:flutter_pink/model/comment_mo.dart';
import 'package:hi_net/hi_net.dart';

class CommentDao {
  static get(int postId, int page, int size) async {
    CommentRequest request = CommentRequest();
    request.add("page", page);
    request.add("size", size);
    request.add("post_id", postId);
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return CommentMo.fromJson(result["data"]);
  }

  static post(int postId, String content, String type,
      {String parent = "0"}) async {
    CommentCreateRequest request = CommentCreateRequest();
    request.add("post_id", postId);
    request.add("content", content);
    request.add("type", type);
    request.add("parent", parent);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
