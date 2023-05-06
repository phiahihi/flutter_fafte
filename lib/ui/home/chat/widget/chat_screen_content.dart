import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:fafte/controller/chat_controller.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/utils/export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class ChatScreenContent extends StatefulWidget {
  final UserModel friend;
  const ChatScreenContent({super.key, required this.friend});

  @override
  State<ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<ChatScreenContent> {
  ChatController? controller;
  @override
  void didChangeDependencies() {
    if (controller == null) {
      controller = Provider.of<ChatController>(context);
      controller!.getMessages(widget.friend.id ?? '');
      controller?.userTypingStream(widget.friend.id ?? '');
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.friend.userName ?? ''),
          centerTitle: true,
          backgroundColor: splashColor,
          // actions: [
          //   IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.phone),
          //   )
          // ],
          automaticallyImplyLeading: false,
          leading: BackButton(
            onPressed: () {
              Get.back();
              controller?.setUserNotTyping(widget.friend.id!);
            },
          ),
        ),
        body: StreamBuilder(
            stream: controller?.userTypingStream(widget.friend.id ?? ''),
            builder: (context, snapshot) {
              return DashChat(
                typingUsers: snapshot.data == null ? null : [snapshot.data!],
                currentUser:
                    ChatUser(id: FirebaseAuth.instance.currentUser!.uid),
                onSend: (ChatMessage m) {
                  setState(() {
                    controller!.sendMessage(m.text, widget.friend.id!);
                    controller!.setUserNotTyping(widget.friend.id!);
                  });
                },
                messageOptions: MessageOptions(
                  containerColor: splashColor,
                  currentUserContainerColor: splashColor,
                  textColor: white,
                ),
                inputOptions: InputOptions(
                  onTextChange: (String text) {
                    if (text.isEmpty) {
                      controller?.setUserNotTyping(widget.friend.id!);
                    } else {
                      controller?.setUserTyping(widget.friend.id!);
                    }
                  },
                ),
                messages: controller?.messages ?? [],
              );
            }));
  }
}
