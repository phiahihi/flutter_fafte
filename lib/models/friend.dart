class FriendModel {
  String? id;
  String? receiverId;
  String? senderId;
  int? timestamp;
  String? status;

  FriendModel(
      {this.id, this.receiverId, this.senderId, this.timestamp, this.status});

  factory FriendModel.fromJson(Map<dynamic, dynamic> json) {
    return FriendModel(
      id: json['id'],
      receiverId: json['receiverId'],
      senderId: json['senderId'],
      timestamp: json['timestamp'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id ?? '';
    data['timestamp'] = this.timestamp ?? '';
    data['senderId'] = this.senderId ?? '';
    data['receiverId'] = this.receiverId ?? '';
    data['status'] = this.status ?? '';

    return data;
  }
}
