import 'package:flutter_pink/db/hi_cache.dart';
import 'package:flutter_pink/http/request/base_request.dart';
import 'package:flutter_pink/http/request/login_request.dart';
import 'package:flutter_pink/http/request/registration_request.dart';
import 'package:flutter_pink/util/hi_constants.dart';
import 'package:hi_net/hi_net.dart';

class LoginDao {
  static login(String userName, String password) {
    return _send(userName, password);
  }

  static registration(String userName, String password, String rePassword) {
    return _send(userName, password, rePassword: rePassword);
  }

  static _send(String userName, String password, {rePassword}) async {
    BaseRequest request;
    if (rePassword != null) {
      request = RegistrationRequest();
      request
          .add("username", userName)
          .add("password", password)
          .add("re_password", rePassword);
    } else {
      request = LoginRequest();
      request.add("username", userName).add("password", password);
    }
    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == 1000 && result['data'] != null) {
      //保存登录令牌
      HiCache.getInstance()!
          .setString(HiConstants.Authorization, result['data']);
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance()?.get(HiConstants.Authorization);
  }
}
