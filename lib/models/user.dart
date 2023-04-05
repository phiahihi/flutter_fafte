import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? userName;
  String? email;
  String? password;
  String? profileImageUrl;
  String? phoneNumber;

  UserModel({
    this.id,
    this.userName,
    this.email,
    this.profileImageUrl,
    this.password,
    this.phoneNumber,
  });

  UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    id = data['id'];
    profileImageUrl = data['profileImageUrl'];
    email = data['email'];
    userName = data['userName'];
    phoneNumber = data['phoneNumber'];
    password = data['password'];
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileImageUrl = json['profileImageUrl'];
    email = json['email'];
    password = json['password'];
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id ?? '';
    data['profileImageUrl'] = this.profileImageUrl ?? '';
    data['email'] = this.email ?? '';
    data['userName'] = this.userName ?? '';
    data['password'] = this.password ?? '';
    data['phoneNumber'] = this.phoneNumber ?? '';
    return data;
  }
}
