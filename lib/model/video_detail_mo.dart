import 'package:flutter_pink/model/post_mo.dart';

class VideoDetailMo {
  late bool isFavorite;
  late bool isSelf;
  late bool isFollow;
  late bool isCoin;
  late bool isLike;
  late bool isUnLike;
  late PostMo? postInfo;
  late List<PostMo>? postList;

  VideoDetailMo(
      {this.isFavorite = false,
      this.isSelf = false,
      this.isFollow = false,
      this.isCoin = false,
      this.isLike = false,
      this.isUnLike = false,
      this.postInfo,
      this.postList});

  VideoDetailMo.fromJson(Map<String, dynamic> json) {
    isFavorite = json['isFavorite'];
    isSelf = json['isSelf'];
    isFollow = json['isFollow'];
    isCoin = json['isCoin'];
    isLike = json['isLike'];
    isUnLike = json['isUnLike'];
    postInfo = (json['postInfo'] != null
        ? new PostMo.fromJson(json['postInfo'])
        : null)!;
    if (json['postList'] != null) {
      postList = <PostMo>[];
      json['postList'].forEach((v) {
        postList!.add(new PostMo.fromJson(v));
      });
    } else {
      postList = <PostMo>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFavorite'] = this.isFavorite;
    data['isSelf'] = this.isSelf;
    data['isFollow'] = this.isFollow;
    data['isCoin'] = this.isCoin;
    data['isLike'] = this.isLike;
    data['isUnLike'] = this.isUnLike;
    if (this.postInfo != null) {
      data['postInfo'] = this.postInfo!.toJson();
    }
    if (this.postList != null) {
      data['postList'] = this.postList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
