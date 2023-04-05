import 'package:fafte/controller/auth_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fafte/theme/assets.dart';
import 'package:fafte/ui/widget/appbar/appbar.dart';
import 'package:fafte/ui/widget/button/text_button.dart';
import 'package:fafte/ui/widget/container/spacing_box.dart';
import 'package:fafte/ui/widget/textfield/textfield.dart';
import 'package:fafte/utils/string_utils.dart';
import 'package:fafte/utils/snackbars_utils.dart';

import 'package:fafte/utils/export.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

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
          child: Stack(children: [
        Column(
          children: [
            BuildAppBar(name: S.current.forgetPassword),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(Sizes.s8),
                        child: Image.asset(Assets.createPassword),
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
                              Text(
                                S.current.chooseASecurePasswordThatWillBe,
                                style: pt16Regular(context),
                              ),
                              SpacingBox(
                                h: 3,
                              ),
                              Text(
                                S.current.easyForYouToRemember,
                                style: pt16Regular(context),
                              ),
                              SpacingBox(
                                h: 29,
                              ),
                              BuildTextField(
                                validator: (value) {
                                  if (!StringValidator(value!).isValidEmail()) {
                                    return 'Email invalid';
                                  }
                                  final error = validate(
                                      value, S.current.email.toLowerCase());
                                  if (error != null) {
                                    return error;
                                  } else {
                                    return null;
                                  }
                                },
                                controller: _emailController,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(Sizes.s12),
                                  child: SvgPicture.asset(Assets.mail),
                                ),
                                hintText: S.current.email,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: Sizes.s14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      BuildTextLinearButton(
                        padding: EdgeInsets.symmetric(horizontal: Sizes.s20),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            AuthController.instance
                                .resetPassword(
                              _emailController.text,
                            )
                                .then((response) {
                              if (response.success) {
                                Navigator.pop(context);
                              } else {
                                ContextExtensions(context)
                                    .showSnackBar(response.message);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }).catchError((error) {
                              setState(() {
                                isLoading = true;
                              });
                              ContextExtensions(context).showSnackBar(error);
                            });
                          }
                        },
                        text: S.current.sendPassword,
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
            ),
          ],
        ),
        if (isLoading)
          Container(
            width: deviceWidth(context),
            height: deviceHeight(context),
            color: white.withOpacity(0.7),
            child: Center(
              child: CircularProgressIndicator(
                color: splashColor,
              ),
            ),
          ),
      ])),
    );
  }
}
