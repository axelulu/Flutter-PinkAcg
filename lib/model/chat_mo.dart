class ChatList {
  late List<ChatMo> list;
  late int total;

  ChatList({required this.list, required this.total});

  ChatList.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ChatMo>[];
      json['list'].forEach((v) {
        list.add(new ChatMo.fromJson(v));
      });
    } else {
      list = <ChatMo>[];
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

class ChatMo {
  late int userId;
  late int cmd;
  late int sendId;
  late String content;
  late int media;

  ChatMo(
      {required this.userId,
      required this.cmd,
      required this.sendId,
      required this.content,
      required this.media});

  ChatMo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    cmd = json['cmd'];
    sendId = json['send_id'];
    content = json['content'];
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['cmd'] = this.cmd;
    data['send_id'] = this.sendId;
    data['content'] = this.content;
    data['media'] = this.media;
    return data;
  }
}
