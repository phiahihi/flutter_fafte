import 'package:cached_network_image/cached_network_image.dart';
import 'package:fafte/controller/friend_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/models/post.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/home/post/widget/item_post_button.dart';
import 'package:fafte/ui/widget/button/back_button.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/skeleton/post_screen_skeleton.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:fafte/utils/export.dart';
import 'package:fafte/utils/snackbars_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class PersonalScreen extends StatefulWidget {
  final UserModel? model;
  const PersonalScreen({super.key, this.model});
  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  bool isLoading = false;
  bool isInvited = false;
  FriendController _friendController = FriendController.instance;
  PostController? _controller;
  UserController userModel = UserController.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? _status;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      setState(() {
        isLoading = false;
      });
      _controller = Provider.of<PostController>(context);
      _controller!.getAllPostById(widget.model?.id ?? userModel.userModel!.id!);
    }
    setState(() {
      isLoading = true;
    });
    print(_controller!.listPostByIdModel);
  }

  _sendInvitation() {
    setState(() {
      isInvited = false;
    });
    _friendController
        .sendInvitation(widget.model?.id ?? userModel.userModel!.id!)
        .then((response) {
      if (response.success) {
        setState(() {
          isInvited = true;
        });
        ContextExtensions(context).showSnackBar(response.message);
      } else {
        setState(() {
          isInvited = false;
        });
        ContextExtensions(context).showSnackBar(response.message);
      }
    }).catchError((error) {
      setState(() {
        isInvited = false;
      });
      ContextExtensions(context).showSnackBar(error);
    });
  }

  _rejectInvitation() {
    _friendController
        .rejectInvitation(widget.model?.id ?? userModel.userModel!.id!)
        .then((response) {
      if (response.success) {
        setState(() {
          isInvited = false;
        });
        ContextExtensions(context).showSnackBar(response.message);
      } else {
        ContextExtensions(context).showSnackBar(response.message);
      }
    }).catchError((error) {
      ContextExtensions(context).showSnackBar(error);
    });
  }

  @override
  void initState() {
    super.initState();
    _friendController
        .getStatusInvite(widget.model?.id ?? userModel.userModel!.id!)
        .then((value) {
      setState(() {
        _status = value.status;
      });
    });
  }

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent.withOpacity(0.8),
      body: isLoading
          ? SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isLoading = false;
                  });
                  _controller?.getAllPostById(
                      widget.model?.id ?? userModel.userModel!.id!);
                },
                color: splashColor,
                child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowGlow();
                      return true;
                    },
                    child: Column(
                      children: [
                        _buildAppBar(context),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildInfo(context),
                                if (auth.currentUser!.uid != widget.model!.id)
                                  Container(
                                    color: white,
                                    child: Column(
                                      children: [
                                        isInvited || _status == 'pending'
                                            ? BuildTextLinearButton(
                                                onTap: _rejectInvitation,
                                                text: 'Hủy lời mời kết bạn',
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Sizes.s8),
                                                height: Sizes.s40,
                                              )
                                            : BuildTextLinearButton(
                                                onTap: _sendInvitation,
                                                colors: [
                                                  blueLightGradient,
                                                  blueDarkGradient
                                                ],
                                                text: 'Thêm bạn bè',
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Sizes.s8),
                                                height: Sizes.s40,
                                              ),
                                        SpacingBox(
                                          h: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                SpacingBox(h: 4),
                                if (auth.currentUser!.uid == widget.model!.id)
                                  Column(
                                    children: [
                                      ItemPostButton(),
                                      SpacingBox(h: 8),
                                    ],
                                  ),
                                _buildListPost()
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            )
          : PostScreenSkeleton(),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Container(
      color: white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(Sizes.s8),
            child: Stack(
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Sizes.s6),
                      child: SizedBox(
                        height: Sizes.s200,
                        width: deviceWidth(context),
                        child: CachedNetworkImage(
                          imageUrl: widget.model!.profileImageUrl ??
                              userModel.userModel!.profileImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Sizes.s60,
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: Sizes.s64,
                        backgroundColor: white,
                      ),
                      Positioned(
                        top: Sizes.s4,
                        left: Sizes.s4,
                        child: CircleAvatar(
                          radius: Sizes.s60,
                          backgroundImage: NetworkImage(
                              widget.model?.profileImageUrl ??
                                  userModel.userModel!.profileImageUrl!),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model?.userName ?? userModel.userModel!.userName!,
                  style: pt22Bold(context).copyWith(fontSize: Sizes.s28),
                ),
                SpacingBox(
                  h: 8,
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    widget.model?.userName ?? userModel.userModel!.userName!,
                    style: pt16Regular(context),
                  ),
                ),
                SpacingBox(
                  h: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: white,
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: Sizes.s8, horizontal: Sizes.s16),
        child: Row(
          children: [
            BuildBackButton(),
            Expanded(
              child: Center(
                child: Text(
                  widget.model?.userName ?? userModel.userModel!.userName!,
                  style: pt20Bold(context)
                      .copyWith(overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            SizedBox(
              width: Sizes.s30,
              height: Sizes.s30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListPost() {
    return ListView.separated(
      separatorBuilder: (context, index) => SpacingBox(h: 8),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return FutureBuilder<UserModel>(
          future: _controller
              ?.getPoster(_controller!.listPostByIdModel[index].userId!),
          builder: (context, snapshot) {
            final user = snapshot.data;
            return _buildItemPost(_controller!.listPostByIdModel[index], user);
          },
        );
      },
      itemCount: _controller?.listPostByIdModel.length ?? 0,
    );
  }

  Widget _buildItemPost(PostModel model, UserModel? userModel) {
    return Container(
      color: white,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            leading: userModel != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      userModel.profileImageUrl!,
                    ),
                  )
                : CircularProgressIndicator(
                    color: splashColor,
                  ),
            title: Text(
              userModel?.userName ?? '',
              style: pt16Regular(context),
            ),
            subtitle: Text(
              timestampToDate(model.timeStamp).timeAgoEnShort(),
              style: pt12Regular(context),
            ),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              print('sss');
            },
          ),
          if (model.postImageUrl != '')
            Container(
              height: Sizes.s300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(model.postImageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(Sizes.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  model.postText!,
                  style: pt14Regular(context)
                      .copyWith(overflow: TextOverflow.ellipsis),
                  maxLines: 3,
                ),
                SizedBox(height: Sizes.s16),
                Divider(),
                SizedBox(
                  height: Sizes.s56,
                  width: deviceWidth(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: Sizes.s8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.thumb_up),
                                SizedBox(width: Sizes.s8),
                                Text(
                                  'Like',
                                  style: pt14Bold(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.message),
                            SizedBox(width: Sizes.s8),
                            Text(
                              'Comment',
                              style: pt14Bold(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemNew(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.s10),
          child: Image.asset(
            Assets.logo,
            fit: BoxFit.cover,
            width: Sizes.s100,
            height: Sizes.s148,
          ),
        ),
        Positioned(
          top: Sizes.s10,
          left: Sizes.s10,
          child: Stack(children: [
            Container(
              width: Sizes.s36,
              height: Sizes.s36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.s40),
                color: Colors.transparent,
                border: Border.all(color: white, width: Sizes.s2),
              ),
            ),
            SizedBox(
              width: Sizes.s40,
              height: Sizes.s40,
              child: Padding(
                padding: EdgeInsets.all(Sizes.s6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.s32),
                  child: Image.asset(
                    Assets.onboarding1,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ]),
        ),
        Positioned(
          bottom: Sizes.s12,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s10),
            child: Text(
              'Anuska Sharma',
              style: pt12Bold(context).copyWith(color: white),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        )
      ],
    );
  }
}
