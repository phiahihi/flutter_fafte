import 'dart:io';

import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/models/post.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel postModel;
  const EditPostScreen({super.key, required this.postModel});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  bool isLoading = false;
  TextEditingController _postController = TextEditingController();
  final _controller = PostController.instance;

  bool enable() {
    if (_controller.pickedImage != null ||
        widget.postModel.postImageUrl != '') {
      return true;
    } else {
      if (_postController.text != '') {
        return true;
      }
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _postController.text = widget.postModel.postText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            splashRadius: Sizes.s25,
                            visualDensity: VisualDensity.compact,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: SvgPicture.asset(Assets.arrowLeft)),
                        Text(
                          'Tạo bài viết',
                          style: pt16Regular(context),
                        )
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: enable()
                              ? splashColor
                              : splashColor.withOpacity(0.1)),
                      onPressed: () {
                        if (enable()) {
                          _controller.postText = _postController.text;
                          setState(() {
                            isLoading = true;
                          });
                          _controller
                              .updatePostId(widget.postModel.id ?? '')
                              .then((response) async {
                            if (response.success) {
                              print(response.success);
                              setState(() {
                                isLoading = false;
                              });

                              _controller.clear();
                              await _controller.getAllPost();
                              await _controller.getLikePost();
                              setState(() {});
                              Navigator.pop(context);
                              Navigator.pop(context);
                            } else {
                              print(response.message);
                              _controller.clear();

                              setState(() {
                                isLoading = false;
                              });
                            }
                          }).catchError((error) {
                            print(error);
                            _controller.clear();

                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      },
                      child: Text(
                        'Đăng',
                        style: pt14Regular(context).copyWith(color: white),
                      ),
                    )
                  ],
                ),
              ),
              SpacingBox(
                h: 24,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Sizes.s16),
                child: BuildTextField(
                  controller: _postController,
                  hintText: 'Bạn đang nghĩ gì ?',
                  hintStyle: pt16Regular(context),
                  borderRadius: BorderRadius.circular(Sizes.s8),
                  maxLines: 5,
                  borderSide: BorderSide(color: splashColor),
                ),
              ),
              SpacingBox(
                h: 24,
              ),
              Expanded(
                  child: Center(
                      child: GestureDetector(
                onTap: () async {
                  await _controller.pickImage();
                  setState(() {});
                },
                child: Container(
                  width: deviceWidth(context) * 0.8,
                  height: deviceHeight(context) / 2,
                  decoration: BoxDecoration(
                      color: splashColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Sizes.s12),
                      border: Border.all(color: splashColor)),
                  child: _controller.pickedImage == null &&
                          widget.postModel.postImageUrl == ''
                      ? Center(
                          child: SvgPicture.asset(
                            Assets.camera,
                            color: splashColor,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(Sizes.s12),
                          child: _controller.pickedImage != null
                              ? Image.file(
                                  File(_controller.pickedImage!.path),
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.postModel.postImageUrl ?? '',
                                  fit: BoxFit.cover,
                                )),
                ),
              )))
            ],
          ),
        ),
        if (isLoading)
          Container(
            width: deviceWidth(context),
            height: deviceHeight(context),
            color: white.withOpacity(0.8),
            child: Center(
              child: CircularProgressIndicator(
                color: splashColor,
              ),
            ),
          ),
      ]),
    );
  }
}
