import 'package:flutter_pink/model/post_mo.dart';

class UserCenterMo {
  late int coinPostCount;
  late List<PostMo> coinPosts;
  late int dynamicCount;
  late List<PostMo> dynamics;
  late int likePostCount;
  late List<PostMo> likePosts;
  late int postCount;
  late List<PostMo> posts;
  late int starPostCount;
  late List<PostMo> starPosts;
  late int unLikePostCount;
  late List<PostMo> unLikePosts;
  late UserMeta user;
  late int videoCount;
  late List<PostMo> videos;

  UserCenterMo(
      {required this.coinPostCount,
      required this.coinPosts,
      required this.dynamicCount,
      required this.dynamics,
      required this.likePostCount,
      required this.likePosts,
      required this.postCount,
      required this.posts,
      required this.starPostCount,
      required this.starPosts,
      required this.unLikePostCount,
      required this.unLikePosts,
      required this.user,
      required this.videoCount,
      required this.videos});

  UserCenterMo.fromJson(Map<String, dynamic> json) {
    coinPostCount = json['coinPostCount'];
    if (json['coinPosts'] != null) {
      coinPosts = <PostMo>[];
      json['coinPosts'].forEach((v) {
        coinPosts.add(new PostMo.fromJson(v));
      });
    } else {
      coinPosts = <PostMo>[];
    }
    dynamicCount = json['dynamicCount'];
    if (json['dynamics'] != null) {
      dynamics = <PostMo>[];
      json['dynamics'].forEach((v) {
        dynamics.add(new PostMo.fromJson(v));
      });
    } else {
      dynamics = <PostMo>[];
    }
    likePostCount = json['likePostCount'];
    if (json['likePosts'] != null) {
      likePosts = <PostMo>[];
      json['likePosts'].forEach((v) {
        likePosts.add(new PostMo.fromJson(v));
      });
    } else {
      likePosts = <PostMo>[];
    }
    postCount = json['postCount'];
    if (json['posts'] != null) {
      posts = <PostMo>[];
      json['posts'].forEach((v) {
        posts.add(new PostMo.fromJson(v));
      });
    } else {
      posts = <PostMo>[];
    }
    starPostCount = json['starPostCount'];
    if (json['starPosts'] != null) {
      starPosts = <PostMo>[];
      json['starPosts'].forEach((v) {
        starPosts.add(new PostMo.fromJson(v));
      });
    } else {
      starPosts = <PostMo>[];
    }
    unLikePostCount = json['unLikePostCount'];
    if (json['unLikePosts'] != null) {
      unLikePosts = <PostMo>[];
      json['unLikePosts'].forEach((v) {
        unLikePosts.add(new PostMo.fromJson(v));
      });
    } else {
      unLikePosts = <PostMo>[];
    }
    user = (json['user'] != null ? new UserMeta.fromJson(json['user']) : null)!;
    videoCount = json['videoCount'];
    if (json['videos'] != null) {
      videos = <PostMo>[];
      json['videos'].forEach((v) {
        videos.add(new PostMo.fromJson(v));
      });
    } else {
      videos = <PostMo>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coinPostCount'] = this.coinPostCount;
    if (this.coinPosts != null) {
      data['coinPosts'] = this.coinPosts.map((v) => v.toJson()).toList();
    }
    data['dynamicCount'] = this.dynamicCount;
    if (this.dynamics != null) {
      data['dynamics'] = this.dynamics.map((v) => v.toJson()).toList();
    }
    data['likePostCount'] = this.likePostCount;
    if (this.likePosts != null) {
      data['likePosts'] = this.likePosts.map((v) => v.toJson()).toList();
    }
    data['postCount'] = this.postCount;
    if (this.posts != null) {
      data['posts'] = this.posts.map((v) => v.toJson()).toList();
    }
    data['starPostCount'] = this.starPostCount;
    if (this.starPosts != null) {
      data['starPosts'] = this.starPosts.map((v) => v.toJson()).toList();
    }
    data['unLikePostCount'] = this.unLikePostCount;
    if (this.unLikePosts != null) {
      data['unLikePosts'] = this.unLikePosts.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['videoCount'] = this.videoCount;
    if (this.videos != null) {
      data['videos'] = this.videos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserMeta {
  late int userId;
  late String avatar;
  late String background;
  late String username;
  late String descr;
  late String email;
  late int fans;
  late int active;
  late int follows;
  late int coin;
  late int phone;
  late int exp;
  late int gender;
  late String birth;
  late String isVip;

  UserMeta(
      {required this.userId,
      required this.avatar,
      required this.background,
      required this.username,
      required this.descr,
      required this.email,
      required this.fans,
      required this.active,
      required this.follows,
      required this.coin,
      required this.phone,
      required this.exp,
      required this.gender,
      required this.birth,
      required this.isVip});

  UserMeta.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    avatar = json['avatar'];
    background = json['background'];
    username = json['username'];
    descr = json['descr'];
    email = json['email'];
    fans = json['fans'];
    active = json['active'];
    follows = json['follows'];
    coin = json['coin'];
    phone = json['phone'];
    exp = json['exp'];
    gender = json['gender'];
    birth = json['birth'];
    isVip = json['is_vip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['avatar'] = this.avatar;
    data['background'] = this.background;
    data['username'] = this.username;
    data['descr'] = this.descr;
    data['email'] = this.email;
    data['fans'] = this.fans;
    data['active'] = this.active;
    data['follows'] = this.follows;
    data['coin'] = this.coin;
    data['phone'] = this.phone;
    data['exp'] = this.exp;
    data['gender'] = this.gender;
    data['birth'] = this.birth;
    data['is_vip'] = this.isVip;
    return data;
  }
}
