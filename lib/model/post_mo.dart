import 'package:flutter_pink/model/user_center_mo.dart';

class PostMo {
  late UserMeta userMeta;
  late int postId;
  late int authorId;
  late String postType;
  late String categorySlug;
  late String title;
  late String content;
  late int reply;
  late int favorite;
  late int likes;
  late int un_likes;
  late int coin;
  late int share;
  late int view;
  late String cover;
  late String video;
  late String download;
  late String createTime;
  late String updateTime;

  PostMo(
      {required this.postId,
      required this.userMeta,
      required this.authorId,
      required this.postType,
      required this.categorySlug,
      required this.title,
      required this.content,
      required this.reply,
      required this.favorite,
      required this.likes,
      required this.un_likes,
      required this.coin,
      required this.share,
      required this.view,
      required this.cover,
      required this.video,
      required this.download,
      required this.createTime,
      required this.updateTime});

  PostMo.fromJson(Map<String, dynamic> json) {
    userMeta =
        (json['owner'] != null ? new UserMeta.fromJson(json['owner']) : null)!;
    postId = json['post_id'];
    authorId = json['author_id'];
    postType = json['post_type'];
    categorySlug = json['category_slug'];
    title = json['title'];
    content = json['content'];
    reply = json['reply'];
    favorite = json['favorite'];
    likes = json['likes'];
    un_likes = json['un_likes'];
    coin = json['coin'];
    share = json['share'];
    view = json['view'];
    cover = json['cover'];
    video = json['video'];
    download = json['download'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userMeta != null) {
      data['owner'] = this.userMeta.toJson();
    }
    data['post_id'] = this.postId;
    data['author_id'] = this.authorId;
    data['post_type'] = this.postType;
    data['category_slug'] = this.categorySlug;
    data['title'] = this.title;
    data['content'] = this.content;
    data['reply'] = this.reply;
    data['favorite'] = this.favorite;
    data['likes'] = this.likes;
    data['un_likes'] = this.un_likes;
    data['coin'] = this.coin;
    data['share'] = this.share;
    data['view'] = this.view;
    data['cover'] = this.cover;
    data['video'] = this.video;
    data['download'] = this.download;
    data['create_time'] = this.createTime;
    data['update_time'] = this.updateTime;
    return data;
  }
}
