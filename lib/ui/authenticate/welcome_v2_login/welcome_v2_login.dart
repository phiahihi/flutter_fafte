import 'package:fafte/controller/auth_controller.dart';
import 'package:fafte/ui/authenticate/forget_password/forget_password.dart';
import 'package:fafte/ui/authenticate/signup/signup.dart';
import 'package:fafte/ui/home/main_screen/main_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/appbar/appbar.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/export.dart';
import 'package:fafte/utils/string_utils.dart';
import 'package:fafte/utils/snackbars_utils.dart';

class WelcomeV2LoginScreen extends StatefulWidget {
  final bool isLogin;
  const WelcomeV2LoginScreen({super.key, this.isLogin = false});

  @override
  State<WelcomeV2LoginScreen> createState() => _WelcomeV2LoginScreenState();
}

class _WelcomeV2LoginScreenState extends State<WelcomeV2LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? validate(String? value, String error) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng điền $error';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteAccent,
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              BuildAppBar(name: 'Đăng nhập'),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(Sizes.s8),
                          child: Image.asset(Assets.login),
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
                                  controller: _emailController,
                                  validator: (value) {
                                    if (!StringValidator(value!)
                                        .isValidEmail()) {
                                      return 'Email không hợp lệ';
                                    }
                                    final error = validate(
                                        value, S.current.email.toLowerCase());
                                    if (error != null) {
                                      return error;
                                    } else {
                                      return null;
                                    }
                                  },
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(Sizes.s12),
                                    child: SvgPicture.asset(Assets.mail),
                                  ),
                                  hintText: S.current.email,
                                ),
                                SpacingBox(
                                  h: 16,
                                ),
                                BuildTextField(
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (!StringValidator(value!).isPassword()) {
                                      return 'Mật khẩu phải có ít nhất 8 ký tự';
                                    }
                                    final error = validate(value, 'mật khẩu');
                                    if (error != null) {
                                      return error;
                                    } else {
                                      return null;
                                    }
                                  },
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(Sizes.s12),
                                    child: SvgPicture.asset(Assets.lock),
                                  ),
                                  hintText: 'Mật khẩu',
                                ),
                                SpacingBox(h: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
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
                                          value: true,
                                          onChanged: (value) {},
                                        ),
                                        Text(
                                          'Nhớ mật khẩu',
                                          style: pt16Regular(context),
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        navigateTo(ForgetPasswordScreen());
                                      },
                                      child: Text(
                                        'Quên mật khẩu?',
                                        style: pt16Regular(context)
                                            .copyWith(color: blueAccent),
                                      ),
                                    ),
                                  ],
                                ),
                                SpacingBox(
                                  h: 26,
                                ),
                                BuildTextLinearButton(
                                  padding: EdgeInsets.zero,
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      AuthController.instance
                                          .signIn(_emailController.text,
                                              _passwordController.text)
                                          .then((response) {
                                        if (response.success) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          navigateTo(const MainScreen(),
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
                                  },
                                  text: 'Đăng nhập',
                                  style: pt16Regular(context).copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Sizes.s18,
                                    color: white,
                                  ),
                                ),
                                SpacingBox(h: 16),
                                BuildTextLinearButton(
                                  colors: [
                                    yellowLightGradient,
                                    yellowDarkGradient
                                  ],
                                  padding: EdgeInsets.zero,
                                  onTap: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    AuthController.instance
                                        .signInWithGoogle()
                                        .then((response) {
                                      if (response.success) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        navigateTo(const MainScreen(),
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
                                  },
                                  text: 'Đăng nhập với Google',
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
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Bạn chưa có tài khoản? ',
                                style: pt16Regular(context).copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SpacingBox(
                                w: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (widget.isLogin) {
                                    navigateTo(SignupScreen());
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  'Đăng ký!',
                                  style: pt16Regular(context).copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: blueAccent),
                                ),
                              )
                            ],
                          ),
                        ),
                        SpacingBox(
                          h: 32,
                        )
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
        ]),
      ),
    );
  }
}
