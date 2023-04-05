import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/models/comment.dart';
import 'package:fafte/models/user.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/date_time_utils.dart';
import 'package:fafte/utils/export.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final List<CommentModel> listComment;
  const CommentScreen(
      {super.key, required this.postId, required this.listComment});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();
  PostController? controller;
  bool isLoading = false;
  String comment = '';

  @override
  void initState() {
    super.initState();
  }

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
    return DraggableScrollableSheet(
        initialChildSize: 0.95,
        // minChildSize: 0.5,
        maxChildSize: 0.95,
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
                          if (widget.listComment.length <= 0)
                            Text(
                              'Bình luận',
                              style: pt16Bold(context),
                            )
                          else
                            Text('Có ${widget.listComment.length} bình luận',
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
                              padding: EdgeInsets.symmetric(vertical: Sizes.s16)
                                  .copyWith(bottom: Sizes.s72),
                              child: widget.listComment.length > 0
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
                                widget.listComment.add(CommentModel(
                                  userId: controller?.auth.currentUser?.uid,
                                  postId: widget.postId,
                                  commentText: _commentController.text,
                                  timestamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                ));
                                controller!
                                    .commentPost(widget.postId)
                                    .then((response) {
                                  if (response.success) {
                                    print(response.success);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    controller?.getAllCommentPost();
                                    _commentController.clear();
                                  } else {
                                    print(response.message);
                                    _commentController.clear();

                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }).catchError((error) {
                                  print(error);
                                  _commentController.clear();

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
                                color: comment != '' && !isLoading
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
        });
  }

  Widget _buildListComment() {
    return ListView.separated(
      separatorBuilder: (context, index) => SpacingBox(h: 8),
      shrinkWrap: true,
      reverse: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return FutureBuilder<UserModel>(
          future: controller?.getPoster(widget.listComment[index].userId!),
          builder: (context, snapshot) {
            final user = snapshot.data;
            return _buildItemComment(widget.listComment[index], user);
          },
        );
      },
      itemCount: widget.listComment.length,
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
}
