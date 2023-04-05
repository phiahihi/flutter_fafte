
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fafte/utils/export.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fafte/models/message.dart';

class ChatController extends ChangeNotifier {
  ChatController._privateConstructor();
  static final ChatController instance = ChatController._privateConstructor();
  final firestore = FirebaseFirestore.instance;
  final chat =
      FirebaseDatabase.instance.ref().child('chats/0exUS3P2XKFQ007TIMmm');
  List<MessageModel> messages = [];

  void sendMessage(String message) async {
    final messageId = chat.push().key;
    await chat.push().set(
          MessageModel(
            id: messageId,
            senderId: 'UwrnQsazQ4VB45eXjvNw7Y0z7pq1',
            timestamp: DateTime.now().microsecondsSinceEpoch,
            text: message,
            medias: [],
          ).toJson(),
        );

    notifyListeners();
  }

  getAllMessages(ScrollController controller) {
    chat.onValue.listen((event) {
      final listMessage = event.snapshot.children;
      messages.clear();
      for (var child in listMessage) {
        final nextItem = (Map<String, dynamic>.from(child.value as Map));
        messages.add(MessageModel.fromJson(nextItem));
      }
      // controller.animateTo(
      //   controller.position.maxScrollExtent + 200,
      //   curve: Curves.easeOut,
      //   duration: const Duration(milliseconds: 500),
      // );
      notifyListeners();
    });
  }
}

