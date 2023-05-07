import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fafte/base_response/base_response.dart';
import 'package:fafte/controller/auth_controller.dart';
import 'package:fafte/models/friend.dart';
import 'package:fafte/models/user.dart';

import 'package:fafte/utils/export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FriendController extends ChangeNotifier {
  FriendController._privateConstructor();
  static final FriendController instance =
      FriendController._privateConstructor();
  final authController = AuthController.instance;
  final storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final realtime = FirebaseDatabase.instance;
  List<FriendModel> list10Invite = [];
  List<UserModel>? list10Friend;

  List<FriendModel> listAllInvite = [];
  List<FriendModel> listAllFriend = [];

  Future<FriendModel> getInvitation(String userId) async {
    try {
      List<FriendModel> _listInvatation = [];
      final currentUser = auth.currentUser;
      final invitation = await firestore.collection('invitations').get();
      _listInvatation =
          invitation.docs.map((e) => FriendModel.fromJson(e.data())).toList();

      return _listInvatation.firstWhere((element) =>
          (element.senderId == userId ||
              element.senderId == currentUser?.uid) &&
          (element.receiverId == userId ||
              element.receiverId == currentUser?.uid));
    } catch (error) {
      return FriendModel();
    }
  }

  Future<FriendModel> getStatusInvite(String userId) async {
    try {
      List<FriendModel> _listInvitation = [];
      final currentUser = auth.currentUser;
      final invitation = await firestore.collection('invitations').get();
      _listInvitation =
          invitation.docs.map((e) => FriendModel.fromJson(e.data())).toList();

      return _listInvitation.firstWhere((element) =>
          (element.senderId == userId ||
              element.senderId == currentUser?.uid) &&
          (element.receiverId == userId ||
              element.receiverId == currentUser?.uid));
    } catch (error) {
      return FriendModel();
    }
  }

  Future<BaseResponse> get10Invitation() async {
    try {
      final currentUser = auth.currentUser;
      final invitation = await firestore
          .collection('invitations')
          .where('receiverId', isEqualTo: currentUser?.uid)
          .where('status', isEqualTo: 'pending')
          .limit(10)
          .get();

      list10Invite =
          invitation.docs.map((e) => FriendModel.fromJson(e.data())).toList();
      notifyListeners();
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

  Future<UserModel> getSender(String userId) async {
    DocumentSnapshot user =
        await firestore.collection("users").doc(userId).get();
    return UserModel.fromDocument(user);
  }

  Future<BaseResponse> getAllInvitation() async {
    try {
      final currentUser = auth.currentUser;
      final invitation = await firestore
          .collection('invitations')
          .where('receiverId', isEqualTo: currentUser?.uid)
          .where('status', isEqualTo: 'pending')
          .get();

      listAllInvite =
          invitation.docs.map((e) => FriendModel.fromJson(e.data())).toList();
      print(listAllInvite[0].toJson());
      notifyListeners();

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

  Future<BaseResponse> getAllFriend() async {
    try {
      final currentUser = auth.currentUser;
      final friend = await firestore
          .collection('invitations')
          .where('status', isEqualTo: 'accepted')
          .get();

      listAllFriend =
          friend.docs.map((e) => FriendModel.fromJson(e.data())).toList();

      notifyListeners();

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

  Future<BaseResponse> sendInvitation(String receiverId) async {
    try {
      await getAllInvitation();
      if (listAllInvite.any((element) =>
          element.receiverId == receiverId ||
          element.receiverId == auth.currentUser!.uid &&
              element.senderId == auth.currentUser?.uid ||
          element.senderId == receiverId)) {
        return BaseResponse(
          message: 'Không thể gửi lời mời kết bạn',
          success: false,
        );
      } else {
        final currentUser = auth.currentUser;
        final invitation = await FirebaseFirestore.instance
            .collection('invitations')
            .add(<String, dynamic>{});
        await firestore.collection('invitations').doc(invitation.id).set({
          'id': invitation.id,
          'senderId': currentUser?.uid,
          'receiverId': receiverId,
          'status': 'pending',
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });

        return BaseResponse(
          message: 'Đã gửi lời mời kết bạn',
          success: true,
        );
      }
    } catch (error) {
      print(error);
      return BaseResponse(
        message: error.toString(),
        success: false,
      );
    }
  }

  //   Future<BaseResponse> getInvitation( String receiverId ) async {
  //   try {
  //     final currentUser = auth.currentUser;
  //     await firestore.collection('conversation').doc(id).set({
  //       'senderId': currentUser?.uid,
  //       'receiverId': id,
  //       'status': 'pending',
  //       'timestamp': DateTime.now().millisecondsSinceEpoch
  //     });

  //     // FirebaseDatabase.instance
  //     //     .ref()
  //     //     .child('invitations')
  //     //     .child(currentUser.uid)
  //     //     .onChildAdded
  //     //     .listen((snapshot) {
  //     //   print(snapshot);
  //     // });
  //     return BaseResponse(
  //       message: 'Success',
  //       success: true,
  //     );
  //   } catch (error) {
  //     print(error);
  //     return BaseResponse(
  //       message: error.toString(),
  //       success: false,
  //     );
  //   }
  // }

  Future<BaseResponse> acceptInvitation(String invitation) async {
    try {
      await firestore.collection('invitations').doc(invitation).update({
        'status': 'accepted',
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });

      return BaseResponse(
        message: 'Đã chấp nhận lời mời kết bạn',
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

  Future<BaseResponse> rejectInvitation(String userId) async {
    try {
      String? invatationId;
      await getInvitation(userId).then((value) {
        invatationId = value.id;
      });

      await firestore.collection('invitations').doc(invatationId).delete();

      await getAllInvitation();
      notifyListeners();
      return BaseResponse(
        message: 'Đã hủy lời mời kết bạn',
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
}
