import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? id;
  String? userId;
  int? timestamp;
  String? postId;
  String? commentText;

  CommentModel({
    this.id,
    this.timestamp,
    this.userId,
    this.postId,
    this.commentText,
  });

  CommentModel.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    final doc = data.data();
    id = doc['id'];
    timestamp = doc['timestamp'];
    userId = doc['userId'];
    postId = doc['postId'];
    commentText = doc['commentText'];
  }

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    userId = json['userId'];
    postId = json['postId'];
    commentText = json['commentText'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id ?? '',
        'timestamp': this.timestamp ?? '',
        'userId': this.userId ?? '',
        'postId': this.postId ?? '',
        'commentText': this.commentText ?? '',
      };
}
