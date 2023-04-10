import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:fafte/base_response/base_response.dart';
import 'package:fafte/controller/friend_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/models/item_message.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/utils/export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fafte/models/message.dart';

class ChatController extends ChangeNotifier {
  ChatController._privateConstructor();
  static final ChatController instance = ChatController._privateConstructor();
  final firestore = FirebaseFirestore.instance;
  String senderId = FirebaseAuth.instance.currentUser!.uid;
  final friend = FriendController.instance;
  final post = PostController.instance;

  DatabaseReference messagesRef =
      FirebaseDatabase.instance.ref().child("messages");
  List<ChatMessage> messages = [];
  String? userSendMessage;
  List<ChatUser> usersChat = [];
  DatabaseReference typingRef = FirebaseDatabase.instance.ref().child('typing');
  List<Future<MessageModel>> listLastMessage = [];
  List<String> listBoxId = [];

  String generateConversationId(String user1Id, String user2Id) {
    if (user1Id.compareTo(user2Id) < 0) {
      return "$user1Id-$user2Id";
    } else {
      return "$user2Id-$user1Id";
    }
  }

  void sendMessage(String messageText, String receiverId) {
    String conversationId = generateConversationId(senderId, receiverId);
    DatabaseReference conversationRef = messagesRef.child(conversationId);
    DatabaseReference newMessageRef = conversationRef.push();
    newMessageRef.set({
      "id": conversationId,
      "senderId": senderId,
      "receiverId": receiverId,
      "messageText": messageText,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "isRead": false
    });
  }

  void getMessages(String receiverId) {
    String conversationId = generateConversationId(senderId, receiverId);
    final _messagesRef = messagesRef.child(conversationId);
    messages = [];
    _messagesRef.onValue.listen((event) async {
      if (event.snapshot.value != null) {
        var map = event.snapshot.children;

        if (map != null) {
          final s = map.map((e) {
            return MessageModel.fromJson(jsonDecode(jsonEncode(e.value)));
          }).toList();
          s.sort((a, b) => b.timestamp!.compareTo(a.timestamp!));

          messages = s.map((e) {
            getAvatarUrl(receiverId).then((value) {
              userSendMessage = value;
            });
            return ChatMessage(
                user: ChatUser(
                  id: e.senderId!,
                  profileImage: userSendMessage,
                ),
                createdAt: DateTime.fromMillisecondsSinceEpoch(e.timestamp!),
                text: e.messageText!);
          }).toList();
        }
      }

      notifyListeners();
    });

    // print(streamController.stream.first);
  }

  Future<BaseResponse> getAllBoxChat() async {
    try {
      final _messagesRef = await messagesRef.get();
      listBoxId = _messagesRef.children.map((e) => e.key.toString()).toList();

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

  Future<ItemMessageModel> getItemMessage(String conversationId) async {
    try {
      final itemMessageModel = ItemMessageModel();
      var messageModel = MessageModel();
      var userModel = UserModel();
      List<String> parts = conversationId.split("-");
      String userId = parts[1] == FirebaseAuth.instance.currentUser!.uid
          ? parts[0]
          : parts[1];
      // Execute the futures.
      await Future.wait([
        getLastMessage(conversationId).then((value) => messageModel = value),
        post.getPoster(userId).then((value) => userModel = value),
      ]);

      // Save the data, then return it.
      itemMessageModel.messageModel = messageModel;
      itemMessageModel.userModel = userModel;
      return itemMessageModel;
    } catch (e) {
      print(e.toString());
      return ItemMessageModel();
    }
  }

  Future<MessageModel> getLastMessage(String conversationId) async {
    final DatabaseEvent snapshot = await messagesRef
        .child(conversationId)
        .orderByChild('timestamp')
        .limitToLast(1)
        .once();

    return MessageModel.fromJson(
        jsonDecode(jsonEncode(snapshot.snapshot.value)).values.toList()[0]);
  }

  Future getAvatarUrl(String id) {
    return firestore.collection("users").doc(id).get().then((value) {
      return value.data()!["profileImageUrl"];
    });
  }

  // Set the typing field for the specified user to true
  void setUserTyping(String friendId) {
    String conversationId = generateConversationId(senderId, friendId);
    final _typingRef = typingRef.child(conversationId).child(senderId);

    _typingRef.push();
    _typingRef.set({
      "userTyping": senderId,
      "typing": true,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Stream that listens for changes in the typing field for the specified user
  Stream<ChatUser?> userTypingStream(String friendId) {
    String conversationId = generateConversationId(senderId, friendId);
    final _typingRef = typingRef.child(conversationId).child(friendId);
    return _typingRef.onValue.map((event) {
      if (event.snapshot.value != null) {
        if (jsonDecode(jsonEncode(event.snapshot.value))['userTyping'] ==
            senderId) {
          return null;
        }
        return ChatUser(
            id: jsonDecode(jsonEncode(event.snapshot.value))['userTyping']);
      } else {
        return null;
      }
    });
  }

  // Set the typing field for the specified user to false
  void setUserNotTyping(String friendId) {
    String conversationId = generateConversationId(senderId, friendId);
    final _typingRef = typingRef.child(conversationId).child(senderId);
    _typingRef.remove();
  }

  // void userTyping() {
  //   StreamSubscription<DatabaseEvent> typingSubscription =
  //       typingRef.onValue.listen((DatabaseEvent event) {
  //     activeChats.clear();
  //     Map<dynamic, dynamic> typingData = event.snapshot.children as Map;
  //     typingData.forEach((key, value) {
  //       if (value['typing'] == true) {
  //         String chatId =
  //             key.split('_').contains(senderId) ? key : key.reversed.toString();
  //         activeChats.add(chatId);
  //       }
  //     });
  //   });
  // }
}
