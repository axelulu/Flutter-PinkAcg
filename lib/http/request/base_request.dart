import 'package:flutter_pink/http/dao/login_dao.dart';
import 'package:flutter_pink/util/hi_constants.dart';
import 'package:hi_net/request/hi_base_request.dart';

abstract class BaseRequest extends HiBaseRequest {
  @override
  String authority() {
    return "${HiConstants.domain}:${HiConstants.port}";
  }

  @override
  String url() {
    //是否需要登录
    if (needLogin()) {
      addHeader(
          HiConstants.Authorization, "Bearer " + LoginDao.getBoardingPass());
    }
    return super.url();
  }
}
