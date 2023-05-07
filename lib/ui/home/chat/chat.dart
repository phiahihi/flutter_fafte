import 'package:fafte/controller/chat_controller.dart';
import 'package:fafte/models/item_message.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/home/chat/widget/chat_screen_content.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/utils/export.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController? _chatController;

  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_chatController == null) {
      isLoading = false;
      _chatController = Provider.of<ChatController>(context);
      _chatController?.getAllBoxChat();
    }
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
          child: Column(
        children: [
          // _buildSearchUser(context),
          Expanded(
            child: Container(
              color: whiteAccent,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // SpacingBox(
                    //   h: 15,
                    // ),
                    // SpacingBox(
                    //   h: 13,
                    // ),
                    // SizedBox(
                    //   height: Sizes.s50,
                    //   child: ListView(
                    //     shrinkWrap: true,
                    //     scrollDirection: Axis.horizontal,
                    //     physics: BouncingScrollPhysics(),
                    //     children: [
                    //       _buildActive(),
                    //       _buildActive(),
                    //       _buildActive(),
                    //       _buildActive(),
                    //       _buildActive(),
                    //       _buildActive(),
                    //       _buildActive(),
                    //     ],
                    //   ),
                    // ),
                    SpacingBox(
                      h: 13,
                    ),
                    if (_chatController?.listBoxId != []) _buildListBoxChat(),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget _buildListBoxChat() {
    return ListView.separated(
      separatorBuilder: (context, index) => SpacingBox(h: 8),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return FutureBuilder<ItemMessageModel>(
          future: _chatController
              ?.getItemMessage(_chatController!.listBoxId[index]),
          builder: (context, snapshot) {
            final itemMessageModel = snapshot.data;
            return _buildItemMessage(
              context,
              itemMessageModel: itemMessageModel,
              friend: itemMessageModel?.userModel ?? UserModel(),
            );
          },
        );
      },
      itemCount: _chatController?.listBoxId.length ?? 0,
    );
  }

  Widget _buildSearchUser(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.s8, horizontal: Sizes.s16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(Assets.search),
          ),
          SpacingBox(
            w: 4,
          ),
          Expanded(
            child: InkWell(
              onTap: () {},
              child: Container(
                height: Sizes.s40,
                padding: EdgeInsets.all(Sizes.s10),
                child: Text(
                  S.current.search,
                  style: pt16Regular(context),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          SpacingBox(
            w: 4,
          ),
          GestureDetector(onTap: () {}, child: SvgPicture.asset(Assets.plus)),
        ],
      ),
    );
  }

  Widget _buildItemMessage(
    BuildContext context, {
    ItemMessageModel? itemMessageModel,
    required UserModel friend,
  }) {
    return InkWell(
      onTap: () {
        navigateTo(ChatScreenContent(
          friend: friend,
        ));
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: Sizes.s16).copyWith(top: Sizes.s8),
        child: Column(
          children: [
            Row(
              children: [
                if (itemMessageModel?.userModel?.profileImageUrl == null ||
                    itemMessageModel?.userModel?.profileImageUrl == '')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.s50),
                    child: Image.asset(
                      Assets.logo,
                      width: Sizes.s50,
                      height: Sizes.s50,
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Sizes.s50),
                    child: Image.network(
                      itemMessageModel?.userModel?.profileImageUrl ?? '',
                      width: Sizes.s50,
                      height: Sizes.s50,
                      fit: BoxFit.cover,
                    ),
                  ),
                SpacingBox(
                  w: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (itemMessageModel == null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Darien Don',
                              style: pt14Bold(context).copyWith(
                                  fontSize: Sizes.s13, color: textColor2),
                            ),
                            Text(
                              '15:28 PM',
                              style: pt12Regular(context)
                                  .copyWith(color: textColor),
                            )
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                itemMessageModel.userModel?.userName ?? '',
                                style: pt14Bold(context).copyWith(
                                    fontSize: Sizes.s13,
                                    color: textColor2,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            Text(
                              timestampToDate(
                                      itemMessageModel.messageModel?.timestamp)
                                  .timeAgoEnShort(),
                              style: pt12Regular(context)
                                  .copyWith(color: textColor),
                            )
                          ],
                        ),
                      SpacingBox(
                        h: 5,
                      ),
                      Row(
                        children: [
                          if (itemMessageModel == null)
                            Text(
                              'Great! Do you Love it.',
                              style: pt14Regular(context)
                                  .copyWith(fontSize: Sizes.s13),
                            )
                          else
                            Expanded(
                              child: Row(
                                children: [
                                  if (itemMessageModel.messageModel?.senderId ==
                                      FirebaseAuth.instance.currentUser!.uid)
                                    Text(
                                      'Bạn: ',
                                      style: pt14Regular(context)
                                          .copyWith(fontSize: Sizes.s13),
                                    ),
                                  Expanded(
                                    child: Text(
                                      itemMessageModel
                                              .messageModel?.messageText! ??
                                          '',
                                      style: pt14Regular(context)
                                          .copyWith(fontSize: Sizes.s13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SpacingBox(
              w: 8,
            ),
            Row(
              children: [
                SizedBox(
                  width: Sizes.s50,
                ),
                SpacingBox(
                  w: 15,
                ),
                Expanded(
                    child: Divider(
                  color: greyAccent,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActive() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s8),
      child: SizedBox(
        width: Sizes.s50,
        height: Sizes.s50,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.s25),
              child: Image.asset(
                Assets.logo,
                fit: BoxFit.contain,
                width: Sizes.s50,
                height: Sizes.s50,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: Sizes.s15,
                height: Sizes.s15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.s100),
                  color: Colors.green,
                  border: Border.all(width: Sizes.s2, color: whiteAccent),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
