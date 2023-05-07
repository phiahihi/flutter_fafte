import 'package:fafte/controller/notification_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/models/comment.dart';
import 'package:fafte/models/like.dart';
import 'package:fafte/models/post.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/home/personal/personal.dart';
import 'package:fafte/ui/widget/button/back_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/debouncer/debouncer.dart';
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

  final _debouncer = Debouncer(milliseconds: 500);

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
      _controller?.getAllCommentPost();
      setState(() {});
    });
  }

  Future _likePost(String postId) async {
    _controller!.likePost(postId).then((response) {
      if (response.success) {
        setState(() {
          _controller?.getLikePost();
        });
      }
    }).catchError((error) {
      ContextExtensions(context).showSnackBar(error);
    });
  }

  Future _unLikePost(String userLikePostId) async {
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
    final listCommentPost = _controller?.listCommentPostById;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              leading: widget.userModel != null ||
                                      widget.userModel?.backgroundImageUrl != ''
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        widget.userModel!.profileImageUrl ?? '',
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
                                                              userLikePost ==
                                                                  null
                                                          ? _unLikePost(
                                                                  userLikePost
                                                                          ?.id ??
                                                                      '')
                                                              .then((value) {
                                                              // Move this code outside of the setState function call
                                                              // so that it is executed after the function completes
                                                              print('Unliked');
                                                            })
                                                          : _likePost(widget
                                                                      .model
                                                                      .id ??
                                                                  '')
                                                              .then((value) {
                                                              // Move this code outside of the setState function call
                                                              // so that it is executed after the function completes
                                                              print('Liked');
                                                            });
                                                    });
                                                    // Thiết lập thời gian chờ 1 giây
                                                    Future.delayed(
                                                        Duration(seconds: 1),
                                                        () {
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
                        ListView.builder(
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

                          _commentController.clear();

                          await _controller
                              ?.commentPost(widget.model.id!)
                              .then((response) {
                            if (response.success) {
                              setState(() {
                                isLoading = false;
                                _controller
                                    ?.getCommentPostById(widget.model.id!);
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
    return InkWell(
      onLongPress: () {
        if (_controller?.auth.currentUser?.uid == commentModel.userId) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Xóa bình luận'),
              content: Text('Bạn có chắc chắn muốn xóa bình luận này?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    _controller?.deleteCommentPostById(commentModel.id ?? '');
                    _controller?.getCommentPostById(widget.model.id!);

                    Navigator.pop(context);
                  },
                  child: Text('Xóa'),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(horizontal: Sizes.s16, vertical: Sizes.s8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user?.backgroundImageUrl != null || user?.backgroundImageUrl != ''
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      user?.profileImageUrl ?? '',
                    ),
                  )
                : CircleAvatar(),
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
