import 'package:fafte/controller/friend_controller.dart';
import 'package:fafte/models/friend.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/home/personal/personal.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/skeleton/invite_skeleton.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:fafte/utils/export.dart';
import 'package:fafte/utils/snackbars_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class AllFriendScreen extends StatefulWidget {
  const AllFriendScreen({super.key});

  @override
  State<AllFriendScreen> createState() => _AllFriendScreenState();
}

class _AllFriendScreenState extends State<AllFriendScreen> {
  FriendController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      _controller = Provider.of<FriendController>(context);
      _controller!.getAllFriend();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: splashColor,
        title: Text(
          'Danh sách bạn bè',
          style: pt20Bold(context).copyWith(color: Colors.white),
        ),
      ),
      body: _controller?.listAllFriend != null
          ? _buildListInvite()
          : InviteSkeleton(),
    );
  }

  Widget _buildListInvite() {
    if (_controller!.listAllFriend.length > 0) {
      return ListView.separated(
        separatorBuilder: (context, index) => SpacingBox(h: 8),
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return FutureBuilder<UserModel>(
            future: _controller!.getSender(
                _controller!.listAllFriend[index].senderId! ==
                        FirebaseAuth.instance.currentUser!.uid
                    ? _controller!.listAllFriend[index].receiverId!
                    : _controller!.listAllFriend[index].senderId!),
            builder: (context, snapshot) {
              final user = snapshot.data;
              return _buildItemInvite(user, _controller!.listAllFriend[index]);
            },
          );
        },
        itemCount: _controller!.listAllFriend.length,
      );
    } else {
      return Center(
          child: Text(
        "Không có bạn bè",
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
                    radius: Sizes.s30,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (friendModel != null)
                    Text(
                      friendModel.userName!,
                      style: pt20Bold(context)
                          .copyWith(overflow: TextOverflow.ellipsis),
                    )
                  else
                    Text(
                      'Nguyễn Đức Hoàng Phi',
                      style: pt16Regular(context),
                    ),
                  SpacingBox(
                    h: 8,
                  ),
                  Text(
                    timestampToDate(invite.timestamp).timeAgoEnShort(),
                    style: pt14Regular(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
