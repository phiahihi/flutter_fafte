import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? userName;
  String? email;
  String? password;
  String? profileImageUrl;
  String? backgroundImageUrl;
  String? phoneNumber;
  String? fcmToken;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.profileImageUrl,
    this.password,
    this.phoneNumber,
    this.backgroundImageUrl,
    this.fcmToken,
  });

  UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    id = data['id'];
    profileImageUrl = data['profileImageUrl'];
    backgroundImageUrl = data['backgroundImageUrl'];
    email = data['email'];
    userName = data['userName'];
    phoneNumber = data['phoneNumber'];
    password = data['password'];
    fcmToken = data['fcmToken'];
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileImageUrl = json['profileImageUrl'];
    backgroundImageUrl = json['backgroundImageUrl'];
    email = json['email'];
    password = json['password'];
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id ?? '';
    data['profileImageUrl'] = this.profileImageUrl ?? '';
    data['backgroundImageUrl'] = this.backgroundImageUrl ?? '';
    data['email'] = this.email ?? '';
    data['userName'] = this.userName ?? '';
    data['password'] = this.password ?? '';
    data['phoneNumber'] = this.phoneNumber ?? '';
    data['fcmToken'] = this.fcmToken ?? '';
    return data;
  }
}
