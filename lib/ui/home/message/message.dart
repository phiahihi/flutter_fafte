// import 'package:fafte/models/user.dart';
// import 'package:fafte/ui/widget/message_container/message_list_options.dart';
// import 'package:fafte/ui/widget/message_container/message_options.dart';
// import 'package:fafte/ui/widget/message_container/message_row.dart';
// import 'package:fafte/utils/date_time_utils.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fafte/controller/chat_controller.dart';
// import 'package:fafte/models/message.dart';
// import 'package:fafte/theme/assets.dart';
// import 'package:fafte/ui/widget/appbar/appbar.dart';
// import 'package:fafte/ui/widget/container/spacing_box.dart';
// import 'package:fafte/ui/widget/textfield/textfield.dart';
// import 'package:fafte/utils/export.dart';
// import 'package:provider/provider.dart';

// import '../../widget/message_container/default_date_separator.dart';

// class MessageScreen extends StatefulWidget {
//   const MessageScreen({
//     this.messageOptions = const MessageOptions(),
//     this.messageListOptions = const MessageListOptions(),
//     this.typingUsers,
//     Key? key,
//   }) : super(key: key);

//   /// Options to customize the behaviour and design of the messages
//   final MessageOptions messageOptions;

//   /// Options to customize the behaviour and design of the overall list of message
//   final MessageListOptions messageListOptions;

//   /// Options to customize the behaviour and design of the quick replies

//   /// List of users currently typing in the chat
//   final List<UserModel>? typingUsers;

//   @override
//   State<MessageScreen> createState() => _MessageScreenState();
// }

// class _MessageScreenState extends State<MessageScreen>
//     with TickerProviderStateMixin {
//   final controller = ScrollController();
//   bool offSet = false;
//   bool add = false;
//   bool textIsEmpty = false;
//   bool showScrollToBottom = false;
//   bool isReadOnly = true;
//   final TextEditingController _textController = TextEditingController();
//   ChatController? chatController;

//   TextEditingController textController = TextEditingController();

//   GlobalKey widgetKey = GlobalKey();

//   Offset? widgetOffset;
//   double? _currentPosition;
//   double opacity = 1;

//   @override
//   void initState() {
//     controller.addListener(_scrollListener);
//     super.initState();
//   }

//   _scrollListener() {
//     print('scrolling');

//     RenderBox? renderBox = context.findRenderObject() as RenderBox;
//     widgetOffset = renderBox.localToGlobal(Offset.zero);
//     _currentPosition = controller.position.pixels;
//     final maxPosition = controller.position.maxScrollExtent;
//     print("widget position: $_currentPosition against: 100");

