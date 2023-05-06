import 'dart:io';

import 'package:fafte/controller/post_controller.dart';
import 'package:fafte/controller/user_controller.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/home/personal/personal.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/export.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemPostButton extends StatefulWidget {
  const ItemPostButton({super.key});

  @override
  State<ItemPostButton> createState() => _ItemPostButtonState();
}

class _ItemPostButtonState extends State<ItemPostButton> {
  @override
  Widget build(BuildContext context) {
    final _controller = PostController.instance;
    final _userController = UserController.instance;

    bool isLoading = false;
    TextEditingController _postController = TextEditingController();

    bool enable() {
      if (_controller.pickedImage != null) {
        return true;
      } else {
        if (_postController.text != '') {
          return true;
        }
        return false;
      }
    }

    void _showBottomSheetPost() {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        useSafeArea: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Stack(children: [
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
                                  _controller.sendPost().then((response) async {
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
                                style:
                                    pt14Regular(context).copyWith(color: white),
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
                          child: _controller.pickedImage == null
                              ? Center(
                                  child: SvgPicture.asset(
                                    Assets.camera,
                                    color: splashColor,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Sizes.s12),
                                  child: Image.file(
                                    File(_controller.pickedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
              ]);
            },
          );
        },
      );
    }

    return Container(
      color: white,
      child: Padding(
        padding: EdgeInsets.all(Sizes.s16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                navigateTo(PersonalScreen(
                  model: _userController.userModel,
                ));
              },
              child: CircleAvatar(
                backgroundImage:
                    _userController.userModel?.profileImageUrl != null ||
                            _userController.userModel?.profileImageUrl != ''
                        ? NetworkImage(
                            _userController.userModel?.profileImageUrl ?? '')
                        : null,
              ),
            ),
            SpacingBox(
              w: 8,
            ),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  side: BorderSide(color: splashColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Sizes.s24),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: Sizes.s16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bạn đang nghĩ gì ?',
                      style: pt14Regular(context),
                    ),
                  ),
                ),
                onPressed: _showBottomSheetPost,
              ),
            )
          ],
        ),
      ),
    );
  }
}
