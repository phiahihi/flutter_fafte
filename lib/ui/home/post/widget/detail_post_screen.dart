import 'package:fafte/controller/notification_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/models/comment.dart';
import 'package:fafte/models/like.dart';
import 'package:fafte/models/post.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/home/personal/personal.dart';
import 'package:fafte/ui/widget/button/back_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:fafte/utils/export.dart';
import 'package:fafte/utils/snackbars_utils.dart';
import 'package:provider/provider.dart';

class DetailPostScreen extends StatefulWidget {
  final PostModel model;
  final UserModel? userModel;
  const DetailPostScreen({super.key, required this.model, this.userModel});

  @override
  State<DetailPostScreen> createState() => _DetailPostScreenState();
}

class _DetailPostScreenState extends State<DetailPostScreen> {
  PostController? _controller;
  bool _isLikePressed = false;
  late FocusNode myFocusNode;

  NotificationController _notificationController =
      NotificationController.instance;

  List<LikeModel>? getUserLikedPost(String postId) {
    return _controller?.listLikePost
        .where((element) => element.postId == postId)
        .toList();
  }

  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller?.getLikePost();

      setState(() {});
    });
  }

  void _likePost(String postId) async {
    final token = await _notificationController.messaging.getToken();
    _controller!.likePost(postId).then((response) async {
      if (response.success) {
        _notificationController.sendNotification(
          'Like',
          'Someone liked your post',
          token.toString(),
        );
        setState(() {
          _controller?.listLikePost.add(
            LikeModel(
              id: response.message,
              userId: _controller?.auth.currentUser?.uid,
              postId: postId,
              timestamp: DateTime.now().millisecondsSinceEpoch,
            ),
          );
        });
      }
    }).catchError((error) {
      ContextExtensions(context).showSnackBar(error);
    });
  }

  void _unLikePost(userLikePostId) async {
    _controller!.unLikePost(userLikePostId).then((response) async {
      if (response.success) {
        setState(() {
          _controller?.listLikePost.removeWhere(
            (element) =>
                element.userId == _controller?.auth.currentUser?.uid &&
                element.id == userLikePostId,
          );
        });
      }
    }).catchError((error) {
      ContextExtensions(context).showSnackBar(error);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      _controller = Provider.of<PostController>(context);
      _controller?.getAllPost();
      _controller?.getCommentPostById(widget.model.id!);
      setState(() {});
    }
    setState(() {});
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  bool isLoading = false;
  String comment = '';

  @override
  Widget build(BuildContext context) {
    bool _isLiked = false;
    final listLiked = getUserLikedPost(widget.model.id!);
    bool? isLiked = listLiked?.any(
        (element) => element.userId == _controller?.auth.currentUser?.uid);
    final userLikePost = listLiked?.firstWhere(
      (element) => element.userId == _controller?.auth.currentUser?.uid,
      orElse: () => LikeModel(),
    );
    final listCommentPost = _controller?.listCommentPost
        .where((element) => element.postId == widget.model.id)
        .toList();
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              leading: widget.userModel != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        widget.userModel!.profileImageUrl!,
                                      ),
                                    )
                                  : CircularProgressIndicator(
                                      color: splashColor,
                                    ),
                              title: Text(
                                widget.userModel?.userName ?? '',
                                style: pt16Regular(context),
                              ),
                              subtitle: Text(
                                timestampToDate(widget.model.timeStamp)
                                    .timeAgoEnShort(),
                                style: pt12Regular(context),
                              ),
                              trailing: Icon(Icons.more_vert),
                              onTap: () {
                                navigateTo(PersonalScreen(
                                  model: widget.userModel,
                                ));
                              },
                            ),
                            if (widget.model.postImageUrl != '')
                              Container(
                                height: Sizes.s300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        widget.model.postImageUrl!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: Sizes.s16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Sizes.s16),
                                    child: Text(
                                      widget.model.postText!,
                                      style: pt14Regular(context).copyWith(
                                          overflow: TextOverflow.ellipsis),
                                      maxLines: 3,
                                    ),
                                  ),
                                  SizedBox(height: Sizes.s16),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Sizes.s16),
                                    child: Divider(height: Sizes.s1),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: Sizes.s12,
                                        horizontal: Sizes.s16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              listLiked?.length.toString() ??
                                                  '0',
                                              style: pt14Regular(context),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          (listCommentPost?.length.toString() ??
                                                  '0') +
                                              ' bình luận',
                                          style: pt14Regular(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Sizes.s16),
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
                                              if (!_isLikePressed) {
                                                // Thực hiện chức năng like
                                                setState(() {
                                                  _isLikePressed = true;

                                                  isLiked == null ||
                                                          isLiked ||
                                                          _isLiked ||
                                                          userLikePost == null
                                                      ? _unLikePost(
                                                          userLikePost?.id ??
                                                              '')
                                                      : _likePost(
                                                          widget.model.id!);
                                                });
                                                // Thiết lập thời gian chờ 1 giây
                                                Future.delayed(
                                                    Duration(seconds: 1), () {
                                                  _isLikePressed = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Sizes.s8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.thumb_up,
                                                      color: isLiked == null ||
                                                              isLiked ||
                                                              _isLiked
                                                          ? splashColor
                                                          : textColor),
                                                  SizedBox(width: Sizes.s8),
                                                  Text(
                                                    'Thích',
                                                    style: pt14Bold(context)
                                                        .copyWith(
                                                            color: isLiked ==
                                                                        null ||
                                                                    isLiked ||
                                                                    _isLiked
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
                                            onTap: () =>
                                                myFocusNode.requestFocus(),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.message,
                                                      color: textColor),
                                                  SizedBox(width: Sizes.s8),
                                                  Text(
                                                    'Bình luận',
                                                    style: pt14Bold(context)
                                                        .copyWith(
                                                            color: textColor),
                                                  ),
                                                ],
                                              ),
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
                        ListView.separated(
                          separatorBuilder: (context, index) =>
                              SpacingBox(h: 8),
                          shrinkWrap: true,
                          reverse: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return FutureBuilder<UserModel>(
                              future: _controller
                                  ?.getPoster(listCommentPost![index].userId!),
                              builder: (context, snapshot) {
                                final user = snapshot.data;
                                return _buildItemComment(
                                    listCommentPost![index], user);
                              },
                            );
                          },
                          itemCount: listCommentPost?.length ?? 0,
                        ),
                        SpacingBox(h: 70),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Spacer(),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(Sizes.s8),
                child: Row(
                  children: [
                    Expanded(
                      child: BuildTextField(
                        onChanged: (p0) => setState(() {
                          comment = p0;
                        }),
                        focusNode: myFocusNode,
                        controller: _commentController,
                        hintText: 'Viết bình luận...',
                        hintStyle: pt14Regular(context),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (isLoading) return;
                        if (_commentController.text.isNotEmpty) {
                          _controller?.commentText = _commentController.text;
                          setState(() {
                            isLoading = true;
                          });
                          _controller?.listCommentPost.add(CommentModel(
                            userId: _controller?.auth.currentUser?.uid,
                            postId: widget.model.id,
                            commentText: _commentController.text,
                            timestamp: DateTime.now().millisecondsSinceEpoch,
                          ));
                          _commentController.clear();

                          await _controller
                              ?.commentPost(widget.model.id!)
                              .then((response) {
                            if (response.success) {
                              print('sss');
                              setState(() {
                                isLoading = false;
                                _controller?.getAllPostById(widget.model.id!);
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }).catchError((error) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(Sizes.s8),
                        child: Icon(
                          Icons.send,
                          color: comment != '' ? splashColor : textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildItemComment(CommentModel commentModel, UserModel? user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          user != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.profileImageUrl!,
                  ),
                )
              : CircularProgressIndicator(
                  color: splashColor,
                ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.s16),
                      color: greyAccent.withOpacity(0.2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(Sizes.s8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.userName ?? '',
                            style: pt16Bold(context),
                          ),
                          Text(
                            commentModel.commentText ?? '',
                            style: pt16Regular(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SpacingBox(h: 4),
                  Text(
                    timestampToDate(commentModel.timestamp).timeAgoEnShort(),
                    style: pt12Regular(context).copyWith(color: greyAccent),
                  )
                ],
              ),
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
                  widget.userModel?.userName ?? '',
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
}