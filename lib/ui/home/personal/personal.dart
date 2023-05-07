import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fafte/controller/friend_controller.dart';
import 'package:fafte/controller/notification_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/models/comment.dart';
import 'package:fafte/models/like.dart';
import 'package:fafte/models/post.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/home/chat/widget/chat_screen_content.dart';
import 'package:fafte/ui/home/post/widget/comment_screen.dart';
import 'package:fafte/ui/home/post/widget/detail_post_screen.dart';
import 'package:fafte/ui/home/post/widget/item_post_button.dart';
import 'package:fafte/ui/widget/button/back_button.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/debouncer/debouncer.dart';
import 'package:fafte/ui/widget/popup/show_sheet.dart';
import 'package:fafte/ui/widget/skeleton/post_screen_skeleton.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:fafte/utils/export.dart';
import 'package:fafte/utils/snackbars_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PersonalScreen extends StatefulWidget {
  final UserModel? model;
  const PersonalScreen({super.key, this.model});
  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  bool isLoading = false;
  bool isLoadingInvite = false;
  final _debouncer = Debouncer(milliseconds: 500);

  bool isInvited = false;
  FriendController _friendController = FriendController.instance;
  PostController? _controller;
  UserController userModel = UserController.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? _status;
  String? _receiverId;
  String? _inviteId;

  XFile? _pickedBackgroundImage;
  XFile? _pickedAvatarImage;

  bool _isLikePressed = false;
  NotificationController _notificationController =
      NotificationController.instance;
  List<LikeModel>? getUserLikedPost(String postId) {
    return _controller!.listLikePost
        .where((element) => element.postId == postId)
        .toList();
  }

  List<CommentModel>? getUserCommentPost(String postId) {
    return _controller!.listCommentPost
        .where((element) => element.postId == postId)
        .toList();
  }

  Future _likePost(PostModel post) async {
    _controller!.likePost(post.id!).then((response) {
      if (response.success) {
        setState(() {
          _controller?.getLikePost();
        });
      }
    }).catchError((error) {
      ContextExtensions(context).showSnackBar(error);
    });
  }

  Future _unLikePost(userLikePostId) async {
    _controller!.unLikePost(userLikePostId).then((response) {
      if (response.success) {
        setState(() {
          _controller?.getLikePost();
        });
      }
    }).catchError((error) {
      ContextExtensions(context).showSnackBar(error);
    });
  }

  Future<void> _pickBackgroundImage() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedBackgroundImage = imageFile;
    });

    if (_pickedBackgroundImage != null) {
      userModel.updateBackgroundImage(
          widget.model!.id ?? '', _pickedBackgroundImage?.path);
    }
  }

  Future<void> _pickAvatarImage() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedAvatarImage = imageFile;
    });
    if (_pickedAvatarImage != null) {
      userModel.updateAvatarImage(
          widget.model!.id ?? '', _pickedAvatarImage?.path);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      setState(() {
        isLoading = false;
      });
      _controller = Provider.of<PostController>(context);
      _controller!.getAllPostById(widget.model?.id ?? userModel.userModel!.id!);
      _controller!.getLikePost();
      _controller!.getAllCommentPost();
    }
    setState(() {
      isLoading = true;
    });
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

  Future _rejectInvitation() async {
    await _friendController
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

  _acceptInvitation() {
    _friendController.acceptInvitation(_inviteId ?? '').then((response) {
      if (response.success) {
        setState(() {
          isInvited = false;
          _status = 'accepted';
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
        _receiverId = value.receiverId;
        _inviteId = value.id;
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
                                  _buildButtonInvite(),
                                SpacingBox(h: 4),
                                if (auth.currentUser!.uid == widget.model!.id)
                                  Column(
                                    children: [
                                      ItemPostButton(),
                                      SpacingBox(h: 8),
                                    ],
                                  ),
                                _controller?.listPostByIdModel.length == 0
                                    ? Center(
                                        child: Text(
                                          'Không có bài viết nào !',
                                          style: pt16Regular(context),
                                        ),
                                      )
                                    : _buildListPost()
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

  Widget _buildButtonInvite() {
    return Container(
      color: white,
      child: Column(
        children: [
          _status == 'pending' && _receiverId == auth.currentUser!.uid
              ? Row(
                  children: [
                    Expanded(
                      child: BuildTextLinearButton(
                        onTap: _acceptInvitation,
                        text: 'Chấp nhận',
                        borderRadius: BorderRadius.circular(Sizes.s8),
                        height: Sizes.s40,
                        colors: [blueLightGradient, blueDarkGradient],
                      ),
                    ),
                    Expanded(
                      child: BuildTextLinearButton(
                        onTap: () async {
                          if (!isLoadingInvite) {
                            setState(() {
                              isLoadingInvite = true;
                            });
                            await _rejectInvitation();
                            await _friendController
                                .getStatusInvite(widget.model?.id ??
                                    userModel.userModel!.id!)
                                .then((value) {
                              setState(() {
                                _status = value.status;
                                _receiverId = value.receiverId;
                                _inviteId = value.id;

                                print(value.toJson());
                              });
                            });
                            setState(() {
                              isLoadingInvite = false;
                            });
                          }
                        },
                        text: 'Từ chối',
                        borderRadius: BorderRadius.circular(Sizes.s8),
                        height: Sizes.s40,
                      ),
                    ),
                  ],
                )
              : isInvited || _status == 'pending'
                  ? BuildTextLinearButton(
                      onTap: _rejectInvitation,
                      text: 'Hủy lời mời kết bạn',
                      borderRadius: BorderRadius.circular(Sizes.s8),
                      height: Sizes.s40,
                    )
                  : _status == 'accepted'
                      ? Row(
                          children: [
                            Expanded(
                              child: BuildTextLinearButton(
                                onTap: () async {
                                  await _showOptions();
                                  setState(() {});
                                },
                                colors: [blueLightGradient, blueDarkGradient],
                                text: 'Bạn bè',
                                borderRadius: BorderRadius.circular(Sizes.s8),
                                height: Sizes.s40,
                              ),
                            ),
                            Expanded(
                              child: BuildTextLinearButton(
                                onTap: () {
                                  navigateTo(ChatScreenContent(
                                    friend:
                                        widget.model ?? userModel.userModel!,
                                  ));
                                },
                                colors: [blueLightGradient, blueDarkGradient],
                                text: 'Nhắn tin',
                                borderRadius: BorderRadius.circular(Sizes.s8),
                                height: Sizes.s40,
                              ),
                            ),
                          ],
                        )
                      : BuildTextLinearButton(
                          onTap: _sendInvitation,
                          colors: [blueLightGradient, blueDarkGradient],
                          text: 'Thêm bạn bè',
                          borderRadius: BorderRadius.circular(Sizes.s8),
                          height: Sizes.s40,
                        ),
          SpacingBox(
            h: 16,
          ),
        ],
      ),
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
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.s6),
                          child: SizedBox(
                            height: Sizes.s200,
                            width: deviceWidth(context),
                            child: _pickedBackgroundImage != null
                                ? Image.file(
                                    File(_pickedBackgroundImage!.path),
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        widget.model!.backgroundImageUrl ??
                                            userModel.userModel!
                                                .backgroundImageUrl ??
                                            '',
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: greyAccent.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: Sizes.s8,
                          right: Sizes.s8,
                          child: GestureDetector(
                            onTap: () => _pickBackgroundImage(),
                            child: CircleAvatar(
                              radius: Sizes.s15,
                              backgroundColor: white,
                              child: Icon(Icons.camera_alt_outlined,
                                  color: splashColor),
                            ),
                          ),
                        )
                      ],
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
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.s60),
                          child: _pickedAvatarImage != null
                              ? Image.file(
                                  File(_pickedAvatarImage!.path),
                                  fit: BoxFit.cover,
                                  width: Sizes.s120,
                                )
                              : CachedNetworkImage(
                                  imageUrl: widget.model?.profileImageUrl ??
                                      userModel.userModel?.profileImageUrl ??
                                      '',
                                  width: Sizes.s120,
                                  height: Sizes.s120,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    width: Sizes.s120,
                                    height: Sizes.s120,
                                    color: splashColor.withOpacity(0.5),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: Sizes.s4,
                        right: Sizes.s4,
                        child: GestureDetector(
                          onTap: () => _pickAvatarImage(),
                          child: CircleAvatar(
                            radius: Sizes.s15,
                            backgroundColor: white,
                            child: Icon(Icons.camera_alt_outlined,
                                color: splashColor),
                          ),
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
                // InkWell(
                //   onTap: () {},
                //   child: Text(
                //     widget.model?.userName ?? userModel.userModel!.userName!,
                //     style: pt16Regular(context),
                //   ),
                // ),
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
    bool _isLiked = false;
    final listLiked = getUserLikedPost(model.id!);
    bool? isLiked = listLiked?.any(
        (element) => element.userId == _controller?.auth.currentUser?.uid);
    final userLikePost = listLiked?.firstWhere(
      (element) => element.userId == _controller?.auth.currentUser?.uid,
      orElse: () => LikeModel(),
    );
    final listComment = getUserCommentPost(model.id!);

    return Container(
      color: white,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            leading: userModel != null || userModel?.backgroundImageUrl != ''
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      userModel?.profileImageUrl ?? '',
                    ),
                  )
                : CircularProgressIndicator(
                    color: splashColor,
                  ),
            title: InkWell(
              onTap: () {
                navigateTo(PersonalScreen(model: userModel));
              },
              child: Text(
                userModel?.userName ?? '',
                style: pt16Regular(context),
              ),
            ),
            subtitle: Text(
              timestampToDate(model.timeStamp).timeAgoEnShort(),
              style: pt12Regular(context),
            ),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              navigateTo(
                DetailPostScreen(
                  userModel: userModel,
                  model: model,
                ),
              );
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
            padding: EdgeInsets.symmetric(vertical: Sizes.s16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
                  child: Text(
                    model.postText!,
                    style: pt14Regular(context)
                        .copyWith(overflow: TextOverflow.ellipsis),
                    maxLines: 3,
                  ),
                ),
                SizedBox(height: Sizes.s16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
                  child: Divider(height: Sizes.s1),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                      splashColor: greyAccent.withOpacity(0.01),
                      onTap: () => showModalBottomSheet(
                            context: context,
                            useSafeArea: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CommentScreen(
                              postId: model.id ?? '',
                            ),
                          ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Sizes.s12, horizontal: Sizes.s16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  color: splashColor,
                                  size: Sizes.s18,
                                ),
                                SizedBox(width: Sizes.s8),
                                Text(
                                  listLiked?.length.toString() ?? '0',
                                  style: pt14Regular(context),
                                ),
                              ],
                            ),
                            Text(
                              (listComment?.length.toString() ?? '0') +
                                  ' bình luận',
                              style: pt14Regular(context),
                            ),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
                  child: Divider(height: Sizes.s1),
                ),
                SizedBox(
                  height: Sizes.s56,
                  width: deviceWidth(context),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            _debouncer.run(() {
                              setState(() {
                                if (!_isLikePressed) {
                                  // Thực hiện chức năng like
                                  setState(() {
                                    _isLikePressed = true;
                                  });
                                  setState(() {
                                    isLiked == null ||
                                            isLiked ||
                                            _isLiked ||
                                            userLikePost == null
                                        ? _unLikePost(userLikePost?.id ?? '')
                                            .then((value) {
                                            // Move this code outside of the setState function call
                                            // so that it is executed after the function completes
                                            print('Unliked');
                                          })
                                        : _likePost(model).then((value) {
                                            // Move this code outside of the setState function call
                                            // so that it is executed after the function completes
                                            print('Liked');
                                          });
                                  });
                                  // Thiết lập thời gian chờ 1 giây
                                  Future.delayed(Duration(seconds: 1), () {
                                    setState(() {
                                      _isLikePressed = false;
                                    });
                                  });
                                } else {
                                  print('Đang xử lý');
                                }
                              });
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: Sizes.s8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.thumb_up,
                                    color:
                                        isLiked == null || isLiked || _isLiked
                                            ? splashColor
                                            : textColor),
                                SizedBox(width: Sizes.s8),
                                Text(
                                  'Thích',
                                  style: pt14Bold(context).copyWith(
                                      color:
                                          isLiked == null || isLiked || _isLiked
                                              ? splashColor
                                              : textColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CommentScreen(
                              postId: model.id ?? '',
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.message, color: textColor),
                              SizedBox(width: Sizes.s8),
                              Text(
                                'Bình luận',
                                style: pt14Bold(context)
                                    .copyWith(color: textColor),
                              ),
                            ],
                          ),
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

  Future _showOptions() async {
    showSheet(context,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.s32),
          child: InkWell(
            onTap: () async {
              if (!isLoadingInvite) {
                setState(() {
                  isLoadingInvite = true;
                });
                await _rejectInvitation();
                await _friendController
                    .getStatusInvite(
                        widget.model?.id ?? userModel.userModel!.id!)
                    .then((value) {
                  setState(() {
                    _status = value.status;
                    _receiverId = value.receiverId;
                    _inviteId = value.id;

                    print(value.toJson());
                  });
                });
                setState(() {
                  isLoadingInvite = false;
                });
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s16, vertical: Sizes.s8),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.userMinus,
                    width: Sizes.s24,
                    height: Sizes.s24,
                  ),
                  SpacingBox(w: 16),
                  Expanded(
                    child: Text('Hủy kết bạn', style: pt16Bold(context)),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
