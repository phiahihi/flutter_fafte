import 'package:fafte/controller/friend_controller.dart';
import 'package:fafte/utils/snackbars_utils.dart';
import 'package:fafte/models/friend.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/skeleton/invite_skeleton.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:fafte/utils/export.dart';
import 'package:provider/provider.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  FriendController? _controller;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      _controller = Provider.of<FriendController>(context);
      _controller?.get10Invitation();
    }
  }

  void _rejectInvitation(String userId) async {
    _controller!.rejectInvitation(userId).then((response) async {
      if (response.success) {
        await _controller?.get10Invitation();
        setState(() {});
        ContextExtensions(context).showSnackBar(response.message);
      } else {
        ContextExtensions(context).showSnackBar(response.message);
      }
    }).catchError((error) {
      ContextExtensions(context).showSnackBar(error);
    });
  }

  void _acceptInvitation(String invitationId) async {
    _controller!.acceptInvitation(invitationId).then((response) async {
      if (response.success) {
        await _controller?.get10Invitation();
        setState(() {});
        ContextExtensions(context).showSnackBar(response.message);
      } else {
        ContextExtensions(context).showSnackBar(response.message);
      }
    }).catchError((error) {
      ContextExtensions(context).showSnackBar(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
        child: Container(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Sizes.s16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bạn bè',
                                style: pt20Bold(context),
                              ),
                              Container(
                                width: Sizes.s40,
                                height: Sizes.s40,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Sizes.s20),
                                  color: splashColor.withOpacity(0.1),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: const Size(0, 0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.s20),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.search_outlined,
                                    color: splashColor,
                                    size: Sizes.s32,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Sizes.s16),
                            ),
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                            backgroundColor: splashColor,
                          ),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Bạn bè',
                              style: pt16Bold(context).copyWith(color: white),
                            ),
                          ),
                        ),
                        SpacingBox(
                          h: 16,
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: Sizes.s16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Lời mời kết bạn',
                                      style: pt14Bold(context)),
                                  SpacingBox(
                                    w: 4,
                                  ),
                                  Text(
                                    '128',
                                    style: pt14Regular(context),
                                  )
                                ],
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(
                                      0,
                                      0,
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
                                child: Text(
                                  'Xem tất cả',
                                  style: pt14Regular(context),
                                ),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_controller?.list10Invite != null)
                    _buildListInvite()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InviteSkeleton();
                      },
                      itemCount: 5,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListInvite() {
    if (_controller!.list10Invite.length > 0) {
      return ListView.separated(
        separatorBuilder: (context, index) => SpacingBox(h: 8),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return FutureBuilder<UserModel>(
            future: _controller
                ?.getSender(_controller!.list10Invite[index].senderId!),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return _buildItemInvite(user, _controller!.list10Invite[index]);
            },
          );
        },
        itemCount: _controller?.list10Invite.length ?? 0,
      );
    } else {
      return Center(
          child: Text(
        "Không có lời mời kết bạn",
        style: pt16Regular(context),
      ));
    }
  }

  Widget _buildItemInvite(UserModel? friendModel, FriendModel invite) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: Sizes.s8, horizontal: Sizes.s16),
        child: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(Sizes.s40),
            //   child: Image.network(
            //     friendModel?.profileImageUrl ?? '',
            //     width: Sizes.s80,
            //     height: Sizes.s80,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            friendModel != null
                ? CircleAvatar(
                    radius: Sizes.s40,
                    backgroundImage: NetworkImage(
                      friendModel.profileImageUrl!,
                    ),
                  )
                : CircularProgressIndicator(
                    color: splashColor,
                  ),
            SpacingBox(
              w: 16,
            ),
            Expanded(
              child: Column(
                children: [
                  if (friendModel != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          friendModel.userName!,
                          style: pt16Regular(context),
                        ),
                        Text(
                          timestampToDate(invite.timestamp).timeAgoEnShort(),
                          style: pt14Regular(context),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nguyễn Đức Hoàng Phi',
                          style: pt16Regular(context),
                        ),
                        Text(
                          '5 năm',
                          style: pt14Regular(context),
                        ),
                      ],
                    ),
                  SpacingBox(
                    h: 12,
                  ),
                  Row(
                    children: [
                      _buildTextButton(
                        backgroundColor: blueLightGradient,
                        onPressed: () {
                          _acceptInvitation(invite.id!);
                        },
                        textColor: white,
                        text: 'Chấp nhận',
                      ),
                      SpacingBox(
                        w: 8,
                      ),
                      _buildTextButton(
                        backgroundColor: splashColor,
                        onPressed: () {
                          print(invite.senderId);
                          _rejectInvitation(invite.senderId!);
                        },
                        textColor: white,
                        text: 'Xóa bỏ',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton({
    required Color backgroundColor,
    required void Function()? onPressed,
    required Color textColor,
    required String text,
    BorderRadiusGeometry? borderRadius,
  }) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(Sizes.s8)),
            backgroundColor: backgroundColor,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: const Size(0, 0)),
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.s8),
          child: Text(
            text,
            style: pt14Regular(context).copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
