// import 'package:fafte/models/message.dart';
// import 'package:fafte/ui/widget/message_container/message_options.dart';
// import 'package:fafte/utils/export.dart';
// import 'package:intl/intl.dart';

// class DefaultMessageText extends StatelessWidget {
//   const DefaultMessageText({
//     required this.message,
//     required this.isOwnMessage,
//     this.messageOptions = const MessageOptions(),
//     Key? key,
//   }) : super(key: key);

//   /// Message tha contains the text to show
//   final MessageModel message;

//   /// If the message is from the current user
//   final bool isOwnMessage;

//   /// Options to customize the behaviour and design of the messages
//   final MessageOptions messageOptions;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment:
//           isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: <Widget>[
//         Wrap(
//           children: getMessage(),
//         ),
//         if (messageOptions.showTime)
//           messageOptions.messageTimeBuilder != null
//               ? messageOptions.messageTimeBuilder!(message, isOwnMessage)
//               : Padding(
//                   padding: const EdgeInsets.only(top: 5),
//                   child: Text(
//                     (messageOptions.timeFormat ?? DateFormat('HH:mm'))
//                         .format(message.timestamp),
//                     style: TextStyle(
//                       color: isOwnMessage
//                           ? (messageOptions.currentUserTextColor ??
//                               Colors.white70)
//                           : (messageOptions.textColor ?? Colors.black54),
//                       fontSize: 10,
//                     ),
//                   ),
//                 ),
//       ],
//     );
//   }
// }
