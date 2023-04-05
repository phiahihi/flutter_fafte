import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? id;
  String? postText;
  String? postImageUrl;
  String? userId;
  int? timeStamp;
  List? likeUserId;
  List? commentIds;

  PostModel({
    this.id,
    this.postText,
    this.postImageUrl,
    this.timeStamp,
    this.userId,
    this.likeUserId,
    this.commentIds,
  });

  PostModel.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> data) {
    final doc = data.data();
    id = doc['id'];
    timeStamp = doc['timeStamp'];
    postImageUrl = doc['postImageUrl'];
    postText = doc['postText'];
    likeUserId = doc['likeUserId'];
    userId = doc['userId'];
    userId = doc['commentId'];
  }

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeStamp = json['timeStamp'];
    postImageUrl = json['postImageUrl'];
    userId = json['userId'];
    postText = json['postText'];
    likeUserId = json['likeUserId'];
    commentIds = json['commentId'];
  }

  Map<String, dynamic> toJson() => {
        'id': this.id ?? '',
        'timeStamp': this.timeStamp ?? '',
        'postImageUrl': this.postImageUrl ?? '',
        'postText': this.postText ?? '',
        'userId': this.userId ?? '',
        'likeUserId': this.likeUserId ?? [],
        'commentId': this.commentIds ?? [],
      };
}
