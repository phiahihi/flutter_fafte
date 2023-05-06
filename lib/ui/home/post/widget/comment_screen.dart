import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/models/comment.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:fafte/utils/export.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();
  PostController? controller;
  bool isLoading = false;
  String comment = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (controller == null) {
      controller = Provider.of<PostController>(context);
      controller?.getCommentPostById(widget.postId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
          // minChildSize: 0.5,
          initialChildSize: 1,
          builder: (_, _controller) {
            return Container(
              color: white,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(Sizes.s8),
                        child: Row(
                          children: [
                            Spacer(),
                            if (controller!.listCommentPostById.length <= 0)
                              Text(
                                'Bình luận',
                                style: pt16Bold(context),
                              )
                            else
                              Text(
                                  'Có ${controller!.listCommentPostById.length} bình luận',
                                  style: pt16Bold(context)),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _controller,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: Sizes.s16)
                                        .copyWith(bottom: Sizes.s72),
                                child:
                                    controller!.listCommentPostById.length > 0
                                        ? _buildListComment()
                                        : Center(
                                            child: Text(
                                              'Không có bình luận nào',
                                              style: pt16Regular(context),
                                            ),
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                                controller: _commentController,
                                hintText: 'Viết bình luận...',
                                hintStyle: pt14Regular(context),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (isLoading) return;
                                if (_commentController.text.isNotEmpty) {
                                  controller?.commentText =
                                      _commentController.text;
                                  setState(() {
                                    isLoading = true;
                                  });

                                  _commentController.clear();

                                  controller!
                                      .commentPost(widget.postId)
                                      .then((response) {
                                    if (response.success) {
                                      print(response.success);

                                      controller
                                          ?.getCommentPostById(widget.postId);
                                      setState(() {
                                        isLoading = false;
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
                                  color: comment != '' &&
                                          !isLoading &&
                                          comment.length > 0
                                      ? splashColor
                                      : textColor,
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
          }),
    );
  }

  Widget _buildListComment() {
    return ListView.separated(
      separatorBuilder: (context, index) => SpacingBox(h: 8),
      shrinkWrap: true,
      reverse: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return FutureBuilder<UserModel>(
          future: controller
              ?.getPoster(controller!.listCommentPostById[index].userId!),
          builder: (context, snapshot) {
            final user = snapshot.data;
            return _buildItemComment(
                controller!.listCommentPostById[index], user);
          },
        );
      },
      itemCount: controller!.listCommentPostById.length,
    );
  }

  _buildItemComment(CommentModel commentModel, UserModel? user) {
    return InkWell(
      onLongPress: () {
        if (controller?.auth.currentUser?.uid == commentModel.userId) {
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
                    controller?.deleteCommentPostById(commentModel.id ?? '');
                    controller?.getCommentPostById(widget.postId);

                    Navigator.pop(context);
                    Get.back();
                  },
                  child: Text('Xóa'),
                ),
              ],
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user?.profileImageUrl != null || user?.profileImageUrl != ''
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      user?.profileImageUrl ?? '',
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
      ),
    );
  }
}
