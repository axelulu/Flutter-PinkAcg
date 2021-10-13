import 'package:flutter_pink/http/request/base_request.dart';
import 'package:flutter_pink/util/hi_constants.dart';
import 'package:hi_net/request/hi_base_request.dart';

class RegistrationRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    // TODO: implement httpMethod
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    // TODO: implement needLogin
    return false;
  }

  @override
  String path() {
    // TODO: implement path
    return '${HiConstants.versionPath}/signup';
  }
}
