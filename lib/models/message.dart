import 'package:fafte/models/chat_media.dart';

class MessageModel {
  String? id;
  String? text;
  String? senderId;
  int? timestamp;
  List<ChatMedia>? medias;

  MessageModel(
      {this.id, this.text, this.senderId, this.timestamp, this.medias});

  factory MessageModel.fromJson(Map<dynamic, dynamic> json) {
    return MessageModel(
      id: json['id'],
      text: json['text'],
      senderId: json['senderId'],
      timestamp: json['timestamp'],
      medias: json['medias'] != null
          ? (json['medias'] as List<dynamic>)
              .map((dynamic media) =>
                  ChatMedia.fromJson(media as Map<String, dynamic>))
              .toList()
          : <ChatMedia>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id ?? '';
    data['timestamp'] = this.timestamp ?? '';
    data['senderId'] = this.senderId ?? '';
    data['text'] = this.text ?? '';
    data['medias'] = this.medias ?? [];

    return data;
  }
}
