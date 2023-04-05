class ChatModel {
  String? id;
  List? users;
  String? lastMessage;
  String? timestamp;

  ChatModel({
    this.id,
    this.users,
    this.lastMessage,
    this.timestamp,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    lastMessage = json['lastMessage'];
    users = json['users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id ?? '';
    data['timestamp'] = this.timestamp ?? '';
    data['lastMessage'] = this.lastMessage ?? '';
    data['users'] = this.users ?? '';
    return data;
  }
}
