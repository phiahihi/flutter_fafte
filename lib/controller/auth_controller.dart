import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fafte/base_response/base_response.dart';
import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/authenticate/welcome_login/welcome_login.dart';
import 'package:fafte/ui/home/main_screen/main_screen.dart';
import 'package:fafte/utils/export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends ChangeNotifier {
  AuthController._privateConstructor();
  static final AuthController instance = AuthController._privateConstructor();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userController = UserController.instance;
  UserCredential? user;
  String? id;

  Future<BaseResponse> register(String email, String password, String fullName,
      String? pickedFile, String phoneNumber) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      var urlImage;
      if (pickedFile != null) {
        urlImage = await _uploadImage(File(pickedFile));
      }
      final result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      id = result.user!.uid;
      await userController.createUser(
        id!,
        UserModel(
          email: email,
          password: password,
          profileImageUrl: urlImage,
          id: id,
          phoneNumber: phoneNumber,
          userName: fullName,
          fcmToken: fcmToken ?? '',
        ),
      );
      await signIn(email, password);
      return BaseResponse(
        message: 'Success',
        success: true,
      );
    } catch (error) {
      return BaseResponse(
        message: error.toString(),
        success: false,
      );
    }
  }

  Future<BaseResponse> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();

      return BaseResponse(
        message: 'Success',
        success: true,
      );
    } catch (e) {
      return BaseResponse(
        message: e.toString(),
        success: false,
      );
    }
  }

  Future<BaseResponse> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final authResult = await auth.signInWithCredential(credential);
      user = authResult;

      assert(!user!.user!.isAnonymous);
      assert(await user!.user?.getIdToken() != null);

      final currentUser = auth.currentUser;
      assert(user?.user?.uid == currentUser?.uid);

      return BaseResponse(
        message: 'Success',
        success: true,
      );
    } catch (e) {
      return BaseResponse(
        message: e.toString(),
        success: false,
      );
    }
  }

  Future<BaseResponse> signIn(String email, String password) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = result;

      await userController.updateFcmToken(user!.user!.uid, fcmToken!);
      return BaseResponse(
        message: 'Success',
        success: true,
      );
    } catch (e) {
      print(e);
      return BaseResponse(
        message: e.toString(),
        success: false,
      );
    }
  }

  Future<BaseResponse> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return BaseResponse(
        message: 'Success',
        success: true,
      );
    } catch (error) {
      print(error);
      return BaseResponse(
        message: error.toString(),
        success: false,
      );
    }
  }

  Future<BaseResponse> changePassword(
      String email, String currentPassword, String newPassword) async {
    try {
      await user?.user?.updatePassword(newPassword);
      return BaseResponse(
        message: 'Đã thay đổi mật khẩu thành công',
        success: true,
      );
    } catch (error) {
      print(error);
      return BaseResponse(
        message: error.toString(),
        success: false,
      );
    }
  }

  void checkUserSignIn() async {
    final currentUser = auth.currentUser;
    if (currentUser != null) {
      navigateTo(const MainScreen(), clearStack: true);
    } else {
      navigateTo(const WelcomeLoginScreen(), clearStack: true);
    }
  }

  Future<String> _uploadImage(File pickedImage) async {
    final storageRef = storage
        .ref()
        .child('avatars/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(pickedImage);
    await uploadTask.whenComplete(() => null);
    return storageRef.getDownloadURL();
  }
}
