import 'dart:io';

import 'package:fafte/controller/auth_controller.dart';
import 'package:fafte/ui/authenticate/welcome_login/welcome_login.dart';
import 'package:fafte/ui/authenticate/welcome_v2_login/welcome_v2_login.dart';
import 'package:fafte/ui/home/main_screen/main_screen.dart';
import 'package:fafte/utils/string_utils.dart';
import 'package:fafte/utils/snackbars_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/appbar/appbar.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/export.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  final bool isSignup;
  const SignupScreen({super.key, this.isSignup = false});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool isLoading = false;

  final authController = AuthController.instance;

  bool isAgree = false;

  final _formKey = GlobalKey<FormState>();

  String? validate(String? value, String error) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng điền $error';
    }
    return null;
  }

  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
          child: Stack(children: [
        Column(
          children: [
            BuildAppBar(name: 'Đăng ký'),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                              GestureDetector(
                                onTap: _pickImage,
                                child: _pickedImage == null
                                    ? Container(
                                        width: Sizes.s100,
                                        height: Sizes.s100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: whiteAccent,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(Sizes.s32),
                                          child:
                                              SvgPicture.asset(Assets.camera),
                                        ),
                                      )
                                    : Container(
                                        width: Sizes.s100,
                                        height: Sizes.s100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: whiteAccent,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.file(
                                            File(_pickedImage!.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                              const SpacingBox(
                                h: 20,
                              ),
                              BuildTextField(
                                  controller: _fullNameController,
                                  validator: (value) {
                                    final error = validate(value, 'họ và tên');
                                    if (error != null) {
                                      return error;
                                    } else {
                                      return null;
                                    }
                                  },
                                  hintText: 'Họ và tên',
                                  contentPadding: EdgeInsets.all(Sizes.s14)),
                              const SpacingBox(h: 16),
                              BuildTextField(
                                  validator: (value) {
                                    if (!StringValidator(value!)
                                        .isValidPhone()) {
                                      return 'Số điện thoại không hợp lệ';
                                    }
                                    final error =
                                        validate(value, 'số điện thoại');
                                    if (error != null) {
                                      return error;
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _phoneNumberController,
                                  hintText: 'Số điện thoại',
                                  contentPadding: EdgeInsets.all(Sizes.s14)),
                              const SpacingBox(
                                h: 16,
                              ),
                              BuildTextField(
                                  validator: (value) {
                                    if (!StringValidator(value!)
                                        .isValidEmail()) {
                                      return 'Email không hợp lệ';
                                    }
                                    final error =
                                        validate(value, 'email đăng nhập');
                                    if (error != null) {
                                      return error;
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _emailController,
                                  hintText: S.current.email,
                                  contentPadding: EdgeInsets.all(Sizes.s14)),
                              const SpacingBox(
                                h: 16,
                              ),
                              BuildTextField(
                                  validator: (value) {
                                    if (!StringValidator(value!).isPassword()) {
                                      return 'Mật khẩu phải có ít nhất 8 ký tự, 1 chữ hoa, 1 chữ thường và 1 số';
                                    }
                                    final error =
                                        validate(value, 'mật khẩu đăng nhập');
                                    if (error != null) {
                                      return error;
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _passwordController,
                                  hintText: 'Mật khẩu',
                                  contentPadding: EdgeInsets.all(Sizes.s14)),
                              const SpacingBox(
                                h: 16,
                              ),
                              BuildTextField(
                                  validator: (value) {
                                    if (_passwordController.text != value) {
                                      return 'Mật khẩu không khớp';
                                    }
                                    final error = validate(
                                        value, 'xac nhận mật khẩu đăng nhập');
                                    if (error != null) {
                                      return error;
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _confirmPasswordController,
                                  hintText: 'Xác nhận mật khẩu',
                                  contentPadding: EdgeInsets.all(Sizes.s14)),
                              const SpacingBox(
                                h: 29,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(Sizes.s4),
                                    ),
                                    activeColor: splashColor,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    // useTapTarget: false,
                                    value: isAgree,
                                    onChanged: (value) {
                                      setState(() {
                                        isAgree = value!;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bằng cách tạo tài khoản, bạn đồng ý với Điều khoản dịch vụ và Chính sách quyền riêng tư của chúng tôi',
                                          style: pt16Regular(context)
                                              .copyWith(color: splashColor),
                                        ),
                                        // Text(
                                        //   S.current
                                        //       .ourTermsOfServiceAndPrivacyPolicy,
                                        //   style: pt16Regular(context)
                                        //       .copyWith(color: splashColor),
                                        // ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SpacingBox(
                                h: 24,
                              ),
                              BuildTextLinearButton(
                                padding: EdgeInsets.zero,
                                onTap: () {
                                  if (isAgree) {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      authController
                                          .register(
                                        _emailController.text,
                                        _confirmPasswordController.text,
                                        _fullNameController.text,
                                        _pickedImage?.path,
                                        _phoneNumberController.text,
                                      )
                                          .then((response) {
                                        if (response.success) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          navigateTo(const WelcomeLoginScreen(),
                                              clearStack: true);
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
                                  }
                                },
                                text: 'Đăng ký',
                                style: pt16Regular(context).copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Sizes.s18,
                                  color: white,
                                ),
                                colors: [
                                  isAgree
                                      ? pink2LightGradient
                                      : pink2LightGradient.withOpacity(0.5),
                                  isAgree
                                      ? pink2DarkGradient
                                      : pink2DarkGradient.withOpacity(0.5),
                                ],
                              ),
                              const SpacingBox(
                                h: 23,
                              ),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Bạn đã có tài khoản ?',
                                      style: pt16Regular(context),
                                    ),
                                    const SpacingBox(
                                      w: 4,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (widget.isSignup) {
                                          navigateTo(WelcomeV2LoginScreen());
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text(
                                        'Đăng nhập !',
                                        style: pt16Bold(context)
                                            .copyWith(color: blueAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
      ])),
    );
  }
}
