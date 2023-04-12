
class MessageModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? messageText;
  int? timestamp;
  bool? isRead;

  MessageModel(
      {this.id,
      this.senderId,
      this.receiverId,
      this.messageText,
      this.timestamp,
      this.isRead});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageText: json['messageText'],
      timestamp: json['timestamp'],
      isRead: json['isRead'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'receiverId': receiverId,
        'messageText': messageText,
        'timestamp': timestamp,
        'isRead': isRead,
      };
}
