import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/models/message.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/widget/message_container/default_avatar.dart';
import 'package:fafte/ui/widget/message_container/default_user_name.dart';
import 'package:fafte/ui/widget/message_container/media_container.dart';
import 'package:fafte/ui/widget/message_container/message_options.dart';
import 'package:fafte/ui/widget/message_container/text_container.dart';
import 'package:fafte/utils/export.dart';

class MessageRow extends StatefulWidget {
  const MessageRow({
    required this.message,
    required this.currentUser,
    this.previousMessage,
    this.nextMessage,
    this.isAfterDateSeparator = false,
    this.isBeforeDateSeparator = false,
    this.messageOptions = const MessageOptions(),
    Key? key,
  }) : super(key: key);

  /// Current message to show
  final MessageModel message;

  /// Previous message in the list
  final MessageModel? previousMessage;

  /// Next message in the list
  final MessageModel? nextMessage;

  /// Current user of the chat
  final UserModel currentUser;

  /// If the message is preceded by a date separator
  final bool isAfterDateSeparator;

  /// If the message is before a date separator
  final bool isBeforeDateSeparator;

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  @override
  State<MessageRow> createState() => _MessageRowState();
}

class _MessageRowState extends State<MessageRow> {
  /// Get the avatar widget
  Widget getAvatar(UserModel? userModel) {
    return widget.messageOptions.avatarBuilder != null
        ? widget.messageOptions.avatarBuilder!(
            userModel!,
            widget.messageOptions.onPressAvatar,
            widget.messageOptions.onLongPressAvatar,
          )
        : DefaultAvatar(
            user: userModel ?? UserModel(),
            onLongPressAvatar: widget.messageOptions.onLongPressAvatar,
            onPressAvatar: widget.messageOptions.onPressAvatar,
          );
  }

  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    if (userModel != null) {
      UserController.instance.getSender(widget.message.id!).then((user) {
        userModel = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = UserController.instance.userModel;

    final bool isOwnMessage = widget.message.senderId == widget.currentUser.id;
    bool isPreviousSameAuthor = false;
    bool isNextSameAuthor = false;
    if (widget.previousMessage != null &&
        widget.previousMessage!.senderId == widget.message.senderId) {
      isPreviousSameAuthor = true;
    }
    if (widget.nextMessage != null &&
        widget.nextMessage!.senderId == widget.message.senderId) {
      isNextSameAuthor = true;
    }
    return Padding(
      padding: EdgeInsets.only(top: isPreviousSameAuthor ? 2 : 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (widget.messageOptions.showOtherUsersAvatar)
            Opacity(
              opacity: !isOwnMessage &&
                      (!isNextSameAuthor || widget.isBeforeDateSeparator)
                  ? 1
                  : 0,
              child: getAvatar(userModel),
            ),
          if (!widget.messageOptions.showOtherUsersAvatar)
            const Padding(padding: EdgeInsets.only(left: 10)),
          GestureDetector(
            onLongPress: widget.messageOptions.onLongPressMessage != null
                ? () =>
                    widget.messageOptions.onLongPressMessage!(widget.message)
                : null,
            onTap: widget.messageOptions.onPressMessage != null
                ? () => widget.messageOptions.onPressMessage!(widget.message)
                : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: widget.messageOptions.maxWidth ??
                    MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: isOwnMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (widget.messageOptions.top != null)
                    widget.messageOptions.top!(widget.message,
                        widget.previousMessage, widget.nextMessage),
                  if (!isOwnMessage &&
                      widget.messageOptions.showOtherUsersName &&
                      (!isPreviousSameAuthor || widget.isAfterDateSeparator))
                    widget.messageOptions.userNameBuilder != null
                        ? widget.messageOptions.userNameBuilder!(userModel!)
                        : DefaultUserName(user: userModel ?? UserModel()),
                  if (widget.message.medias != null &&
                      widget.message.medias!.isNotEmpty &&
                      widget.messageOptions.textBeforeMedia)
                    widget.messageOptions.messageMediaBuilder != null
                        ? widget.messageOptions.messageMediaBuilder!(
                            widget.message,
                            widget.previousMessage,
                            widget.nextMessage)
                        : MediaContainer(
                            message: widget.message,
                            isOwnMessage: isOwnMessage,
                            messageOptions: widget.messageOptions,
                          ),
                  if (widget.message.text != null || widget.message.text != '')
                    TextContainer(
                      messageOptions: widget.messageOptions,
                      message: widget.message,
                      previousMessage: widget.previousMessage,
                      nextMessage: widget.nextMessage,
                      isOwnMessage: isOwnMessage,
                      isNextSameAuthor: isNextSameAuthor,
                      isPreviousSameAuthor: isPreviousSameAuthor,
                      isAfterDateSeparator: widget.isAfterDateSeparator,
                      isBeforeDateSeparator: widget.isBeforeDateSeparator,
                      messageTextBuilder:
                          widget.messageOptions.messageTextBuilder,
                    ),
                  if (widget.message.medias != null &&
                      widget.message.medias!.isNotEmpty &&
                      !widget.messageOptions.textBeforeMedia)
                    widget.messageOptions.messageMediaBuilder != null
                        ? widget.messageOptions.messageMediaBuilder!(
                            widget.message,
                            widget.previousMessage,
                            widget.nextMessage)
                        : MediaContainer(
                            message: widget.message,
                            isOwnMessage: isOwnMessage,
                            messageOptions: widget.messageOptions,
                          ),
                  if (widget.messageOptions.bottom != null)
                    widget.messageOptions.bottom!(widget.message,
                        widget.previousMessage, widget.nextMessage),
                ],
              ),
            ),
          ),
          if (widget.messageOptions.showCurrentUserAvatar)
            Opacity(
              opacity: isOwnMessage && !isNextSameAuthor ? 1 : 0,
              child: getAvatar(userModel),
            ),
          if (!widget.messageOptions.showCurrentUserAvatar)
            const Padding(padding: EdgeInsets.only(left: 10))
        ],
      ),
    );
  }
}
