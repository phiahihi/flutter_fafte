import 'package:fafte/controller/friend_controller.dart';
import 'package:fafte/models/friend.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/home/personal/personal.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/skeleton/invite_skeleton.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:fafte/utils/export.dart';
import 'package:fafte/utils/snackbars_utils.dart';

class AllInviteScreen extends StatefulWidget {
  const AllInviteScreen({super.key});

  @override
  State<AllInviteScreen> createState() => _AllInviteScreenState();
}

class _AllInviteScreenState extends State<AllInviteScreen> {
  final _controller = FriendController.instance;

  void _rejectInvitation(String userId) async {
    _controller.rejectInvitation(userId).then((response) async {
      if (response.success) {
        await _controller.getAllInvitation();
        await _controller.get10Invitation();
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
    _controller.acceptInvitation(invitationId).then((response) async {
      if (response.success) {
        await _controller.getAllInvitation();
        await _controller.get10Invitation();

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
      appBar: AppBar(
        backgroundColor: splashColor,
        title: Text(
          'Lời mời kết bạn',
          style: pt20Bold(context).copyWith(color: Colors.white),
        ),
      ),
      body: _buildListInvite(),
    );
  }

  Widget _buildListInvite() {
    if (_controller.listAllInvite.length > 0) {
      print(_controller.listAllInvite);
      return ListView.separated(
        separatorBuilder: (context, index) => SpacingBox(h: 8),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return FutureBuilder<UserModel>(
            future: _controller
                .getSender(_controller.listAllInvite[index].senderId!),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return _buildItemInvite(user, _controller.listAllInvite[index]);
            },
          );
        },
        itemCount: _controller.listAllInvite.length,
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
      onTap: () {
        navigateTo(PersonalScreen(model: friendModel));
      },
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
                    backgroundImage: friendModel.profileImageUrl == null ||
                            friendModel.profileImageUrl == ''
                        ? null
                        : NetworkImage(
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
                        Expanded(
                          child: Text(
                            friendModel.userName!,
                            style: pt16Regular(context)
                                .copyWith(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SpacingBox(w: 16),
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
