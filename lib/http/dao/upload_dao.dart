import 'package:dio/dio.dart';
import 'package:flutter_pink/http/request/upload_request.dart';
import 'package:flutter_pink/model/upload_mo.dart';
import 'package:hi_net/hi_net.dart';
import 'package:image_picker/image_picker.dart';

class UploadDao {
  // 上传图片
  static uploadImg(XFile imgfile) async {
    UploadRequest request = UploadRequest();
    String path = imgfile.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(path, filename: name)});
    request.file = formData;
    var result = await HiNet.getInstance().fire(request);
    print(result);
    return UplaodMo.fromJson(result);
  }

  // 上传视频
  static uploadVideo(XFile imgfile) async {
    UploadRequest request = UploadRequest();
    String path = imgfile.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formData = FormData.fromMap(
        {"file": await MultipartFile.fromFile(path, filename: name)});
    request.file = formData;
    var result = await HiNet.getInstance().fire(request);
    return UplaodMo.fromJson(result);
  }
}
