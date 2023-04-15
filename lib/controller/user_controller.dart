import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fafte/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class UserController extends ChangeNotifier {
  UserController._privateConstructor();
  static final UserController instance = UserController._privateConstructor();
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  UserModel? userModel;
  List<UserModel> listUserStorageModel = [];
  List<UserModel> listUserSearchModel = [];

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

  // Future<BaseResponse> getAllUser() async {
  //   try {
  //     final posts = await firestore.collection("users").get();
  //     final postsFirebase = posts.docs.map((e) => e.data()).toList();
  //     listUserModel = postsFirebase.map((e) => UserModel.fromJson(e)).toList();
  //     listUserSearchModel = listUserModel
  //         .where((s) => s.userName!
  //             .toLowerCase()
  //             .contains(searchString.text.toLowerCase()))
  //         .toList();

  //     return BaseResponse(
  //       message: 'Success',
  //       success: true,
  //     );
  //   } catch (error) {
  //     return BaseResponse(
  //       message: error.toString(),
  //       success: false,
  //     );
  //   }
  // }

  Future<void> createUser(String userID, UserModel userData) async {
    await firestore.collection('users').doc(userID).set(userData.toJson());
  }

  Future<void> updateFcmToken(String userID, String fcmToken) async {
    await firestore
        .collection('users')
        .doc(userID)
        .update({'fcmToken': fcmToken});
  }

  Future<void> updateInfo(
      String userID, String fullName, String phoneNumber) async {
    await firestore.collection('users').doc(userID).update({
      'userName': fullName,
      'phoneNumber': phoneNumber,
    });
  }

  Future<void> updateBackgroundImage(
      String userID, String? backgroundImageUrl) async {
    var urlImage;
    if (backgroundImageUrl != null) {
      urlImage = await _uploadImage(File(backgroundImageUrl), 'backgrounds');
    }
    await firestore
        .collection('users')
        .doc(userID)
        .update({'backgroundImageUrl': urlImage});
    UserController.instance.getUser();
  }

  Future<void> updateAvatarImage(String userID, String? avatarImageUrl) async {
    var urlImage;
    if (avatarImageUrl != null) {
      urlImage = await _uploadImage(File(avatarImageUrl), 'avatars');
    }
    await firestore
        .collection('users')
        .doc(userID)
        .update({'profileImageUrl': urlImage});
    UserController.instance.getUser();
  }

  Future<String> _uploadImage(File pickedImage, String type) async {
    final storageRef = storage
        .ref()
        .child('$type/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(pickedImage);
    await uploadTask.whenComplete(() => null);
    return storageRef.getDownloadURL();
  }
}
