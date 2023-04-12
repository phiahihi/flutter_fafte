import 'dart:async';

import 'package:fafte/controller/notification_controller.dart';
import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/models/like.dart';
import 'package:fafte/models/post.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/home/personal/personal.dart';
import 'package:fafte/ui/home/post/widget/comment_screen.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/skeleton/post_screen_skeleton.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:fafte/utils/export.dart';
import 'package:provider/provider.dart';
import 'widget/item_post_button.dart';
import 'package:fafte/utils/snackbars_utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({
    super.key,
  });
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool isLoading = false;
  bool _isLikePressed = false;
  PostController? _controller;
  NotificationController _notificationController =
      NotificationController.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      isLoading = false;
      _controller = Provider.of<PostController>(context);
      _controller?.getAllPost();
      _controller?.getAllCommentPost();
      setState(() {});
    }
    setState(() {
      isLoading = true;
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

  List<LikeModel>? getUserLikedPost(String postId) {
    return _controller!.listLikePost
        .where((element) => element.postId == postId)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller?.getLikePost();

      setState(() {});
    });
  }

  final ScrollController scrollController = ScrollController();

  _refreshPost() async {
    setState(() {
      isLoading = false;
    });
    await _controller?.getAllPost();
    await _controller?.getLikePost();
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: splashColor.withOpacity(0.1),
      body: isLoading
          ? RefreshIndicator(
              onRefresh: () async {
                _refreshPost();
              },
              color: splashColor,
              child: SafeArea(
                child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowGlow();
                      return true;
                    },
                    child: ListView(
                      children: [
                        ItemPostButton(),
                        // SpacingBox(h: 8),
                        // _buildNewFeed(context),
                        SpacingBox(h: 8),
                        _buildListPost()
                      ],
                    )),
              ),
            )
          : PostScreenSkeleton(),
    );
  }

  Widget _buildListPost() {
    return ListView.separated(
      separatorBuilder: (context, index) => SpacingBox(h: 8),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return FutureBuilder<UserModel>(
          future:
              _controller?.getPoster(_controller!.listPostModel[index].userId!),
          builder: (context, snapshot) {
            final user = snapshot.data;
            return _buildItemPost(_controller!.listPostModel[index], user);
          },
        );
      },
      itemCount: _controller?.listPostModel.length ?? 0,
    );
  }

  Widget _buildNewFeed(BuildContext context) {
    return Container(
      color: white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.current.whatsNew,
                  style: pt20Bold(context),
                ),
                Text(
                  S.current.showAll,
                  style: pt14Regular(context).copyWith(color: textColor),
                ),
              ],
            ),
          ),
          SpacingBox(
            h: 11,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
            child: Row(
              children: [
                _buildItemNew(context),
              ],
            ),
          ),
        ],
      ),
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
    final listCommentPost = _controller?.listCommentPost
        .where((element) => element.postId == model.id)
        .toList();

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
              navigateTo(PersonalScreen(model: userModel));
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
                              listComment: listCommentPost ?? [],
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
                              (listCommentPost?.length.toString() ?? '0') +
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
                            if (!_isLikePressed) {
                              // Thực hiện chức năng like
                              setState(() {
                                _isLikePressed = true;

                                isLiked == null ||
                                        isLiked ||
                                        _isLiked ||
                                        userLikePost == null
                                    ? _unLikePost(userLikePost?.id ?? '')
                                    : _likePost(model.id!);
                              });
                              // Thiết lập thời gian chờ 1 giây
                              Future.delayed(Duration(seconds: 1), () {
                                _isLikePressed = false;
                              });
                            }
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
                              listComment: listCommentPost ?? [],
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
}
