import 'package:cloud_firestore/cloud_firestore.dart';

class LikeModel {
  String? id;
  String? userId;
  int? timestamp;
  String? postId;

  LikeModel({
    this.id,
    this.timestamp,
    this.userId,
    this.postId,
  });

  LikeModel.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    final doc = data.data();
    id = doc['id'];
    timestamp = doc['timestamp'];
    userId = doc['userId'];
    postId = doc['postId'];
  }

  LikeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    userId = json['userId'];
    postId = json['postId'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id ?? '',
        'timeStamp': this.timestamp ?? '',
        'userId': this.userId ?? '',
        'postId': this.postId ?? '',
      };
}
