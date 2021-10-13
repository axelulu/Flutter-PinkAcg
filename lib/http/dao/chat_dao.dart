import 'package:flutter_pink/http/request/chat_request.dart';
import 'package:flutter_pink/model/chat_mo.dart';
import 'package:hi_net/hi_net.dart';

class ChatDao {
  static get(int sid) async {
    ChatRequest request = ChatRequest();
    request.pathParams = sid;
    var result = await HiNet.getInstance().fire(request);
    return ChatList.fromJson(result["data"]);
  }
}
