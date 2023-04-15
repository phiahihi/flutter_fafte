import 'package:fafte/controller/auth_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/appbar/appbar.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/export.dart';
import 'package:fafte/utils/snackbars_utils.dart';
import 'package:fafte/utils/string_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final provider = AuthController.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool isShowOldPassword = true;
  bool isShowPassword = true;
  bool isShowConfirmPassword = true;

  String? validate(String? value, String error) {
    if (value == null || value.isEmpty) {
      return 'Please enter $error';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BuildAppBar(name: 'Đổi mật khẩu'),
                Form(
                  key: _formKey,
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(Sizes.s8),
                            child: Image.asset(Assets.changePassword),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                    horizontal: Sizes.s20, vertical: Sizes.s26)
                                .copyWith(top: Sizes.s17),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Sizes.s20, vertical: Sizes.s30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Sizes.s20),
                                color: white,
                              ),
                              child: Column(
                                children: [
                                  BuildTextField(
                                    maxLines: 1,
                                    controller: _oldPasswordController,
                                    validator: (value) {
                                      if (!StringValidator(value!)
                                          .isPassword()) {
                                        return 'Mật khẩu cũ không hợp lệ';
                                      }
                                      final error = validate(value,
                                          S.current.password.toLowerCase());
                                      if (error != null) {
                                        return error;
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: isShowOldPassword,
                                    hintText: 'Mật khẩu cũ',
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(Sizes.s14)
                                          .copyWith(left: 0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShowOldPassword =
                                                !isShowOldPassword;
                                          });
                                        },
                                        child: SizedBox(
                                          width: Sizes.s20,
                                          height: Sizes.s20,
                                          child: isShowOldPassword
                                              ? Icon(
                                                  Icons.remove_red_eye,
                                                  color: blackAccent,
                                                )
                                              : SvgPicture.asset(Assets.eye),
                                        ),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                            vertical: Sizes.s14)
                                        .copyWith(
                                      left: Sizes.s14,
                                    ),
                                  ),
                                  SpacingBox(h: 16),
                                  BuildTextField(
                                    maxLines: 1,
                                    controller: _passwordController,
                                    validator: (value) {
                                      if (!StringValidator(value!)
                                          .isPassword()) {
                                        return 'Password invalid';
                                      }
                                      final error = validate(value,
                                          S.current.password.toLowerCase());
                                      if (error != null) {
                                        return error;
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: isShowPassword,
                                    hintText: 'Mật khẩu mới',
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(Sizes.s14)
                                          .copyWith(left: 0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShowPassword = !isShowPassword;
                                          });
                                        },
                                        child: SizedBox(
                                          width: Sizes.s20,
                                          height: Sizes.s20,
                                          child: isShowPassword
                                              ? Icon(
                                                  Icons.remove_red_eye,
                                                  color: blackAccent,
                                                )
                                              : SvgPicture.asset(Assets.eye),
                                        ),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                            vertical: Sizes.s14)
                                        .copyWith(
                                      left: Sizes.s14,
                                    ),
                                  ),
                                  SpacingBox(
                                    h: 16,
                                  ),
                                  BuildTextField(
                                    maxLines: 1,
                                    controller: _confirmPasswordController,
                                    validator: (value) {
                                      if (value != _passwordController.text ||
                                          value == '' ||
                                          value == null) {
                                        return 'Confirm password invalid';
                                      } else {
                                        return null;
                                      }
                                    },
                                    obscureText: isShowConfirmPassword,
                                    hintText: 'Xác nhận mật khẩu mới',
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.all(Sizes.s14)
                                          .copyWith(left: 0),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShowConfirmPassword =
                                                !isShowConfirmPassword;
                                          });
                                        },
                                        child: SizedBox(
                                          width: Sizes.s20,
                                          height: Sizes.s20,
                                          child: isShowConfirmPassword
                                              ? Icon(
                                                  Icons.remove_red_eye,
                                                  color: blackAccent,
                                                )
                                              : SvgPicture.asset(Assets.eye),
                                        ),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                            vertical: Sizes.s14)
                                        .copyWith(
                                      left: Sizes.s14,
                                    ),
                                  ),
                                  SpacingBox(
                                    h: 20,
                                  ),
                                  BuildTextLinearButton(
                                    padding: EdgeInsets.zero,
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        provider
                                            .changePassword(
                                                provider
                                                    .auth.currentUser!.email!,
                                                _oldPasswordController.text,
                                                _confirmPasswordController.text)
                                            .then((response) {
                                          if (response.success) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Navigator.pop(context);
                                            ContextExtensions(context)
                                                .showSnackBar(response.message);
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            ContextExtensions(context)
                                                .showSnackBar(response.message);
                                          }
                                        }).catchError((error) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ContextExtensions(context)
                                              .showSnackBar(error);
                                        });
                                      }
                                    },
                                    text: 'Lưu thay đổi',
                                    style: pt16Regular(context).copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: Sizes.s18,
                                      color: white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
              )
          ],
        ),
      ),
    );
  }
}
