class NotificationModel {
  final String? id;
  final String? title;
  final String? body;
  final int? timestamp;
  final bool? read;
  final String? recipientId;
  final String? senderId;
  final String? type;
  final String? postId;
  final String? commentId;
  final String? likeId;

  NotificationModel(
      {this.id,
      this.title,
      this.body,
      this.timestamp,
      this.read,
      this.recipientId,
      this.senderId,
      this.type,
      this.postId,
      this.commentId,
      this.likeId});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      timestamp: json['timestamp'],
      read: json['read'],
      recipientId: json['recipientId'],
      senderId: json['senderId'],
      type: json['type'],
      postId: json['postId'],
      commentId: json['commentId'] ?? '',
      likeId: json['likeId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'timestamp': timestamp,
        'read': read,
        'recipientId': recipientId,
        'senderId': senderId,
        'type': type,
        'postId': postId,
      };
}