//     if (maxPosition - 500 > _currentPosition! &&
//         _currentPosition! > maxPosition - 600) {
//       setState(() {
//         _currentPosition = maxPosition - 500 - _currentPosition!;
//         opacity = _currentPosition! / 100;
//       });
//     } else if (_currentPosition! < maxPosition - 500) {
//       opacity = 1;
//     } else if (_currentPosition! > 0 && opacity != 0) {
//       opacity = 0;
//     }
//     print("opacity is: $opacity");
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (chatController == null) {
//       chatController = Provider.of<ChatController>(context);
//       chatController!.getAllMessages(controller);
//     }
//   }

//   void _scrollToBottom() async {
//     controller.jumpTo(
//       controller.position.maxScrollExtent + 500,
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     _textController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottom = MediaQuery.of(context).viewInsets.bottom;

//     final listMessage = context.watch<ChatController>().messages;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: whiteAccent,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.only(bottom: bottom),
//           child: Stack(children: [
//             Column(
//               children: [
//                 Container(
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: whiteAccent,
//                     boxShadow: [
//                       BoxShadow(
//                         color: splashColor.withOpacity(0.5),
//                         offset: const Offset(0.0, 1), //(x,y)
//                         blurRadius: 0.5,
//                       ),
//                     ],
//                   ),
//                   child: const BuildAppBar(
//                     name: 'Phi',
//                     isMessage: true,
//                   ),
//                 ),
//                 Expanded(
//                   child: NotificationListener<ScrollNotification>(
//                     onNotification: (t) {
//                       if (t is ScrollEndNotification) {
//                         if (controller.offset.toInt() !=
//                             controller.position.maxScrollExtent.toInt()) {
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             setState(() {
//                               offSet = true;
//                             });
//                           });
//                         } else {
//                           WidgetsBinding.instance.addPostFrameCallback((_) {
//                             setState(() {
//                               offSet = false;
//                             });
//                           });
//                         }
//                         return true;
//                       }

//                       _scrollListener();

//                       return true;
//                     },
//                     child:
//                         NotificationListener<OverscrollIndicatorNotification>(
//                       onNotification: (t) {
//                         t.disallowGlow();
//                         return true;
//                       },
//                       child: ListView.builder(
//                         shrinkWrap: true,
//                         controller: controller,
//                         itemBuilder: (context, i) {
//                           final MessageModel? previousMessage =
//                               i < listMessage.length - 1
//                                   ? listMessage[i + 1]
//                                   : null;
//                           final MessageModel? nextMessage =
//                               i > 0 ? listMessage[i - 1] : null;
//                           final MessageModel message = listMessage[i];
//                           final bool isAfterDateSeparator =
//                               _shouldShowDateSeparator(previousMessage, message,
//                                   widget.messageListOptions);
//                           bool isBeforeDateSeparator = false;
//                           if (nextMessage != null) {
//                             isBeforeDateSeparator = _shouldShowDateSeparator(
//                                 message,
//                                 nextMessage,
//                                 widget.messageListOptions);
//                           }
//                           return Column(
//                             children: <Widget>[
//                               TextField(
//                                 controller: textController,
//                               ),
//                               TextButton(
//                                   onPressed: () async {
//                                     print('');
//                                   },
//                                   child: Text('hihih')),
//                               TextButton(
//                                 child: Text('sss'),
//                                 onPressed: () {},
//                               ),
//                               if (isAfterDateSeparator)
//                                 widget.messageListOptions
//                                             .dateSeparatorBuilder !=
//                                         null
//                                     ? widget.messageListOptions
//                                             .dateSeparatorBuilder!(
//                                         timestampToDate(message.timestamp)!)
//                                     : DefaultDateSeparator(
//                                         date:
//                                             // timestampToDate(
//                                             //     message.timestamp)!,
//                                             DateTime.now(),
//                                         messageListOptions:
//                                             widget.messageListOptions,
//                                       ),
//                               if (widget.messageOptions.messageRowBuilder !=
//                                   null) ...<Widget>[
//                                 widget.messageOptions.messageRowBuilder!(
//                                   message,
//                                   previousMessage,
//                                   nextMessage,
//                                   isAfterDateSeparator,
//                                   isBeforeDateSeparator,
//                                 ),
//                               ] else
//                                 MessageRow(
//                                   message: listMessage[i],
//                                   nextMessage: nextMessage,
//                                   previousMessage: previousMessage,
//                                   currentUser: UserModel(id: 'sssss'),
//                                   isAfterDateSeparator: isAfterDateSeparator,
//                                   isBeforeDateSeparator: isBeforeDateSeparator,
//                                   messageOptions: widget.messageOptions,
//                                 ),
//                             ],
//                           );
//                         },
//                         itemCount: listMessage.length,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: Sizes.s25, vertical: Sizes.s8),
//                   decoration: BoxDecoration(
//                     color: whiteAccent,
//                     boxShadow: offSet
//                         ? [
//                             const BoxShadow(
//                               color: splashColor,
//                               offset: Offset(0, -1), //(x,y)
//                               blurRadius: 0.5,
//                             ),
//                           ]
//                         : null,
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Expanded(
//                         child: Stack(
//                           children: [
//                             BuildTextField(
//                               hintText: S.current.typeSomething,
//                               hintStyle: pt14Regular(context).copyWith(
//                                 color: hintTextMessage,
//                               ),
//                               onChanged: (value) {
//                                 setState(() {
//                                   if (value.isNotEmpty || value != '') {
//                                     textIsEmpty = true;
//                                   } else {
//                                     textIsEmpty = false;
//                                   }
//                                   print(textIsEmpty);
//                                 });
//                               },
//                               maxLines: 5,
//                               controller: _textController,
//                               borderRadius: BorderRadius.circular(Sizes.s12),
//                               contentPadding: EdgeInsets.all(Sizes.s16)
//                                   .copyWith(right: Sizes.s32),
//                               fillColor: white,
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: Sizes.s13, horizontal: Sizes.s8),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     if (_textController.text.isNotEmpty) {
//                                       listMessage.add(MessageModel());

//                                       setState(() {
//                                         chatController
//                                             ?.sendMessage(_textController.text);
//                                         _textController.clear();
//                                       });
//                                     }
//                                   },
//                                   child: const Icon(
//                                     Icons.send,
//                                     color: splashColor,
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       if (!textIsEmpty || _textController.text == '')
//                         Row(
//                           children: [
//                             const SpacingBox(
//                               w: 18,
//                             ),
//                             SizedBox(
//                               width: Sizes.s40,
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             if (!textIsEmpty || _textController.text == '')
//               Positioned(
//                 bottom: Sizes.s10,
//                 right: Sizes.s20,
//                 child: Column(
//                   children: [
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 500),
//                       curve: Curves.fastOutSlowIn,
//                       height: add ? Sizes.s245 : 0,
//                       child: AnimatedOpacity(
//                         opacity: add ? 1 : 0,
//                         duration: const Duration(milliseconds: 500),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               _buildButtonChat(
//                                 onPressed: () {},
//                                 icon: const Icon(Icons.attachment_outlined),
//                               ),
//                               const SpacingBox(
//                                 h: 9,
//                               ),
//                               _buildButtonChat(
//                                 onPressed: () {},
//                                 icon: SvgPicture.asset(
//                                   Assets.camera,
//                                   color: splashColor,
//                                 ),
//                               ),
//                               const SpacingBox(
//                                 h: 9,
//                               ),
//                               _buildButtonChat(
//                                 onPressed: () {},
//                                 icon: SvgPicture.asset(
//                                   Assets.mic,
//                                   color: splashColor,
//                                 ),
//                               ),
//                               const SpacingBox(
//                                 h: 9,
//                               ),
//                               _buildButtonChat(
//                                 onPressed: () {
//                                   setState(() {
//                                     add = false;
//                                   });
//                                 },
//                                 icon: SvgPicture.asset(
//                                   Assets.x,
//                                   color: yellowAccent.withOpacity(0.6),
//                                 ),
//                               ),
//                               const SpacingBox(
//                                 h: 18,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     CircleAvatar(
//                       backgroundColor: white,
//                       radius: Sizes.s25,
//                       child: GestureDetector(
//                         onLongPress: () {
//                           setState(() {
//                             add = !add;
//                           });
//                         },
//                         child: IconButton(
//                           splashRadius: Sizes.s25,
//                           visualDensity: VisualDensity.compact,
//                           onPressed: () {
//                             print('ss');
//                           },
//                           icon: SvgPicture.asset(
//                             Assets.plus,
//                             color: splashColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ]),
//         ),
//       ),
//     );
//   }

//   Widget _buildButtonChat(
//       {required void Function()? onPressed, required Widget icon}) {
//     return CircleAvatar(
//       backgroundColor: white,
//       radius: Sizes.s25,
//       child: IconButton(
//           splashRadius: Sizes.s25,
//           visualDensity: VisualDensity.compact,
//           onPressed: onPressed,
//           icon: icon),
//     );
//   }

//   bool _shouldShowDateSeparator(MessageModel? previousMessage,
//       MessageModel message, MessageListOptions messageListOptions) {
//     if (!messageListOptions.showDateSeparator) {
//       return false;
//     }
//     if (previousMessage == null) {
//       // Means this is the first message
//       return true;
//     }
//     switch (messageListOptions.separatorFrequency) {
//       case SeparatorFrequency.days:
//         final DateTime previousDate =
//             // DateTime(
//             //   timestampToDate(previousMessage.timestamp)!.day,
//             //   timestampToDate(previousMessage.timestamp)!.month,
//             //   timestampToDate(previousMessage.timestamp)!.year,
//             // );
//             DateTime.now();
//         final DateTime messageDate =
//             // DateTime(
//             //   timestampToDate(message.timestamp)!.day,
//             //   timestampToDate(message.timestamp)!.month,
//             //   timestampToDate(message.timestamp)!.year,
//             // );
//             DateTime.now();
//         return previousDate.difference(messageDate).inDays.abs() > 0;
//       case SeparatorFrequency.hours:
//         final DateTime previousDate = DateTime(
//           timestampToDate(previousMessage.timestamp)!.year,
//           timestampToDate(previousMessage.timestamp)!.month,
//           timestampToDate(previousMessage.timestamp)!.day,
//           timestampToDate(previousMessage.timestamp)!.hour,
//         );
//         final DateTime messageDate = DateTime(
//           timestampToDate(message.timestamp)!.year,
//           timestampToDate(message.timestamp)!.month,
//           timestampToDate(message.timestamp)!.day,
//           timestampToDate(message.timestamp)!.hour,
//         );
//         return previousDate.difference(messageDate).inHours.abs() > 0;
//       default:
//         return false;
//     }
//   }
// }
