class ContactMo {
  late List<ContactList> list;
  late int total;

  ContactMo({required this.list, required this.total});

  ContactMo.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ContactList>[];
      json['list'].forEach((v) {
        list.add(new ContactList.fromJson(v));
      });
    } else {
      list = <ContactList>[];
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class ContactList {
  late int userId;
  late int sendId;
  late SendUserMeta sendUserMeta;
  late String updateTime;

  ContactList(
      {required this.userId,
      required this.sendId,
      required this.sendUserMeta,
      required this.updateTime});

  ContactList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    sendId = json['send_id'];
    sendUserMeta = (json['send_user_meta'] != null
        ? new SendUserMeta.fromJson(json['send_user_meta'])
        : null)!;
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['send_id'] = this.sendId;
    if (this.sendUserMeta != null) {
      data['send_user_meta'] = this.sendUserMeta.toJson();
    }
    data['update_time'] = this.updateTime;
    return data;
  }
}

class SendUserMeta {
  late int userId;
  late String avatar;
  late String background;
  late String username;
  late String descr;
  late String email;
  late int fans;
  late int follows;
  late int coin;
  late int phone;
  late int exp;
  late int gender;
  late String birth;
  late String isVip;
  late int active;

  SendUserMeta(
      {required this.userId,
      required this.avatar,
      required this.background,
      required this.username,
      required this.descr,
      required this.email,
      required this.fans,
      required this.follows,
      required this.coin,
      required this.phone,
      required this.exp,
      required this.gender,
      required this.birth,
      required this.isVip,
      required this.active});

  SendUserMeta.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    avatar = json['avatar'];
    background = json['background'];
    username = json['username'];
    descr = json['descr'];
    email = json['email'];
    fans = json['fans'];
    follows = json['follows'];
    coin = json['coin'];
    phone = json['phone'];
    exp = json['exp'];
    gender = json['gender'];
    birth = json['birth'];
    isVip = json['is_vip'];
    active = json['active'];
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
    data['follows'] = this.follows;
    data['coin'] = this.coin;
    data['phone'] = this.phone;
    data['exp'] = this.exp;
    data['gender'] = this.gender;
    data['birth'] = this.birth;
    data['is_vip'] = this.isVip;
    data['active'] = this.active;
    return data;
  }
}
