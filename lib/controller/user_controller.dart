import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fafte/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserController extends ChangeNotifier {
  UserController._privateConstructor();
  static final UserController instance = UserController._privateConstructor();
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  UserModel? userModel;

  Future<UserModel> getSender(String chatId) async {
    DocumentSnapshot chat =
        await firestore.collection("Chats").doc(chatId).get();
    String senderId = chat['sender'];
    DocumentSnapshot user =
        await firestore.collection("Users").doc(senderId).get();
    return UserModel.fromDocument(user);
  }

  void getUser() async {
    try {
      DocumentSnapshot user =
          await firestore.collection("users").doc(auth.currentUser!.uid).get();
      userModel = UserModel.fromDocument(user);
      print('user: $userModel');
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> createUser(String userID, UserModel userData) async {
    await firestore.collection('users').doc(userID).set(userData.toJson());
  }
}
