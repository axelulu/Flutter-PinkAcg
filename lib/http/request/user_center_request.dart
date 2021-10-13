import 'package:flutter_pink/http/request/base_request.dart';
import 'package:flutter_pink/util/hi_constants.dart';
import 'package:hi_net/request/hi_base_request.dart';

class UserCenterRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "${HiConstants.versionPath}/userCenter";
  }
}
