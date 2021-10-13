import 'package:flutter_pink/http/request/contact_request.dart';
import 'package:flutter_pink/model/contact.dart';
import 'package:hi_net/hi_net.dart';

class ContactDao {
  static get() async {
    ContactRequest request = ContactRequest();
    var result = await HiNet.getInstance().fire(request);
    return ContactMo.fromJson(result["data"]);
  }

  static post(String sid) async {
    ContactAddRequest request = ContactAddRequest();
    request.add("send_id", sid);
    var result = await HiNet.getInstance().fire(request);
    return result;
  }
}
